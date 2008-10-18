From: akpm@linux-foundation.org
Subject: - w1-w1c-s-printk-dev_dbg.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:03 -0700
Message-ID: <200810182320.m9INK3ux029646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbYJRXUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: w1.c s/printk/dev_dbg/
has been removed from the -mm tree.  Its filename was
     w1-w1c-s-printk-dev_dbg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1.c s/printk/dev_dbg/
From: David Fries <david@fries.net>

s/printk/dev_dbg/

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/w1/w1.c~w1-w1c-s-printk-dev_dbg drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-w1c-s-printk-dev_dbg
+++ a/drivers/w1/w1.c
@@ -81,10 +81,10 @@ static void w1_slave_release(struct devi
 {
 	struct w1_slave *sl = dev_to_w1_slave(dev);
 
-	printk("%s: Releasing %s.\n", __func__, sl->name);
+	dev_dbg(dev, "%s: Releasing %s.\n", __func__, sl->name);
 
 	while (atomic_read(&sl->refcnt)) {
-		printk("Waiting for %s to become free: refcnt=%d.\n",
+		dev_dbg(dev, "Waiting for %s to become free: refcnt=%d.\n",
 				sl->name, atomic_read(&sl->refcnt));
 		if (msleep_interruptible(1000))
 			flush_signals(current);
@@ -920,7 +920,7 @@ void w1_search(struct w1_master *dev, u8
 			rn |= (tmp64 << i);
 
 			if (kthread_should_stop()) {
-				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
 		}
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

