From: akpm@linux-foundation.org
Subject: + libertas-fix-read-outside-array-bounds.patch added to -mm tree
Date: Tue, 28 Jul 2009 14:38:16 -0700
Message-ID: <200907282138.n6SLcGOO005382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbZG1Vim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 17:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dcbw@redhat.com, linville@tuxdriver.com


The patch titled
     libertas: fix read outside array bounds
has been added to the -mm tree.  Its filename is
     libertas-fix-read-outside-array-bounds.patch

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
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
libertas-fix-read-outside-array-bounds.patch
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
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

