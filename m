From: akpm@linux-foundation.org
Subject: + cosa-srp-convert-channel_datarsem-to-mutex.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:01:01 -0800
Message-ID: <200802181001.m1IA1xSq018970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbYBRKDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, khc@pm.waw.pl


The patch titled
     COSA/SRP: convert channel_data.rsem to mutex
has been added to the -mm tree.  Its filename is
     cosa-srp-convert-channel_datarsem-to-mutex.patch

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
Subject: COSA/SRP: convert channel_data.rsem to mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

COSA/SRP driver: The semaphore channel_data.rsem is used as a mutex,
convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/cosa.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/net/wan/cosa.c~cosa-srp-convert-channel_datarsem-to-mutex drivers/net/wan/cosa.c
--- a/drivers/net/wan/cosa.c~cosa-srp-convert-channel_datarsem-to-mutex
+++ a/drivers/net/wan/cosa.c
@@ -90,6 +90,7 @@
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 
 #undef COSA_SLOW_IO	/* for testing purposes only */
@@ -127,7 +128,8 @@ struct channel_data {
 	int (*tx_done)(struct channel_data *channel, int size);
 
 	/* Character device parts */
-	struct semaphore rsem, wsem;
+	struct mutex rlock;
+	struct semaphore wsem;
 	char *rxdata;
 	int rxsize;
 	wait_queue_head_t txwaitq, rxwaitq;
@@ -807,7 +809,7 @@ static struct net_device_stats *cosa_net
 
 static void chardev_channel_init(struct channel_data *chan)
 {
-	init_MUTEX(&chan->rsem);
+	mutex_init(&chan->rlock);
 	init_MUTEX(&chan->wsem);
 }
 
@@ -825,12 +827,12 @@ static ssize_t cosa_read(struct file *fi
 			cosa->name, cosa->firmware_status);
 		return -EPERM;
 	}
-	if (down_interruptible(&chan->rsem))
+	if (mutex_lock_interruptible(&chan->rlock))
 		return -ERESTARTSYS;
 	
 	if ((chan->rxdata = kmalloc(COSA_MTU, GFP_DMA|GFP_KERNEL)) == NULL) {
 		printk(KERN_INFO "%s: cosa_read() - OOM\n", cosa->name);
-		up(&chan->rsem);
+		mutex_unlock(&chan->rlock);
 		return -ENOMEM;
 	}
 
@@ -848,7 +850,7 @@ static ssize_t cosa_read(struct file *fi
 			remove_wait_queue(&chan->rxwaitq, &wait);
 			current->state = TASK_RUNNING;
 			spin_unlock_irqrestore(&cosa->lock, flags);
-			up(&chan->rsem);
+			mutex_unlock(&chan->rlock);
 			return -ERESTARTSYS;
 		}
 	}
@@ -857,7 +859,7 @@ static ssize_t cosa_read(struct file *fi
 	kbuf = chan->rxdata;
 	count = chan->rxsize;
 	spin_unlock_irqrestore(&cosa->lock, flags);
-	up(&chan->rsem);
+	mutex_unlock(&chan->rlock);
 
 	if (copy_to_user(buf, kbuf, count)) {
 		kfree(kbuf);
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch
