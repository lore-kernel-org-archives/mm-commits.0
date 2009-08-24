From: akpm@linux-foundation.org
Subject: [merged] m68k-cnt-reaches-1-not-0.patch removed from -mm tree
Date: Mon, 24 Aug 2009 12:00:01 -0700
Message-ID: <200908241900.n7OJ01wL031155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbZHXTAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 15:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: cnt reaches -1, not 0
has been removed from the -mm tree.  Its filename was
     m68k-cnt-reaches-1-not-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: cnt reaches -1, not 0
From: Roel Kluin <roel.kluin@gmail.com>

With the postfix decrement cnt reaches -1 rather than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/config.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/m68k/amiga/config.c~m68k-cnt-reaches-1-not-0 arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~m68k-cnt-reaches-1-not-0
+++ a/arch/m68k/amiga/config.c
@@ -574,10 +574,11 @@ static int a2000_hwclk(int op, struct rt
 
 	tod_2000.cntrl1 = TOD2000_CNTRL1_HOLD;
 
-	while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt--) {
+	while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
 		tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
 		udelay(70);
 		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
+		--cnt;
 	}
 
 	if (!cnt)
@@ -649,10 +650,11 @@ static int amiga_set_clock_mmss(unsigned
 
 		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
 
-		while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt--) {
+		while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
 			tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
 			udelay(70);
 			tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
+			--cnt;
 		}
 
 		if (!cnt)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
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
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

