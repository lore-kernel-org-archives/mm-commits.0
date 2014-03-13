From: akpm@linux-foundation.org
Subject: +
 printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
 added to -mm tree
Date: Thu, 13 Mar 2014 16:14:43 -0700
Message-ID: <53223be3.3XiCzqeTeyAm1aTq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaCMXOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 19:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.cz, fweisbec@gmail.com, jack@suse.cz

Subject: + printk-enable-interrupts-before-calling-console_trylock_for_printk.patch added to -mm tree
To: jack@suse.cz,fweisbec@gmail.com,pmladek@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 16:14:43 -0700


The patch titled
     Subject: printk: enable interrupts before calling console_trylock_for_printk()
has been added to the -mm tree.  Its filename is
     printk-enable-interrupts-before-calling-console_trylock_for_printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-enable-interrupts-before-calling-console_trylock_for_printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: enable interrupts before calling console_trylock_for_printk()

We need interrupts disabled when calling console_trylock_for_printk() only
so that cpu id we pass to can_use_console() remains valid (for other
things console_sem provides all the exclusion we need and deadlocks on
console_sem due to interrupts are impossible because we use
down_trylock()).  However if we are rescheduled, we are guaranteed to run
on an online cpu so we can easily just get the cpu id in
can_use_console().

We can lose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH it
can somewhat reduce interrupt latency caused by console_unlock()
especially since later in the patch series we will want to spin on
console_sem in console_trylock_for_printk().

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN kernel/printk/printk.c~printk-enable-interrupts-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-enable-interrupts-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -1314,10 +1314,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1330,8 +1329,10 @@ static inline int can_use_console(unsign
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1501,7 +1502,8 @@ asmlinkage int vprintk_emit(int facility
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1600,17 +1602,22 @@ asmlinkage int vprintk_emit(int facility
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
+
+	/*
+	 * Disable preemption to avoid being preempted while holding
+	 * console_sem which would prevent anyone from printing to console
+	 */
+	preempt_disable();
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
 	 */
-	if (console_trylock_for_printk(this_cpu))
+	if (console_trylock_for_printk())
 		console_unlock();
-
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
+	preempt_enable();
 
 	return printed_len;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

backing_dev-fix-hung-task-on-sync.patch
backing_dev-fix-hung-task-on-sync-fix.patch
bdi-avoid-oops-on-device-removal.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
printk-hand-over-printing-to-console-if-printing-too-long.patch
kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

