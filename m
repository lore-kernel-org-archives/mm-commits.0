From: akpm@linux-foundation.org
Subject: + oom-split-out-forced-oom-killer.patch added to -mm tree
Date: Tue, 02 Jun 2015 15:09:15 -0700
Message-ID: <556e298b.mRLFZoipbCqvYxhd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbbFBWJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 18:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: split out forced OOM killer
has been added to the -mm tree.  Its filename is
     oom-split-out-forced-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-split-out-forced-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-split-out-forced-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: split out forced OOM killer

OOM killer might be triggered externally via sysrq+f.  This is supposed to
kill a task no matter what e.g.  a task is selected even though there is
an OOM victim on the way to exit.  This is a big hammer for an admin to
help to resolve a memory short condition when the system is not able to
cope with it on its own in a reasonable time frame (e.g.  when the system
is trashing or the OOM killer cannot make sufficient progress).

The forced OOM killing is currently wired into out_of_memory() call which
is kind of ugly because generic out_of_memory path has to deal with
configuration settings and heuristics which are completely irrelevant to
the forced OOM killer (e.g.  sysctl_oom_kill_allocating_task or OOM killer
prevention for already dying tasks).  Some of those will not apply to
sysrq because the handler runs from the worker context.

check_panic_on_oom on the other hand will work and that is kind of
unexpected because sysrq+f should be usable to kill a mem hog whether the
global OOM policy is to panic or not.  It also doesn't make much sense to
panic the system when no task cannot be killed because admin has a
separate sysrq for that purpose.

Let's pull forced OOM killer code out into a separate function
(force_out_of_memory) which is really trivial now.  Also extract the core
of oom_kill_process into __oom_kill_process which doesn't do any OOM
prevention heuristics.

As a bonus we can clearly state that this is a forced OOM killer in the
OOM message which is helpful to distinguish it from the regular OOM
killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    3 -
 include/linux/oom.h |    3 +
 mm/oom_kill.c       |   73 +++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c     |    2 -
 4 files changed, 58 insertions(+), 23 deletions(-)

diff -puN drivers/tty/sysrq.c~oom-split-out-forced-oom-killer drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~oom-split-out-forced-oom-killer
+++ a/drivers/tty/sysrq.c
@@ -357,8 +357,7 @@ static struct sysrq_key_op sysrq_term_op
 static void moom_callback(struct work_struct *ignored)
 {
 	mutex_lock(&oom_lock);
-	if (!out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL),
-			   GFP_KERNEL, 0, NULL, true))
+	if (!force_out_of_memory())
 		pr_info("OOM request ignored because killer is disabled\n");
 	mutex_unlock(&oom_lock);
 }
diff -puN include/linux/oom.h~oom-split-out-forced-oom-killer include/linux/oom.h
--- a/include/linux/oom.h~oom-split-out-forced-oom-killer
+++ a/include/linux/oom.h
@@ -70,8 +70,9 @@ extern enum oom_scan_t oom_scan_process_
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
 
+extern bool force_out_of_memory(void);
 extern bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		int order, nodemask_t *mask, bool force_kill);
+		int order, nodemask_t *mask);
 
 extern void exit_oom_victim(void);
 
diff -puN mm/oom_kill.c~oom-split-out-forced-oom-killer mm/oom_kill.c
--- a/mm/oom_kill.c~oom-split-out-forced-oom-killer
+++ a/mm/oom_kill.c
@@ -487,7 +487,7 @@ void oom_killer_enable(void)
  * Must be called while holding a reference to p, which will be released upon
  * returning.
  */
-void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+static void __oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		      unsigned int points, unsigned long totalpages,
 		      struct mem_cgroup *memcg, nodemask_t *nodemask,
 		      const char *message)
@@ -500,19 +500,6 @@ void oom_kill_process(struct task_struct
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
 
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just set TIF_MEMDIE so it can die quickly
-	 */
-	task_lock(p);
-	if (p->mm && task_will_free_mem(p)) {
-		mark_oom_victim(p);
-		task_unlock(p);
-		put_task_struct(p);
-		return;
-	}
-	task_unlock(p);
-
 	if (__ratelimit(&oom_rs))
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
@@ -597,6 +584,28 @@ void oom_kill_process(struct task_struct
 }
 #undef K
 
+void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+		      unsigned int points, unsigned long totalpages,
+		      struct mem_cgroup *memcg, nodemask_t *nodemask,
+		      const char *message)
+{
+	/*
+	 * If the task is already exiting, don't alarm the sysadmin or kill
+	 * its children or threads, just set TIF_MEMDIE so it can die quickly
+	 */
+	task_lock(p);
+	if (p->mm && task_will_free_mem(p)) {
+		mark_oom_victim(p);
+		task_unlock(p);
+		put_task_struct(p);
+		return;
+	}
+	task_unlock(p);
+
+	__oom_kill_process(p, gfp_mask, order, points, totalpages, memcg,
+			nodemask, message);
+}
+
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
@@ -635,12 +644,38 @@ int unregister_oom_notifier(struct notif
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
 /**
- * __out_of_memory - kill the "best" process when we run out of memory
+ * force_out_of_memory - forces OOM killer
+ *
+ * External trigger for the OOM killer. The system doesn't have to be under
+ * OOM condition (e.g. sysrq+f).
+ */
+bool force_out_of_memory(void)
+{
+	struct zonelist *zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
+	struct task_struct *p;
+	unsigned long totalpages;
+	unsigned int points;
+
+	if (oom_killer_disabled)
+		return false;
+
+	constrained_alloc(zonelist, GFP_KERNEL, NULL, &totalpages);
+	p = select_bad_process(&points, totalpages, NULL, true);
+	if (p != (void *)-1UL)
+		__oom_kill_process(p, GFP_KERNEL, 0, points, totalpages, NULL,
+				 NULL, "Forced out of memory killer");
+	else
+		pr_warn("Forced out of memory. No killable task found...\n");
+
+	return true;
+}
+
+/**
+ * out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
  * @nodemask: nodemask passed to page allocator
- * @force_kill: true if a task must be killed, even if others are exiting
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
@@ -648,7 +683,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifie
  * don't have to be perfect here, we just have to be good.
  */
 bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		   int order, nodemask_t *nodemask, bool force_kill)
+		   int order, nodemask_t *nodemask)
 {
 	const nodemask_t *mpol_mask;
 	struct task_struct *p;
@@ -699,7 +734,7 @@ bool out_of_memory(struct zonelist *zone
 		goto out;
 	}
 
-	p = select_bad_process(&points, totalpages, mpol_mask, force_kill);
+	p = select_bad_process(&points, totalpages, mpol_mask, false);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
@@ -734,7 +769,7 @@ void pagefault_out_of_memory(void)
 	if (!mutex_trylock(&oom_lock))
 		return;
 
-	if (!out_of_memory(NULL, 0, 0, NULL, false)) {
+	if (!out_of_memory(NULL, 0, 0, NULL)) {
 		/*
 		 * There shouldn't be any user tasks runnable while the
 		 * OOM killer is disabled, so the current task has to
diff -puN mm/page_alloc.c~oom-split-out-forced-oom-killer mm/page_alloc.c
--- a/mm/page_alloc.c~oom-split-out-forced-oom-killer
+++ a/mm/page_alloc.c
@@ -2724,7 +2724,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	if (out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask, false)
+	if (out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask)
 			|| WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL))
 		*did_some_progress = 1;
 out:
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-do-not-call-reclaim-if-__gfp_wait.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-only-define-hashdist-variable-when-needed.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch
oom-print-points-as-unsigned-int.patch
oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
oom-split-out-forced-oom-killer.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
linux-next.patch

