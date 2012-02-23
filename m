From: akpm@linux-foundation.org
Subject: + mm-oom-force-oom-kill-on-sysrqf.patch added to -mm tree
Date: Thu, 23 Feb 2012 13:05:36 -0800
Message-ID: <20120223210536.B0DB1A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54126 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab2BWVFj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2012 16:05:39 -0500
Received: by wics10 with SMTP id s10so63124wic.1
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2012 13:05:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, penberg@kernel.org


The patch titled
     Subject: mm, oom: force oom kill on sysrq+f
has been added to the -mm tree.  Its filename is
     mm-oom-force-oom-kill-on-sysrqf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: force oom kill on sysrq+f

The oom killer chooses not to kill a thread if:

 - an eligible thread has already been oom killed and has yet to exit,
   and

 - an eligible thread is exiting but has yet to free all its memory and
   is not the thread attempting to currently allocate memory.

SysRq+F manually invokes the global oom killer to kill a memory-hogging
task.  This is normally done as a last resort to free memory when no
progress is being made or to test the oom killer itself.

For both uses, we always want to kill a thread and never defer.  This
patch causes SysRq+F to always kill an eligible thread and can be used to
force a kill even if another oom killed thread has failed to exit.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    2 +-
 include/linux/oom.h |    2 +-
 mm/oom_kill.c       |   17 ++++++++++-------
 mm/page_alloc.c     |    2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom-force-oom-kill-on-sysrqf drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom-force-oom-kill-on-sysrqf
+++ a/drivers/tty/sysrq.c
@@ -348,7 +348,7 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL);
+	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL, true);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff -puN include/linux/oom.h~mm-oom-force-oom-kill-on-sysrqf include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-force-oom-kill-on-sysrqf
+++ a/include/linux/oom.h
@@ -49,7 +49,7 @@ extern int try_set_zonelist_oom(struct z
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		int order, nodemask_t *mask);
+		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff -puN mm/oom_kill.c~mm-oom-force-oom-kill-on-sysrqf mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-force-oom-kill-on-sysrqf
+++ a/mm/oom_kill.c
@@ -310,7 +310,7 @@ static enum oom_constraint constrained_a
  */
 static struct task_struct *select_bad_process(unsigned int *ppoints,
 		unsigned long totalpages, struct mem_cgroup *memcg,
-		const nodemask_t *nodemask)
+		const nodemask_t *nodemask, bool force_kill)
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
@@ -336,7 +336,8 @@ static struct task_struct *select_bad_pr
 		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
 			if (unlikely(frozen(p)))
 				__thaw_task(p);
-			return ERR_PTR(-1UL);
+			if (!force_kill)
+				return ERR_PTR(-1UL);
 		}
 		if (!p->mm)
 			continue;
@@ -354,7 +355,7 @@ static struct task_struct *select_bad_pr
 			if (p == current) {
 				chosen = p;
 				*ppoints = 1000;
-			} else {
+			} else if (!force_kill) {
 				/*
 				 * If this task is not being ptraced on exit,
 				 * then wait for it to finish before killing
@@ -572,7 +573,7 @@ void mem_cgroup_out_of_memory(struct mem
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
 	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
-	p = select_bad_process(&points, limit, memcg, NULL);
+	p = select_bad_process(&points, limit, memcg, NULL, false);
 	if (p && PTR_ERR(p) != -1UL)
 		oom_kill_process(p, gfp_mask, 0, points, limit, memcg, NULL,
 				 "Memory cgroup out of memory");
@@ -687,6 +688,7 @@ static void clear_system_oom(void)
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
  * @nodemask: nodemask passed to page allocator
+ * @force_kill: true if a task must be killed, even if others are exiting
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
@@ -694,7 +696,7 @@ static void clear_system_oom(void)
  * don't have to be perfect here, we just have to be good.
  */
 void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		int order, nodemask_t *nodemask)
+		int order, nodemask_t *nodemask, bool force_kill)
 {
 	const nodemask_t *mpol_mask;
 	struct task_struct *p;
@@ -738,7 +740,8 @@ void out_of_memory(struct zonelist *zone
 		goto out;
 	}
 
-	p = select_bad_process(&points, totalpages, NULL, mpol_mask);
+	p = select_bad_process(&points, totalpages, NULL, mpol_mask,
+			       force_kill);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
@@ -770,7 +773,7 @@ out:
 void pagefault_out_of_memory(void)
 {
 	if (try_set_system_oom()) {
-		out_of_memory(NULL, 0, 0, NULL);
+		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_system_oom();
 	}
 	if (!test_thread_flag(TIF_MEMDIE))
diff -puN mm/page_alloc.c~mm-oom-force-oom-kill-on-sysrqf mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-force-oom-kill-on-sysrqf
+++ a/mm/page_alloc.c
@@ -1968,7 +1968,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order, nodemask);
+	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
 
 out:
 	clear_zonelist_oom(zonelist, gfp_mask);
_
Subject: Subject: mm, oom: force oom kill on sysrq+f

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-oom-force-oom-kill-on-sysrqf.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

