From: akpm@linux-foundation.org
Subject: + oom-split-out-forced-oom-killer.patch added to -mm tree
Date: Wed, 08 Jul 2015 15:24:03 -0700
Message-ID: <559da303.fkyaRKTJMP2Mmj5S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbbGHWYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:24:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, jakobunt@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


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

The forced OOM killing is currently wired into out_of_memory() call even
though their objective is different which makes the code ugly and harder
to follow.  Generic out_of_memory path has to deal with configuration
settings and heuristics which are completely irrelevant to the forced OOM
killer (e.g.  sysctl_oom_kill_allocating_task or OOM killer prevention for
already dying tasks).  All of them are either relying on explicit
force_kill check or indirectly by checking current->mm which is always
NULL for sysrq+f.  This is not nice, hard to follow and error prone.

Let's pull forced OOM killer code out into a separate function
(force_out_of_memory) which is really trivial now.  As a bonus we can
clearly state that this is a forced OOM killer in the OOM message which is
helpful to distinguish it from the regular OOM killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Jakob Unterwurzacher <jakobunt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    9 ------
 include/linux/oom.h |    1 
 mm/oom_kill.c       |   57 ++++++++++++++++++++++++++++--------------
 3 files changed, 41 insertions(+), 26 deletions(-)

diff -puN drivers/tty/sysrq.c~oom-split-out-forced-oom-killer drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~oom-split-out-forced-oom-killer
+++ a/drivers/tty/sysrq.c
@@ -353,15 +353,8 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	const gfp_t gfp_mask = GFP_KERNEL;
-	struct oom_context oc = {
-		.zonelist = node_zonelist(first_memory_node, gfp_mask),
-		.gfp_mask = gfp_mask,
-		.force_kill = true,
-	};
-
 	mutex_lock(&oom_lock);
-	if (!out_of_memory(&oc))
+	if (!force_out_of_memory())
 		pr_info("OOM request ignored because killer is disabled\n");
 	mutex_unlock(&oom_lock);
 }
diff -puN include/linux/oom.h~oom-split-out-forced-oom-killer include/linux/oom.h
--- a/include/linux/oom.h~oom-split-out-forced-oom-killer
+++ a/include/linux/oom.h
@@ -77,6 +77,7 @@ extern enum oom_scan_t oom_scan_process_
 		struct task_struct *task, unsigned long totalpages);
 
 extern bool out_of_memory(struct oom_context *oc);
+extern bool force_out_of_memory(void);
 
 extern void exit_oom_victim(void);
 
diff -puN mm/oom_kill.c~oom-split-out-forced-oom-killer mm/oom_kill.c
--- a/mm/oom_kill.c~oom-split-out-forced-oom-killer
+++ a/mm/oom_kill.c
@@ -627,6 +627,38 @@ int unregister_oom_notifier(struct notif
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
 /**
+ * force_out_of_memory - forces OOM killer to kill a process
+ *
+ * Explicitly trigger the OOM killer. The system doesn't have to be under
+ * OOM condition (e.g. sysrq+f).
+ */
+bool force_out_of_memory(void)
+{
+	struct task_struct *p;
+	unsigned long totalpages;
+	unsigned int points;
+	const gfp_t gfp_mask = GFP_KERNEL;
+	struct oom_context oc = {
+		.zonelist = node_zonelist(first_memory_node, gfp_mask),
+		.gfp_mask = gfp_mask,
+		.force_kill = true,
+	};
+
+	if (oom_killer_disabled)
+		return false;
+
+	constrained_alloc(&oc, &totalpages);
+	p = select_bad_process(&oc, &points, totalpages);
+	if (p != (void *)-1UL)
+		oom_kill_process(&oc, p, points, totalpages, NULL,
+				 "Forced out of memory killer");
+	else
+		pr_warn("Sysrq triggered out of memory. No killable task found...\n");
+
+	return true;
+}
+
+/**
  * out_of_memory - kill the "best" process when we run out of memory
  * @oc: pointer to struct oom_context
  *
@@ -647,12 +679,10 @@ bool out_of_memory(struct oom_context *o
 	if (oom_killer_disabled)
 		return false;
 
-	if (!oc->force_kill) {
-		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-		if (freed > 0)
-			/* Got some memory back in the last second. */
-			goto out;
-	}
+	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
+	if (freed > 0)
+		/* Got some memory back in the last second. */
+		goto out;
 
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
@@ -675,13 +705,8 @@ bool out_of_memory(struct oom_context *o
 	constraint = constrained_alloc(oc, &totalpages);
 	if (constraint != CONSTRAINT_MEMORY_POLICY)
 		oc->nodemask = NULL;
-	if (!oc->force_kill)
-		check_panic_on_oom(oc, constraint, NULL);
+	check_panic_on_oom(oc, constraint, NULL);
 
-	/*
-	 * not affecting force_kill because sysrq triggered OOM killer runs from
-	 * the workqueue context so current->mm will be NULL
-	 */
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, oc->nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
@@ -694,12 +719,8 @@ bool out_of_memory(struct oom_context *o
 	p = select_bad_process(oc, &points, totalpages);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		if (!oc->force_kill) {
-			dump_header(oc, NULL, NULL);
-			panic("Out of memory and no killable processes...\n");
-		} else {
-			pr_info("Sysrq triggered out of memory. No killable task found...\n");
-		}
+		dump_header(oc, NULL, NULL);
+		panic("Out of memory and no killable processes...\n");
 	}
 	if (p != (void *)-1UL) {
 		oom_kill_process(oc, p, points, totalpages, NULL,
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
oom-do-not-panic-when-oom-killer-is-sysrq-triggered.patch
oom-do-not-invoke-oom-notifiers-on-sysrqf.patch
mm-oom-organize-oom-context-into-struct.patch
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

