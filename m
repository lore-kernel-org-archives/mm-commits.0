From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-kernel-vioc-add-missing-unlock.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:12:55 -0400
Message-ID: <201004081814.o38IEOCP032330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932981Ab0DHSOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc/kernel/vio.c: add missing unlock
has been removed from the -mm tree.  Its filename was
     arch-powerpc-kernel-vioc-add-missing-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

