From: akpm@linux-foundation.org
Subject: + video-fix-integer-as-null-pointer-warnings.patch added to -mm tree
Date: Thu, 01 May 2008 16:05:19 -0700
Message-ID: <200805012305.m41N5JHH030171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763652AbYEAXFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 19:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     fbdev: fix integer as NULL pointer warnings
has been added to the -mm tree.  Its filename is
     video-fix-integer-as-null-pointer-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
frv-unbreak-misalignment-handling-changes.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
fuse-use-clamp-rather-than-nested-min-max.patch
block-remove-remaining-__function__-occurances.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch
misc-fix-integer-as-null-pointer-warnings.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
video-fix-integer-as-null-pointer-warnings.patch

