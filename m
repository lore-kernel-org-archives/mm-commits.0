From: akpm@linux-foundation.org
Subject: [merged] stk-webcam-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 12 Aug 2009 12:54:53 -0700
Message-ID: <200908121954.n7CJsrv4032682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbZHLTzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 15:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org, xyzzy@speakeasy.org, mm-commits@vger.kernel.org


The patch titled
     stk-webcam: read buffer overflow
has been removed from the -mm tree.  Its filename was
     stk-webcam-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stk-webcam: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

It tested the value of stk_sizes[i].m before checking whether i was in range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/stk-webcam.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/stk-webcam.c~stk-webcam-read-buffer-overflow drivers/media/video/stk-webcam.c
--- a/drivers/media/video/stk-webcam.c~stk-webcam-read-buffer-overflow
+++ a/drivers/media/video/stk-webcam.c
@@ -1050,8 +1050,8 @@ static int stk_setup_format(struct stk_c
 		depth = 1;
 	else
 		depth = 2;
-	while (stk_sizes[i].m != dev->vsettings.mode
-			&& i < ARRAY_SIZE(stk_sizes))
+	while (i < ARRAY_SIZE(stk_sizes) &&
+			stk_sizes[i].m != dev->vsettings.mode)
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
 		STK_ERROR("Something is broken in %s\n", __func__);
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

