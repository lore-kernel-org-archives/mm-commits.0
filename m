From: akpm@linux-foundation.org
Subject: + w1-w1_process-block-or-sleep.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:03 -0700
Message-ID: <200807310316.m6V3G3bc001133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756072AbYGaDRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_process, block or sleep
has been added to the -mm tree.  Its filename is
     w1-w1_process-block-or-sleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1_process, block or sleep
From: David Fries <david@fries.net>

The w1_process thread's sleeping and termination has been modified. 
msleep_interruptible was replaced by schedule_timeout and schedule to
allow for kthread_stop and wake_up_process to interrupt the sleep and the
unbounded sleeping when a bus search is disabled.  The W1_MASTER_NEED_EXIT
and flags variable were removed as they were redundant with
kthread_should_stop and kthread_stop.  If w1_process is sleeping,
requesting a search will immediately wake it up rather than waiting for
the end of msleep_interruptible previously.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c     |   20 +++++++++++++++++---
 drivers/w1/w1.h     |    4 ----
 drivers/w1/w1_int.c |    2 --
 3 files changed, 17 insertions(+), 9 deletions(-)

diff -puN drivers/w1/w1.c~w1-w1_process-block-or-sleep drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-w1_process-block-or-sleep
+++ a/drivers/w1/w1.c
@@ -251,6 +251,7 @@ static ssize_t w1_master_attribute_store
 	mutex_lock(&md->mutex);
 	md->search_count = simple_strtol(buf, NULL, 0);
 	mutex_unlock(&md->mutex);
+	wake_up_process(md->thread);
 
 	return count;
 }
@@ -773,7 +774,7 @@ void w1_search(struct w1_master *dev, u8
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+			if (kthread_should_stop()) {
 				printk(KERN_INFO "Abort w1_search (exiting)\n");
 				return;
 			}
@@ -811,8 +812,12 @@ void w1_search_process(struct w1_master 
 int w1_process(void *data)
 {
 	struct w1_master *dev = (struct w1_master *) data;
+	/* As long as w1_timeout is only set by a module parameter the sleep
+	 * time can be calculated in jiffies once.
+	 */
+	const unsigned long jtime = msecs_to_jiffies(w1_timeout * 1000);
 
-	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+	while (!kthread_should_stop()) {
 		if (dev->search_count) {
 			mutex_lock(&dev->mutex);
 			w1_search_process(dev, W1_SEARCH);
@@ -820,7 +825,16 @@ int w1_process(void *data)
 		}
 
 		try_to_freeze();
-		msleep_interruptible(w1_timeout * 1000);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		if (kthread_should_stop())
+			break;
+
+		/* Only sleep when the search is active. */
+		if (dev->search_count)
+			schedule_timeout(jtime);
+		else
+			schedule();
 	}
 
 	atomic_dec(&dev->refcnt);
diff -puN drivers/w1/w1.h~w1-w1_process-block-or-sleep drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-w1_process-block-or-sleep
+++ a/drivers/w1/w1.h
@@ -149,8 +149,6 @@ struct w1_bus_master
 		u8, w1_slave_found_callback);
 };
 
-#define W1_MASTER_NEED_EXIT		0
-
 struct w1_master
 {
 	struct list_head	w1_master_entry;
@@ -169,8 +167,6 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
 
-	long			flags;
-
 	struct task_struct	*thread;
 	struct mutex		mutex;
 
diff -puN drivers/w1/w1_int.c~w1-w1_process-block-or-sleep drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-w1_process-block-or-sleep
+++ a/drivers/w1/w1_int.c
@@ -142,7 +142,6 @@ int w1_add_master_device(struct w1_bus_m
 
 #if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 #endif
 err_out_rm_attr:
@@ -158,7 +157,6 @@ void __w1_remove_master_device(struct w1
 	struct w1_netlink_msg msg;
 	struct w1_slave *sl, *sln;
 
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 
 	mutex_lock(&w1_mlock);
_

Patches currently in -mm which might be from david@fries.net are

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

