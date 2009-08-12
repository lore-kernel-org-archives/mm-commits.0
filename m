From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 12 Aug 2009 12:54:51 -0700
Message-ID: <200908121954.n7CJsp3S032568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbZHLTzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 15:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/bw-qcam.c: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/bw-qcam.c: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

parport[n] is checked before n < MAX_CAMS

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/bw-qcam.c~drivers-media-video-bw-qcamc-fix-read-buffer-overflow drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~drivers-media-video-bw-qcamc-fix-read-buffer-overflow
+++ a/drivers/media/video/bw-qcam.c
@@ -992,7 +992,7 @@ static int accept_bwqcam(struct parport 
 
 	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
 		/* user gave parport parameters */
-		for(n=0; parport[n] && n<MAX_CAMS; n++){
+		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
 			char *ep;
 			unsigned long r;
 			r = simple_strtoul(parport[n], &ep, 0);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
media-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
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
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

