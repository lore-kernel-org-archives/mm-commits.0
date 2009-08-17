From: akpm@linux-foundation.org
Subject: + mtd-prevent-a-read-from-eraseregions.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:58:39 -0700
Message-ID: <200908172358.n7HNwdS1003679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbZHQX6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: prevent a read from eraseregions[-1]
has been added to the -mm tree.  Its filename is
     mtd-prevent-a-read-from-eraseregions.patch

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
Subject: mtd: prevent a read from eraseregions[-1]
From: Roel Kluin <roel.kluin@gmail.com>

If the erase region was found in the first iteration we read from
eraseregions[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdconcat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/mtdconcat.c~mtd-prevent-a-read-from-eraseregions drivers/mtd/mtdconcat.c
--- a/drivers/mtd/mtdconcat.c~mtd-prevent-a-read-from-eraseregions
+++ a/drivers/mtd/mtdconcat.c
@@ -427,7 +427,7 @@ static int concat_erase(struct mtd_info 
 		 * to-be-erased area begins. Verify that the starting
 		 * offset is aligned to this region's erase size:
 		 */
-		if (instr->addr & (erase_regions[i].erasesize - 1))
+		if (i < 0 || instr->addr & (erase_regions[i].erasesize - 1))
 			return -EINVAL;
 
 		/*
@@ -440,8 +440,8 @@ static int concat_erase(struct mtd_info 
 		/*
 		 * check if the ending offset is aligned to this region's erase size
 		 */
-		if ((instr->addr + instr->len) & (erase_regions[i].erasesize -
-						  1))
+		if (i < 0 || ((instr->addr + instr->len) &
+					(erase_regions[i].erasesize - 1)))
 			return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
vt6655-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

