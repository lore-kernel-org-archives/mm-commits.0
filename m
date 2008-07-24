From: akpm@linux-foundation.org
Subject: - pxafb-convert-ctrlr_sem-in-a-mutex.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:45 -0700
Message-ID: <200807242331.m6ONVjTr011663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756384AbYGXXcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, daniel@caiaq.de, eric.miao@marvell.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: convert ctrlr_sem in a mutex
has been removed from the -mm tree.  Its filename was
     pxafb-convert-ctrlr_sem-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: convert ctrlr_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore ctrlr_sem is used as a mutex.  Convert it to the mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |    7 ++++---
 drivers/video/pxafb.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-convert-ctrlr_sem-in-a-mutex drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-convert-ctrlr_sem-in-a-mutex
+++ a/drivers/video/pxafb.c
@@ -41,6 +41,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
@@ -1059,7 +1060,7 @@ static void set_ctrlr_state(struct pxafb
 {
 	u_int old_state;
 
-	down(&fbi->ctrlr_sem);
+	mutex_lock(&fbi->ctrlr_lock);
 
 	old_state = fbi->state;
 
@@ -1147,7 +1148,7 @@ static void set_ctrlr_state(struct pxafb
 		}
 		break;
 	}
-	up(&fbi->ctrlr_sem);
+	mutex_unlock(&fbi->ctrlr_lock);
 }
 
 /*
@@ -1400,7 +1401,7 @@ static struct pxafb_info * __devinit pxa
 
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, pxafb_task);
-	init_MUTEX(&fbi->ctrlr_sem);
+	mutex_init(&fbi->ctrlr_lock);
 	init_completion(&fbi->disable_done);
 #ifdef CONFIG_FB_PXA_SMARTPANEL
 	init_completion(&fbi->command_done);
diff -puN drivers/video/pxafb.h~pxafb-convert-ctrlr_sem-in-a-mutex drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-convert-ctrlr_sem-in-a-mutex
+++ a/drivers/video/pxafb.h
@@ -106,7 +106,7 @@ struct pxafb_info {
 
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

