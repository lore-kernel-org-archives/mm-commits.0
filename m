From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:54 -0400
Message-ID: <201004091754.o39HsPCV002190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab0DIRyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, huangj@brocade.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/bfa/bfad_im.c: eliminate useless code
has been removed from the -mm tree.  Its filename was
     drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/bfa/bfad_im.c: eliminate useless code
From: Julia Lawall <julia@diku.dk>

The variable bfa_itnim is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Jing Huang <huangj@brocade.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/bfa/bfad_im.c~drivers-scsi-bfa-bfad_imc-eliminate-useless-code drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~drivers-scsi-bfa-bfad_imc-eliminate-useless-code
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -252,7 +252,6 @@ bfad_im_target_reset_send(struct bfad_s 
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 
-	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
 		BFA_DEV_PRINTF(bfad, BFA_ERR,
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
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

