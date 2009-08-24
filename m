From: akpm@linux-foundation.org
Subject: [merged] m68k-count-can-reach-51-not-50.patch removed from -mm tree
Date: Mon, 24 Aug 2009 11:59:58 -0700
Message-ID: <200908241859.n7OIxwXW031083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbZHXTAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 15:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: count can reach 51, not 50
has been removed from the -mm tree.  Its filename was
     m68k-count-can-reach-51-not-50.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: count can reach 51, not 50
From: Roel Kluin <roel.kluin@gmail.com>

With while (count++ < 50) { ...  } count can reach 51, not 50, so we
shouldn't give an error message on a count of 50.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-maciisi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/via-maciisi.c~m68k-count-can-reach-51-not-50 drivers/macintosh/via-maciisi.c
--- a/drivers/macintosh/via-maciisi.c~m68k-count-can-reach-51-not-50
+++ a/drivers/macintosh/via-maciisi.c
@@ -288,7 +288,7 @@ static void maciisi_sync(struct adb_requ
 	}
 	/* This could be BAD... when the ADB controller doesn't respond
 	 * for this long, it's probably not coming back :-( */
-	if(count >= 50) /* Hopefully shouldn't happen */
+	if (count > 50) /* Hopefully shouldn't happen */
 		printk(KERN_ERR "maciisi_send_request: poll timed out!\n");
 }
 
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

