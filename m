From: akpm@linux-foundation.org
Subject: + sa1100fb-convert-ctrlr_sem-in-a-mutex.patch added to -mm tree
Date: Tue, 06 May 2008 11:48:46 -0700
Message-ID: <200805061848.m46Imkun021755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbYEFStV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net


The patch titled
     sa1100fb: convert ctrlr_sem in a mutex
has been added to the -mm tree.  Its filename is
     sa1100fb-convert-ctrlr_sem-in-a-mutex.patch

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
@@ -174,6 +174,7 @@
 #include <linux/cpufreq.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/mutex.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -1107,7 +1108,7 @@ static void set_ctrlr_state(struct sa110
 {
 	u_int old_state;
 
-	down(&fbi->ctrlr_sem);
+	mutex_lock(&fbi->ctrlr_lock);
 
 	old_state = fbi->state;
 
@@ -1192,7 +1193,7 @@ static void set_ctrlr_state(struct sa110
 		}
 		break;
 	}
-	up(&fbi->ctrlr_sem);
+	mutex_unlock(&fbi->ctrlr_lock);
 }
 
 /*
@@ -1444,7 +1445,7 @@ static struct sa1100fb_info * __init sa1
 
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

arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
pxafb-convert-ctrlr_sem-in-a-mutex.patch
sa1100fb-convert-ctrlr_sem-in-a-mutex.patch

