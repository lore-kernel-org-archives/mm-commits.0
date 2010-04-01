From: akpm@linux-foundation.org
Subject: + arch-powerpc-kernel-vioc-add-missing-unlock.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:28:55 -0700
Message-ID: <201004011928.o31JStkj004475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab0DAT3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, sfr@canb.auug.org.au


The patch titled
     arch/powerpc/kernel/vio.c: add missing unlock
has been added to the -mm tree.  Its filename is
     arch-powerpc-kernel-vioc-add-missing-unlock.patch

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
Subject: arch/powerpc/kernel/vio.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

Add an unlock before exiting the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irq (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/vio.c~arch-powerpc-kernel-vioc-add-missing-unlock arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~arch-powerpc-kernel-vioc-add-missing-unlock
+++ a/arch/powerpc/kernel/vio.c
@@ -645,8 +645,10 @@ void vio_cmo_set_dev_desired(struct vio_
 			found = 1;
 			break;
 		}
-	if (!found)
+	if (!found) {
+		spin_unlock_irqrestore(&vio_cmo.lock, flags);
 		return;
+	}
 
 	/* Increase/decrease in desired device entitlement */
 	if (desired >= viodev->cmo.desired) {
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

