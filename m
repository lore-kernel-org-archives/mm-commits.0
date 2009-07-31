From: akpm@linux-foundation.org
Subject: + slram-read-buffer-overflow.patch added to -mm tree
Date: Fri, 31 Jul 2009 16:06:24 -0700
Message-ID: <200907312306.n6VN6OIM028899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZGaXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 19:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org


The patch titled
     slram: fix read buffer overflow
has been added to the -mm tree.  Its filename is
     slram-read-buffer-overflow.patch

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
Subject: slram: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

map[count] is checked before count < SLRAM_MAX_DEVICES_PARAMS

declared on drivers/mtd/devices/slram.c:66:

static char *map[SLRAM_MAX_DEVICES_PARAMS];

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/slram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/slram.c~slram-read-buffer-overflow drivers/mtd/devices/slram.c
--- a/drivers/mtd/devices/slram.c~slram-read-buffer-overflow
+++ a/drivers/mtd/devices/slram.c
@@ -341,7 +341,7 @@ static int __init init_slram(void)
 #else
 	int count;
 
-	for (count = 0; (map[count]) && (count < SLRAM_MAX_DEVICES_PARAMS);
+	for (count = 0; count < SLRAM_MAX_DEVICES_PARAMS && map[count];
 			count++) {
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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
adfs-remove-redundant-test-on-unsigned.patch

