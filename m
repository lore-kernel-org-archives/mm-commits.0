From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-rename-log_wait-to-printk_log_wait.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:08 -0700
Message-ID: <20121023200408.9EBD7100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42434 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451Ab2JWUEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:09 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so532606yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: rename log_wait to printk_log_wait
has been removed from the -mm tree.  Its filename was
     printk-rename-log_wait-to-printk_log_wait.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename log_wait to printk_log_wait

Make this generic variable more specific to the printk
subsystem to allow this variable to be used without
a specific extern.

Also update fs/proc/kmsg.c as it uses log_wait.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kmsg.c         |    4 ++--
 kernel/printk/printk.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/proc/kmsg.c~printk-rename-log_wait-to-printk_log_wait fs/proc/kmsg.c
--- a/fs/proc/kmsg.c~printk-rename-log_wait-to-printk_log_wait
+++ a/fs/proc/kmsg.c
@@ -17,7 +17,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-extern wait_queue_head_t log_wait;
+extern wait_queue_head_t printk_log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
@@ -41,7 +41,7 @@ static ssize_t kmsg_read(struct file *fi
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &log_wait, wait);
+	poll_wait(file, &printk_log_wait, wait);
 	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
 		return POLLIN | POLLRDNORM;
 	return 0;
diff -puN kernel/printk/printk.c~printk-rename-log_wait-to-printk_log_wait kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-log_wait-to-printk_log_wait
+++ a/kernel/printk/printk.c
@@ -63,7 +63,7 @@ void asmlinkage __attribute__((weak)) ea
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
+DECLARE_WAIT_QUEUE_HEAD(printk_log_wait);
 
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
@@ -447,7 +447,7 @@ static ssize_t devkmsg_read(struct file 
 		}
 
 		raw_spin_unlock_irq(&logbuf_lock);
-		ret = wait_event_interruptible(log_wait,
+		ret = wait_event_interruptible(printk_log_wait,
 					       user->seq != printk_log_next_seq);
 		if (ret)
 			goto out;
@@ -589,7 +589,7 @@ static unsigned int devkmsg_poll(struct 
 	if (!user)
 		return POLLERR|POLLNVAL;
 
-	poll_wait(file, &log_wait, wait);
+	poll_wait(file, &printk_log_wait, wait);
 
 	raw_spin_lock_irq(&logbuf_lock);
 	if (user->seq < printk_log_next_seq) {
@@ -1122,7 +1122,7 @@ int do_syslog(int type, char __user *buf
 			error = -EFAULT;
 			goto out;
 		}
-		error = wait_event_interruptible(log_wait,
+		error = wait_event_interruptible(printk_log_wait,
 						 syslog_seq != printk_log_next_seq);
 		if (error)
 			goto out;
@@ -1948,7 +1948,7 @@ void printk_tick(void)
 			printk(KERN_WARNING "[sched_delayed] %s", buf);
 		}
 		if (pending & PRINTK_PENDING_WAKEUP)
-			wake_up_interruptible(&log_wait);
+			wake_up_interruptible(&printk_log_wait);
 	}
 }
 
@@ -1961,7 +1961,7 @@ int printk_needs_cpu(int cpu)
 
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
+	if (waitqueue_active(&printk_log_wait))
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-rename-logbuf_lock-to-printk_logbuf_lock.patch
printk-rename-clear_seq-and-clear_idx-variables.patch
printk-remove-static-from-printk_-variables.patch
printk-rename-log_align-to-printk_log_align.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

