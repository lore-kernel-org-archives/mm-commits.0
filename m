From: akpm@linux-foundation.org
Subject: + drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch added to -mm tree
Date: Fri, 22 Jan 2010 17:04:49 -0800
Message-ID: <201001230104.o0N14npr007621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab0AWBEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 20:04:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com, huangj@brocade.com


The patch titled
     drivers/scsi/bfa/bfad_im.c: eliminate useless code
has been added to the -mm tree.  Its filename is
     drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch

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
@@ -243,7 +243,6 @@ bfad_im_target_reset_send(struct bfad_s 
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 
-	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
 		BFA_DEV_PRINTF(bfad, BFA_ERR,
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch

