From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-capi-20-driver.patch added to -mm tree
Date: Mon, 14 May 2007 20:00:47 -0700
Message-ID: <200705150300.l4F30lJi032700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298AbXEODBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 23:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, kkeil@suse.de


The patch titled
     Use mutex instead of semaphore in CAPI 2.0 driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-capi-20-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in CAPI 2.0 driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The CAPI 2.0 driver uses a semaphore as mutex.  Use the mutex API instead of
the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi.c  |    6 +++---
 include/linux/kernelcapi.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/capi/kcapi.c~use-mutex-instead-of-semaphore-in-capi-20-driver drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~use-mutex-instead-of-semaphore-in-capi-20-driver
+++ a/drivers/isdn/capi/kcapi.c
@@ -258,7 +258,7 @@ static void recv_handler(struct work_str
 	if ((!ap) || (ap->release_in_progress))
 		return;
 
-	down(&ap->recv_sem);
+	mutex_lock(&ap->recv_mtx);
 	while ((skb = skb_dequeue(&ap->recv_queue))) {
 		if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_IND)
 			ap->nrecvdatapkt++;
@@ -267,7 +267,7 @@ static void recv_handler(struct work_str
 
 		ap->recv_message(ap, skb);
 	}
-	up(&ap->recv_sem);
+	mutex_unlock(&ap->recv_mtx);
 }
 
 void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *skb)
@@ -547,7 +547,7 @@ u16 capi20_register(struct capi20_appl *
 	ap->nsentctlpkt = 0;
 	ap->nsentdatapkt = 0;
 	ap->callback = NULL;
-	init_MUTEX(&ap->recv_sem);
+	mutex_init(&ap->recv_mtx);
 	skb_queue_head_init(&ap->recv_queue);
 	INIT_WORK(&ap->recv_work, recv_handler);
 	ap->release_in_progress = 0;
diff -puN include/linux/kernelcapi.h~use-mutex-instead-of-semaphore-in-capi-20-driver include/linux/kernelcapi.h
--- a/include/linux/kernelcapi.h~use-mutex-instead-of-semaphore-in-capi-20-driver
+++ a/include/linux/kernelcapi.h
@@ -64,7 +64,7 @@ struct capi20_appl {
 	unsigned long nrecvdatapkt;
 	unsigned long nsentctlpkt;
 	unsigned long nsentdatapkt;
-	struct semaphore recv_sem;
+	struct mutex recv_mtx;
 	struct sk_buff_head recv_queue;
 	struct work_struct recv_work;
 	int release_in_progress;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
use-mutex-instead-of-semaphore-in-ide-driver.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
