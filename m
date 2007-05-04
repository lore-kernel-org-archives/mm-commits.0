From: akpm@linux-foundation.org
Subject: + scx200-use-mutex-instead-of-semaphore.patch added to -mm tree
Date: Thu, 03 May 2007 22:55:46 -0700
Message-ID: <200705040555.l445tktf030122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbXEDF4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 01:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, jim.cromie@gmail.com, khali@linux-fr.org


The patch titled
     scx200: use mutex instead of semaphore
has been added to the -mm tree.  Its filename is
     scx200-use-mutex-instead-of-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scx200: use mutex instead of semaphore
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The scx200 driver use a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/scx200_acb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/i2c/busses/scx200_acb.c~scx200-use-mutex-instead-of-semaphore drivers/i2c/busses/scx200_acb.c
--- a/drivers/i2c/busses/scx200_acb.c~scx200-use-mutex-instead-of-semaphore
+++ a/drivers/i2c/busses/scx200_acb.c
@@ -389,7 +389,7 @@ static const struct i2c_algorithm scx200
 };
 
 static struct scx200_acb_iface *scx200_acb_list;
-static DECLARE_MUTEX(scx200_acb_list_mutex);
+static DEFINE_MUTEX(scx200_acb_list_mutex);
 
 static __init int scx200_acb_probe(struct scx200_acb_iface *iface)
 {
@@ -473,10 +473,10 @@ static int __init scx200_acb_create(stru
 		return -ENODEV;
 	}
 
-	down(&scx200_acb_list_mutex);
+	mutex_lock(&scx200_acb_list_mutex);
 	iface->next = scx200_acb_list;
 	scx200_acb_list = iface;
-	up(&scx200_acb_list_mutex);
+	mutex_unlock(&scx200_acb_list_mutex);
 
 	return 0;
 }
@@ -634,10 +634,10 @@ static void __exit scx200_acb_cleanup(vo
 {
 	struct scx200_acb_iface *iface;
 
-	down(&scx200_acb_list_mutex);
+	mutex_lock(&scx200_acb_list_mutex);
 	while ((iface = scx200_acb_list) != NULL) {
 		scx200_acb_list = iface->next;
-		up(&scx200_acb_list_mutex);
+		mutex_unlock(&scx200_acb_list_mutex);
 
 		i2c_del_adapter(&iface->adapter);
 
@@ -649,9 +649,9 @@ static void __exit scx200_acb_cleanup(vo
 			release_region(iface->base, 8);
 
 		kfree(iface);
-		down(&scx200_acb_list_mutex);
+		mutex_lock(&scx200_acb_list_mutex);
 	}
-	up(&scx200_acb_list_mutex);
+	mutex_unlock(&scx200_acb_list_mutex);
 }
 
 module_init(scx200_acb_init);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
kcopyd-use-mutex-instead-of-semaphore.patch
