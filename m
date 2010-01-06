From: akpm@linux-foundation.org
Subject: + drivers-scsi-correct-the-size-argument-to-kmalloc.patch added to -mm tree
Date: Tue, 05 Jan 2010 16:57:51 -0800
Message-ID: <201001060057.o060vp7T031496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650Ab0AFA6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 19:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com, eike-kernel@sf-tec.de, joe@perches.com


The patch titled
     drivers/scsi/aic94xx/aic94xx_init.c: correct the size argument to kmalloc
has been added to the -mm tree.  Its filename is
     drivers-scsi-correct-the-size-argument-to-kmalloc.patch

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
Subject: drivers/scsi/aic94xx/aic94xx_init.c: correct the size argument to kmalloc
From: Julia Lawall <julia@diku.dk>

In each case, the destination of the allocation has type struct **, so the
elements of the array should have pointer type, not structure type.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 drivers/scsi/ch.c                   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~drivers-scsi-correct-the-size-argument-to-kmalloc drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~drivers-scsi-correct-the-size-argument-to-kmalloc
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -687,9 +687,9 @@ static int asd_register_sas_ha(struct as
 {
 	int i;
 	struct asd_sas_phy   **sas_phys =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy), GFP_KERNEL);
+		kcalloc(ASD_MAX_PHYS, sizeof(*sas_phys), GFP_KERNEL);
 	struct asd_sas_port  **sas_ports =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port), GFP_KERNEL);
+		kcalloc(ASD_MAX_PHYS, sizeof(*sas_ports), GFP_KERNEL);
 
 	if (!sas_phys || !sas_ports) {
 		kfree(sas_phys);
diff -puN drivers/scsi/ch.c~drivers-scsi-correct-the-size-argument-to-kmalloc drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~drivers-scsi-correct-the-size-argument-to-kmalloc
+++ a/drivers/scsi/ch.c
@@ -351,7 +351,7 @@ ch_readconfig(scsi_changer *ch)
 	}
 
 	/* look up the devices of the data transfer elements */
-	ch->dt = kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_device),
+	ch->dt = kcalloc(ch->counts[CHET_DT], sizeof(*ch->dt),
 			 GFP_KERNEL);
 
 	if (!ch->dt) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-edac-introduce-missing-kfree.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-usb-correct-the-size-argument-to-kzalloc.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch

