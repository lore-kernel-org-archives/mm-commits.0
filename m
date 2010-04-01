From: akpm@linux-foundation.org
Subject: + drivers-char-amiserialc-add-missing-local_irq_restore.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:42:38 -0700
Message-ID: <201004011942.o31Jgdcc005025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773Ab0DATmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:42:45 -0400
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

Add local_irq_restore after the labels that can be reached after a
local_irq_save.

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

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore
+++ a/drivers/char/amiserial.c
@@ -2056,6 +2056,7 @@ fail_free_irq:
 	free_irq(IRQ_AMIGA_TBE, state);
 fail_unregister:
 	tty_unregister_driver(serial_driver);
+	local_irq_restore(flags);
 fail_release_mem_region:
 	release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
 fail_put_tty_driver:
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

