From: akpm@linux-foundation.org
Subject: - sa1100fb-convert-ctrlr_sem-in-a-mutex.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:48 -0700
Message-ID: <200807242331.m6ONVmGe011667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823AbYGXXbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, mm-commits@vger.kernel.org


The patch titled
     sa1100fb: convert ctrlr_sem in a mutex
has been removed from the -mm tree.  Its filename was
     sa1100fb-convert-ctrlr_sem-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sa1100fb: convert ctrlr_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore ctrlr_sem is used as a mutex.  Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sa1100fb.c |    7 ++++---
 drivers/video/sa1100fb.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/sa1100fb.c~sa1100fb-convert-ctrlr_sem-in-a-mutex drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~sa1100fb-convert-ctrlr_sem-in-a-mutex
+++ a/drivers/video/sa1100fb.c
@@ -175,6 +175,7 @@
 #include <linux/cpufreq.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/mutex.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -1108,7 +1109,7 @@ static void set_ctrlr_state(struct sa110
 {
 	u_int old_state;
 
-	down(&fbi->ctrlr_sem);
+	mutex_lock(&fbi->ctrlr_lock);
 
 	old_state = fbi->state;
 
@@ -1193,7 +1194,7 @@ static void set_ctrlr_state(struct sa110
 		}
 		break;
 	}
-	up(&fbi->ctrlr_sem);
+	mutex_unlock(&fbi->ctrlr_lock);
 }
 
 /*
@@ -1445,7 +1446,7 @@ static struct sa1100fb_info * __init sa1
 
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, sa1100fb_task);
-	init_MUTEX(&fbi->ctrlr_sem);
+	mutex_init(&fbi->ctrlr_lock);
 
 	return fbi;
 }
diff -puN drivers/video/sa1100fb.h~sa1100fb-convert-ctrlr_sem-in-a-mutex drivers/video/sa1100fb.h
--- a/drivers/video/sa1100fb.h~sa1100fb-convert-ctrlr_sem-in-a-mutex
+++ a/drivers/video/sa1100fb.h
@@ -100,7 +100,7 @@ struct sa1100fb_info {
 
 	volatile u_char		state;
 	volatile u_char		task_state;
-	struct semaphore	ctrlr_sem;
+	struct mutex		ctrlr_lock;
 	wait_queue_head_t	ctrlr_wait;
 	struct work_struct	task;
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

origin.patch
linux-next.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
hfsplus-convert-the-extents_lock-in-a-mutex.patch
ata-over-ethernet-convert-emsgs_sema-in-a-completion.patch
affs-convert-s_bmlock-into-a-mutex.patch

