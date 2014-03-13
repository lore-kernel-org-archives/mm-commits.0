From: akpm@linux-foundation.org
Subject: +
 kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch added
 to -mm tree
Date: Thu, 13 Mar 2014 16:14:47 -0700
Message-ID: <53223be7.LRoNs7KrymkM1Q2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaCMXOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 19:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.cz, fweisbec@gmail.com, jack@suse.cz

Subject: + kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch added to -mm tree
To: jack@suse.cz,fweisbec@gmail.com,pmladek@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 16:14:47 -0700


The patch titled
     Subject: kernel: avoid softlockups in stop_machine() during heavy printing
has been added to the -mm tree.  Its filename is
     kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch

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
Subject: kernel: avoid softlockups in stop_machine() during heavy printing

When there are lots of messages accumulated in printk buffer, printing
them (especially over serial console) can take a long time (tens of
seconds).  stop_machine() will effectively make all cpus spin in
multi_cpu_stop() waiting for the CPU doing printing to print all the
messages which triggers NMI softlockup watchdog and RCU stall detector
which add even more to the messages to print.  Since machine doesn't do
anything (except serving interrupts) during this time, also network
connections are dropped and other disturbances may happen.

Paper over the problem by waiting for printk buffer to be empty before
starting to stop CPUs.  In theory a burst of new messages can be appended
to the printk buffer before CPUs enter multi_cpu_stop() so this isn't a
100% solution but it works OK in practice and I'm not aware of a
reasonably simple better solution.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/console.h |    1 +
 kernel/printk/printk.c  |   22 ++++++++++++++++++++++
 kernel/stop_machine.c   |    9 +++++++++
 3 files changed, 32 insertions(+)

diff -puN include/linux/console.h~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing include/linux/console.h
--- a/include/linux/console.h~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing
+++ a/include/linux/console.h
@@ -150,6 +150,7 @@ extern int console_trylock(void);
 extern void console_unlock(void);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
+extern void console_flush(void);
 extern struct tty_driver *console_device(int *);
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
diff -puN kernel/printk/printk.c~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing
+++ a/kernel/printk/printk.c
@@ -2299,6 +2299,28 @@ struct tty_driver *console_device(int *i
 }
 
 /*
+ * Wait until all messages accumulated in the printk buffer are printed to
+ * console. Note that as soon as this function returns, new messages may be
+ * added to the printk buffer by other CPUs.
+ */
+void console_flush(void)
+{
+	bool retry;
+	unsigned long flags;
+
+	while (1) {
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		if (!retry)
+			break;
+		/* Cycle console_sem to wait for outstanding printing */
+		console_lock();
+		console_unlock();
+	}
+}
+
+/*
  * Prevent further output on the passed console device so that (for example)
  * serial drivers can disable console output before suspending a port, and can
  * re-enable output afterwards.
diff -puN kernel/stop_machine.c~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing kernel/stop_machine.c
--- a/kernel/stop_machine.c~kernel-avoid-softlockups-in-stop_machine-during-heavy-printing
+++ a/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/console.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -574,6 +575,14 @@ int __stop_machine(int (*fn)(void *), vo
 		return ret;
 	}
 
+	/*
+	 * If there are lots of outstanding messages, printing them can take a
+	 * long time and all cpus would be spinning waiting for the printing to
+	 * finish thus triggering NMI watchdog, RCU lockups etc. Wait for the
+	 * printing here to avoid these.
+	 */
+	console_flush();
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&msdata, MULTI_STOP_PREPARE);
 	return stop_cpus(cpu_online_mask, multi_cpu_stop, &msdata);
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

