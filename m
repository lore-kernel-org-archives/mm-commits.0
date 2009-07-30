From: akpm@linux-foundation.org
Subject: [merged] libertas-fix-read-outside-array-bounds.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:26 -0700
Message-ID: <200907302038.n6UKcQ12013071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZG3Uiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     libertas: fix read outside array bounds
has been removed from the -mm tree.  Its filename was
     libertas-fix-read-outside-array-bounds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libertas: fix read outside array bounds
From: Roel Kluin <roel.kluin@gmail.com>

Reads bss->rates[j] before checking bounds of index, and should use
ARRAY_SIZE to determine the size of the array.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/libertas/scan.c~libertas-fix-read-outside-array-bounds drivers/net/wireless/libertas/scan.c
--- a/drivers/net/wireless/libertas/scan.c~libertas-fix-read-outside-array-bounds
+++ a/drivers/net/wireless/libertas/scan.c
@@ -5,6 +5,7 @@
   *  for sending scan commands to the firmware.
   */
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <asm/unaligned.h>
@@ -876,7 +877,7 @@ static inline char *lbs_translate_scan(s
 	iwe.u.bitrate.disabled = 0;
 	iwe.u.bitrate.value = 0;
 
-	for (j = 0; bss->rates[j] && (j < sizeof(bss->rates)); j++) {
+	for (j = 0; j < ARRAY_SIZE(bss->rates) && bss->rates[j]; j++) {
 		/* Bit rate given in 500 kb/s units */
 		iwe.u.bitrate.value = bss->rates[j] * 500000;
 		current_val = iwe_stream_add_value(info, start, current_val,
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
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
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

