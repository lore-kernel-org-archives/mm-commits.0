From: akpm@linux-foundation.org
Subject: [merged] drivers-gpio-timbgpioc-add-missing-unlock.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:49:38 -0400
Message-ID: <201004071851.o37Ip4cC001260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503Ab0DGSvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, richard.rojfors@pelagicore.com, mm-commits@vger.kernel.org


The patch titled
     drivers/gpio/timbgpio.c: add missing unlock
has been removed from the -mm tree.  Its filename was
     drivers-gpio-timbgpioc-add-missing-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/timbgpio.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.  The return is
converted to a goto, to share the unlock at the end of the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/gpio/timbgpio.c~drivers-gpio-timbgpioc-add-missing-unlock drivers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~drivers-gpio-timbgpioc-add-missing-unlock
+++ a/drivers/gpio/timbgpio.c
@@ -131,6 +131,7 @@ static int timbgpio_irq_type(unsigned ir
 	unsigned long flags;
 	u32 lvr, flr, bflr = 0;
 	u32 ver;
+	int ret = 0;
 
 	if (offset < 0 || offset > tgpio->gpio.ngpio)
 		return -EINVAL;
@@ -154,8 +155,10 @@ static int timbgpio_irq_type(unsigned ir
 	}
 
 	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
-		if (ver < 3)
-			return -EINVAL;
+		if (ver < 3) {
+			ret = -EINVAL;
+			goto out;
+		}
 		else {
 			flr |= 1 << offset;
 			bflr |= 1 << offset;
@@ -175,9 +178,10 @@ static int timbgpio_irq_type(unsigned ir
 		iowrite32(bflr, tgpio->membase + TGPIO_BFLR);
 
 	iowrite32(1 << offset, tgpio->membase + TGPIO_ICR);
-	spin_unlock_irqrestore(&tgpio->lock, flags);
 
-	return 0;
+out:
+	spin_unlock_irqrestore(&tgpio->lock, flags);
+	return ret;
 }
 
 static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-powerpc-kernel-vioc-add-missing-unlock.patch
drivers-macintosh-macio-adbc-add-missing-unlock.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
arch-powerpc-platforms-pseries-use-kasprintf.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

