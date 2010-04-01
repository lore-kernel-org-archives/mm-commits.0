From: akpm@linux-foundation.org
Subject: + drivers-char-amiserialc-add-missing-local_irq_restore.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:51:39 -0700
Message-ID: <201004011951.o31JpdeR005503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758116Ab0DATwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, cascardo@holoscopio.com, greg@kroah.com


The patch titled
     drivers/char/amiserial.c: add missing local_irq_restore
has been added to the -mm tree.  Its filename is
     drivers-char-amiserialc-add-missing-local_irq_restore.patch

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
Subject: drivers/char/amiserial.c: add missing local_irq_restore
From: Julia Lawall <julia@diku.dk>

rs_init() is failing to restore interrupts on two error paths, and is
incorrectly calling tty_unregister_driver() with local interrupts
disabled.

Fix these things by disabling interrupts later, after the reauest_irq()
calls.


A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* local_irq_save (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

[akpm@linux-foundation.org: reimplement the fix]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore
+++ a/drivers/char/amiserial.c
@@ -2021,8 +2021,6 @@ static int __init rs_init(void)
 	state->baud_base = amiga_colorclock;
 	state->xmit_fifo_size = 1;
 
-	local_irq_save(flags);
-
 	/* set ISRs, and then disable the rx interrupts */
 	error = request_irq(IRQ_AMIGA_TBE, ser_tx_int, 0, "serial TX", state);
 	if (error)
@@ -2033,6 +2031,8 @@ static int __init rs_init(void)
 	if (error)
 		goto fail_free_irq;
 
+	local_irq_save(flags);
+
 	/* turn off Rx and Tx interrupts */
 	custom.intena = IF_RBF | IF_TBE;
 	mb();
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
drivers-gpio-timbgpioc-add-missing-unlock.patch
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

