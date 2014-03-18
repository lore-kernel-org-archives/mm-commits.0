From: akpm@linux-foundation.org
Subject: [to-be-updated]
 printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch removed from -mm tree
Date: Tue, 18 Mar 2014 15:43:47 -0700
Message-ID: <5328cc23.ZNs+OC4S1KitFFI/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbaCRWns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Mar 2014 18:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.cz, fweisbec@gmail.com, jack@suse.cz

Subject: [to-be-updated] printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch removed from -mm tree
To: jack@suse.cz,fweisbec@gmail.com,pmladek@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Mar 2014 15:43:47 -0700


The patch titled
     Subject: printk: release lockbuf_lock before calling console_trylock_for_printk()
has been removed from the -mm tree.  Its filename was
     printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: release lockbuf_lock before calling console_trylock_for_printk()

There's no reason to hold lockbuf_lock when entering
console_trylock_for_printk().  The first thing this function does is
calling down_trylock(console_sem) and if that fails it immediately unlocks
lockbuf_lock.  So lockbuf_lock isn't needed for that branch.  When
down_trylock() succeeds, the rest of console_trylock() is OK without
lockbuf_lock (it is called without it from other places), and the only
remaining thing in console_trylock_for_printk() is can_use_console() call.
 For that call console_sem is enough (it iterates all consoles and checks
CON_ANYTIME flag).

So we drop logbuf_lock before entering console_trylock_for_printk() which
simplifies the code.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   49 +++++++++++++--------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff -puN kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -249,9 +249,6 @@ static char __log_buf[__LOG_BUF_LEN] __a
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int logbuf_cpu = UINT_MAX;
-
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1332,36 +1329,22 @@ static inline int can_use_console(unsign
  * messages from a 'printk'. Return true (and with the
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
 {
-	int retval = 0, wake = 0;
-
-	if (console_trylock()) {
-		retval = 1;
-
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			wake = 1;
-			retval = 0;
-		}
-	}
-	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
-	if (wake)
+	if (!console_trylock())
+		return 0;
+	/*
+	 * If we can't use the console, we need to release the console
+	 * semaphore by hand to avoid flushing the buffer. We need to hold the
+	 * console semaphore in order to do this test safely.
+	 */
+	if (!can_use_console(cpu)) {
+		console_locked = 0;
 		up(&console_sem);
-	return retval;
+		return 0;
+	}
+	return 1;
 }
 
 int printk_delay_msec __read_mostly;
@@ -1494,6 +1477,9 @@ asmlinkage int vprintk_emit(int facility
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
+
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1612,13 +1598,12 @@ asmlinkage int vprintk_emit(int facility
 	}
 	printed_len += text_len;
 
+	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
-	 *
-	 * The console_trylock_for_printk() function will release 'logbuf_lock'
-	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
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
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
printk-hand-over-printing-to-console-if-printing-too-long.patch
kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

