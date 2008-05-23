From: akpm@linux-foundation.org
Subject: - video-fix-integer-as-null-pointer-warnings.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:53 -0700
Message-ID: <200805231859.m4NIxrbI004276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbYEWS7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix integer as NULL pointer warnings
has been removed from the -mm tree.  Its filename was
     video-fix-integer-as-null-pointer-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/video/aty/atyfb_base.c:3359:26: warning: Using plain integer as NULL pointer
drivers/video/aty/radeon_base.c:2280:32: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer
drivers/video/matrox/matroxfb_base.h:203:25: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c       |    2 +-
 drivers/video/aty/radeon_base.c      |    2 +-
 drivers/video/matrox/matroxfb_base.h |    2 +-
 drivers/video/sis/sis_main.c         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~video-fix-integer-as-null-pointer-warnings drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~video-fix-integer-as-null-pointer-warnings
+++ a/drivers/video/aty/atyfb_base.c
@@ -3356,7 +3356,7 @@ static int __devinit atyfb_setup_generic
 
 	info->fix.mmio_start = raddr;
 	par->ati_regbase = ioremap(info->fix.mmio_start, 0x1000);
-	if (par->ati_regbase == 0)
+	if (!par->ati_regbase)
 		return -ENOMEM;
 
 	info->fix.mmio_start += par->aux_start ? 0x400 : 0xc00;
diff -puN drivers/video/aty/radeon_base.c~video-fix-integer-as-null-pointer-warnings drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~video-fix-integer-as-null-pointer-warnings
+++ a/drivers/video/aty/radeon_base.c
@@ -2277,7 +2277,7 @@ static int __devinit radeonfb_pci_regist
 	do {
 		rinfo->fb_base = ioremap (rinfo->fb_base_phys,
 					  rinfo->mapped_vram);
-	} while (   rinfo->fb_base == 0 &&
+	} while (!rinfo->fb_base &&
 		  ((rinfo->mapped_vram /=2) >= MIN_MAPPED_VRAM) );
 
 	if (rinfo->fb_base == NULL) {
diff -puN drivers/video/matrox/matroxfb_base.h~video-fix-integer-as-null-pointer-warnings drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~video-fix-integer-as-null-pointer-warnings
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -200,7 +200,7 @@ static inline int mga_ioremap(unsigned l
 		virt->vaddr = ioremap_nocache(phys, size);
 	else
 		virt->vaddr = ioremap(phys, size);
-	return (virt->vaddr == 0); /* 0, !0... 0, error_code in future */
+	return (virt->vaddr == NULL); /* 0, !0... 0, error_code in future */
 }
 
 static inline void mga_iounmap(vaddr_t va) {
diff -puN drivers/video/sis/sis_main.c~video-fix-integer-as-null-pointer-warnings drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~video-fix-integer-as-null-pointer-warnings
+++ a/drivers/video/sis/sis_main.c
@@ -5787,7 +5787,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 	} else {
 		struct sis_video_info *countvideo = card_list;
 		ivideo->cardnumber = 1;
-		while((countvideo = countvideo->next) != 0)
+		while((countvideo = countvideo->next) != NULL)
 			ivideo->cardnumber++;
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

