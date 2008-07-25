From: akpm@linux-foundation.org
Subject: - ata-over-ethernet-convert-emsgs_sema-in-a-completion.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:35 -0700
Message-ID: <200807252302.m6PN2Zjt003837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422AbYGYXDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     aoe: convert emsgs_sema into a completion
has been removed from the -mm tree.  Its filename was
     ata-over-ethernet-convert-emsgs_sema-in-a-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: convert emsgs_sema into a completion
From: Matthias Kaehlcke <matthias@kaehlcke.net>

ATA over Ethernet: The semaphore emsgs_sema is used for signalling an
event, convert it in a completion.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/block/aoe/aoechr.c~ata-over-ethernet-convert-emsgs_sema-in-a-completion drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~ata-over-ethernet-convert-emsgs_sema-in-a-completion
+++ a/drivers/block/aoe/aoechr.c
@@ -6,6 +6,7 @@
 
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
 #include "aoe.h"
@@ -36,7 +37,7 @@ struct ErrMsg {
 
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
-static struct semaphore emsgs_sema;
+static struct completion emsgs_comp;
 static spinlock_t emsgs_lock;
 static int nblocked_emsgs_readers;
 static struct class *aoe_class;
@@ -141,7 +142,7 @@ bail:		spin_unlock_irqrestore(&emsgs_loc
 	spin_unlock_irqrestore(&emsgs_lock, flags);
 
 	if (nblocked_emsgs_readers)
-		up(&emsgs_sema);
+		complete(&emsgs_comp);
 }
 
 static ssize_t
@@ -221,7 +222,7 @@ aoechr_read(struct file *filp, char __us
 
 		spin_unlock_irqrestore(&emsgs_lock, flags);
 
-		n = down_interruptible(&emsgs_sema);
+		n = wait_for_completion_interruptible(&emsgs_comp);
 
 		spin_lock_irqsave(&emsgs_lock, flags);
 
@@ -269,7 +270,7 @@ aoechr_init(void)
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
-	sema_init(&emsgs_sema, 0);
+	init_completion(&emsgs_comp);
 	spin_lock_init(&emsgs_lock);
 	aoe_class = class_create(THIS_MODULE, "aoe");
 	if (IS_ERR(aoe_class)) {
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

origin.patch
linux-next.patch
affs-convert-s_bmlock-into-a-mutex.patch

