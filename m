From: akpm@linux-foundation.org
Subject: - w1-dont-delay-search-start.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:48 -0700
Message-ID: <200810182319.m9INJm6g029563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYJRX1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: don't delay search start
has been removed from the -mm tree.  Its filename was
     w1-dont-delay-search-start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: don't delay search start
From: David Fries <david@fries.net>

Move the creation of the w1_process thread to after the device has been
initialized.  This way w1_process doesn't have to check to see if it has
been initialized and the bus search can proceed without sleeping.  That
also eliminates two checks in the w1_process loop.  The sleep now happens
at the end of the loop not the beginning.

Also added a comment for why the atomic_set was 2.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c     |   19 ++++++-------------
 drivers/w1/w1_int.c |   26 +++++++++++++++++---------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff -puN drivers/w1/w1.c~w1-dont-delay-search-start drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-dont-delay-search-start
+++ a/drivers/w1/w1.c
@@ -813,21 +813,14 @@ int w1_process(void *data)
 	struct w1_master *dev = (struct w1_master *) data;
 
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+		if (dev->search_count) {
+			mutex_lock(&dev->mutex);
+			w1_search_process(dev, W1_SEARCH);
+			mutex_unlock(&dev->mutex);
+		}
+
 		try_to_freeze();
 		msleep_interruptible(w1_timeout * 1000);
-
-		if (kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags))
-			break;
-
-		if (!dev->initialized)
-			continue;
-
-		if (dev->search_count == 0)
-			continue;
-
-		mutex_lock(&dev->mutex);
-		w1_search_process(dev, W1_SEARCH);
-		mutex_unlock(&dev->mutex);
 	}
 
 	atomic_dec(&dev->refcnt);
diff -puN drivers/w1/w1_int.c~w1-dont-delay-search-start drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-dont-delay-search-start
+++ a/drivers/w1/w1_int.c
@@ -61,6 +61,9 @@ static struct w1_master * w1_alloc_dev(u
 	dev->slave_ttl		= slave_ttl;
         dev->search_count	= -1; /* continual scan */
 
+	/* 1 for w1_process to decrement
+	 * 1 for __w1_remove_master_device to decrement
+	 */
 	atomic_set(&dev->refcnt, 2);
 
 	INIT_LIST_HEAD(&dev->slist);
@@ -109,23 +112,23 @@ int w1_add_master_device(struct w1_bus_m
 	if (!dev)
 		return -ENOMEM;
 
+	retval =  w1_create_master_attributes(dev);
+	if (retval)
+		goto err_out_free_dev;
+
+	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
+
+	dev->initialized = 1;
+
 	dev->thread = kthread_run(&w1_process, dev, "%s", dev->name);
 	if (IS_ERR(dev->thread)) {
 		retval = PTR_ERR(dev->thread);
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=%d\n",
 			 retval);
-		goto err_out_free_dev;
+		goto err_out_rm_attr;
 	}
 
-	retval =  w1_create_master_attributes(dev);
-	if (retval)
-		goto err_out_kill_thread;
-
-	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
-
-	dev->initialized = 1;
