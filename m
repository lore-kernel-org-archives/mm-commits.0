From: akpm@linux-foundation.org
Subject: + plip-driver-convert-killed_timer_sem-to-completion.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:16:16 -0800
Message-ID: <200712120516.lBC5GGSc026949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbXLLFQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, jeff@garzik.org


The patch titled
     PLIP driver: convert killed_timer_sem to completion
has been added to the -mm tree.  Its filename is
     plip-driver-convert-killed_timer_sem-to-completion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PLIP driver: convert killed_timer_sem to completion
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

PLIP driver: convert the semaphore killed_timer_sem to a completion

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/plip.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/plip.c~plip-driver-convert-killed_timer_sem-to-completion drivers/net/plip.c
--- a/drivers/net/plip.c~plip-driver-convert-killed_timer_sem-to-completion
+++ a/drivers/net/plip.c
@@ -106,6 +106,7 @@ static const char version[] = "NET3 PLIP
 #include <linux/if_plip.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <linux/parport.h>
 #include <linux/bitops.h>
 
@@ -114,7 +115,6 @@ static const char version[] = "NET3 PLIP
 #include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
-#include <asm/semaphore.h>
 
 /* Maximum number of devices to support. */
 #define PLIP_MAX  8
@@ -221,7 +221,7 @@ struct net_local {
 	int should_relinquish;
 	spinlock_t lock;
 	atomic_t kill_timer;
-	struct semaphore killed_timer_sem;
+	struct completion killed_timer_cmp;
 };
 
 static inline void enable_parport_interrupts (struct net_device *dev)
@@ -385,7 +385,7 @@ plip_timer_bh(struct work_struct *work)
 		schedule_delayed_work(&nl->timer, 1);
 	}
 	else {
-		up (&nl->killed_timer_sem);
+		complete(&nl->killed_timer_cmp);
 	}
 }
 
@@ -1112,9 +1112,9 @@ plip_close(struct net_device *dev)
 
 	if (dev->irq == -1)
 	{
-		init_MUTEX_LOCKED (&nl->killed_timer_sem);
+		init_completion(&nl->killed_timer_cmp);
 		atomic_set (&nl->kill_timer, 1);
-		down (&nl->killed_timer_sem);
+		wait_for_completion(&nl->killed_timer_cmp);
 	}
 
 #ifdef NOTDEF
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch
git-dvb.patch
git-infiniband.patch
git-netdev-all.patch
plip-driver-convert-killed_timer_sem-to-completion.patch
git-scsi-misc.patch
edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
usb-testing-driver-convert-dev-sem-to-mutex.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
