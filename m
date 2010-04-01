From: akpm@linux-foundation.org
Subject: + drivers-gpio-timbgpioc-add-missing-unlock.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:42:40 -0700
Message-ID: <201004011942.o31Jge2W005031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773Ab0DATmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, richard.rojfors@pelagicore.com


The patch titled
     drivers/gpio/timbgpio.c: add missing unlock
has been added to the -mm tree.  Its filename is
     drivers-gpio-timbgpioc-add-missing-unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
arch-powerpc-kernel-vioc-add-missing-unlock.patch
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
drivers-char-amiserialc-add-missing-local_irq_restore.patch
drivers-gpio-timbgpioc-add-missing-unlock.patch
drivers-macintosh-macio-adbc-add-missing-unlock.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch

