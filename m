From: akpm@linux-foundation.org
Subject: + drivers-serial-pmac_zilogc-add-missing-unlock.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:42:47 -0700
Message-ID: <201004011942.o31Jglxt005131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758677Ab0DATmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org


The patch titled
     drivers/serial/pmac_zilog.c: add missing unlock
has been added to the -mm tree.  Its filename is
     drivers-serial-pmac_zilogc-add-missing-unlock.patch

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
Subject: drivers/serial/pmac_zilog.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/pmac_zilog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/serial/pmac_zilog.c~drivers-serial-pmac_zilogc-add-missing-unlock drivers/serial/pmac_zilog.c
--- a/drivers/serial/pmac_zilog.c~drivers-serial-pmac_zilogc-add-missing-unlock
+++ a/drivers/serial/pmac_zilog.c
@@ -752,8 +752,10 @@ static void pmz_break_ctl(struct uart_po
 		uap->curregs[R5] = new_reg;
 
 		/* NOTE: Not subject to 'transmitter active' rule. */
-		if (ZS_IS_ASLEEP(uap))
+		if (ZS_IS_ASLEEP(uap)) {
+			spin_unlock_irqrestore(&port->lock, flags);
 			return;
+		}
 		write_zsreg(uap, R5, uap->curregs[R5]);
 	}
 
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

