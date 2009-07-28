From: akpm@linux-foundation.org
Subject: + ibmmca-buffer-overflow.patch added to -mm tree
Date: Tue, 28 Jul 2009 14:55:00 -0700
Message-ID: <200907282155.n6SLt0v5032436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611AbZG1Vz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 17:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, langa2@kph.uni-mainz.de


The patch titled
     ibmmca: fix buffer overflow
has been added to the -mm tree.  Its filename is
     ibmmca-buffer-overflow.patch

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
Subject: ibmmca: fix buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Allows i == IM_MAX_HOSTS, which is out of range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Michael Lang <langa2@kph.uni-mainz.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmmca.c~ibmmca-buffer-overflow drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~ibmmca-buffer-overflow
+++ a/drivers/scsi/ibmmca.c
@@ -2335,7 +2335,7 @@ static int option_setup(char *str)
 	char *cur = str;
 	int i = 1;
 
-	while (cur && isdigit(*cur) && i <= IM_MAX_HOSTS) {
+	while (cur && isdigit(*cur) && i < IM_MAX_HOSTS) {
 		ints[i++] = simple_strtoul(cur, NULL, 0);
 		if ((cur = strchr(cur, ',')) != NULL)
 			cur++;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
i915-fix-read-outside-array-bounds.patch
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
libertas-fix-read-outside-array-bounds.patch
libertas-read-buffer-overflow.patch
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

