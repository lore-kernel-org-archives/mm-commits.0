From: akpm@linux-foundation.org
Subject: - w1-w1_process-block-or-sleep.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:49 -0700
Message-ID: <200810182319.m9INJn6v029566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYJRXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: w1_process, block or sleep
has been removed from the -mm tree.  Its filename was
     w1-w1_process-block-or-sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

