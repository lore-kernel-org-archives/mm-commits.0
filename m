From: akpm@linux-foundation.org
Subject: - macintosh-media-bay-semaphore-to-mutex.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:09 -0700
Message-ID: <200807020747.m627l9HG005627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYGBIEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     macintosh: media bay: semaphore to mutex
has been removed from the -mm tree.  Its filename was
     macintosh-media-bay-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: media bay: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/mediabay.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/macintosh/mediabay.c~macintosh-media-bay-semaphore-to-mutex drivers/macintosh/mediabay.c
--- a/drivers/macintosh/mediabay.c~macintosh-media-bay-semaphore-to-mutex
+++ a/drivers/macintosh/mediabay.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 #include <asm/prom.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -77,7 +78,7 @@ struct media_bay_info {
 	int				index;
 	int				cached_gpio;
 	int				sleeping;
-	struct semaphore		lock;
+	struct mutex			lock;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 	ide_hwif_t			*cd_port;
 	void __iomem			*cd_base;
@@ -459,27 +460,27 @@ int media_bay_set_ide_infos(struct devic
 		if (bay->mdev && which_bay == bay->mdev->ofdev.node) {
 			int timeout = 5000, index = hwif->index;
 			
-			down(&bay->lock);
+			mutex_lock(&bay->lock);
 
 			bay->cd_port	= hwif;
  			bay->cd_base	= (void __iomem *) base;
 			bay->cd_irq	= irq;
 
 			if ((MB_CD != bay->content_id) || bay->state != mb_up) {
-				up(&bay->lock);
+				mutex_unlock(&bay->lock);
 				return 0;
 			}
 			printk(KERN_DEBUG "Registered ide%d for media bay %d\n", index, i);
 			do {
 				if (MB_IDE_READY(i)) {
 					bay->cd_index	= index;
-					up(&bay->lock);
+					mutex_unlock(&bay->lock);
 					return 0;
 				}
 				mdelay(1);
 			} while(--timeout);
 			printk(KERN_DEBUG "Timeount waiting IDE in bay %d\n", i);
-			up(&bay->lock);
+			mutex_unlock(&bay->lock);
 			return -ENODEV;
 		}
 	}
@@ -616,10 +617,10 @@ static int media_bay_task(void *x)
 
 	while (!kthread_should_stop()) {
 		for (i = 0; i < media_bay_count; ++i) {
-			down(&media_bays[i].lock);
+			mutex_lock(&media_bays[i].lock);
 			if (!media_bays[i].sleeping)
 				media_bay_step(i);
-			up(&media_bays[i].lock);
+			mutex_unlock(&media_bays[i].lock);
 		}
 
 		msleep_interruptible(MB_POLL_DELAY);
@@ -659,7 +660,7 @@ static int __devinit media_bay_attach(st
 	bay->index = i;
 	bay->ops = match->data;
 	bay->sleeping = 0;
-	init_MUTEX(&bay->lock);
+	mutex_init(&bay->lock);
 
 	/* Init HW probing */
 	if (bay->ops->init)
@@ -697,10 +698,10 @@ static int media_bay_suspend(struct maci
 
 	if (state.event != mdev->ofdev.dev.power.power_state.event
 	    && (state.event & PM_EVENT_SLEEP)) {
-		down(&bay->lock);
+		mutex_lock(&bay->lock);
 		bay->sleeping = 1;
 		set_mb_power(bay, 0);
-		up(&bay->lock);
+		mutex_unlock(&bay->lock);
 		msleep(MB_POLL_DELAY);
 		mdev->ofdev.dev.power.power_state = state;
 	}
@@ -719,12 +720,12 @@ static int media_bay_resume(struct macio
 	       	   they seem to help the 3400 get it right.
 	       	 */
 	       	/* Force MB power to 0 */
-		down(&bay->lock);
+		mutex_lock(&bay->lock);
 	       	set_mb_power(bay, 0);
 		msleep(MB_POWER_DELAY);
 	       	if (bay->ops->content(bay) != bay->content_id) {
 			printk("mediabay%d: content changed during sleep...\n", bay->index);
-			up(&bay->lock);
+			mutex_unlock(&bay->lock);
 	       		return 0;
 		}
 	       	set_mb_power(bay, 1);
@@ -740,7 +741,7 @@ static int media_bay_resume(struct macio
 	       	} while((bay->state != mb_empty) &&
 	       		(bay->state != mb_up));
 		bay->sleeping = 0;
-		up(&bay->lock);
+		mutex_unlock(&bay->lock);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

linux-next.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch
likely-profiling-disable-ftrace.patch

