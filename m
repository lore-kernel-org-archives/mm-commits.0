From: akpm@linux-foundation.org
Subject: + mtd-fix-read-buffer-overflow.patch added to -mm tree
Date: Fri, 31 Jul 2009 16:23:17 -0700
Message-ID: <200907312323.n6VNNHMv024174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbZGaXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: fix read buffer overflow
has been added to the -mm tree.  Its filename is
     mtd-fix-read-buffer-overflow.patch

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
Subject: mtd: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

with `for (i = 0; bbt[i] && i < ebcnt; ++i)'
we test bbt[ebcnt] in the last iteration

with `for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)'
we test bbt[-1] in the last iteration

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/tests/mtd_oobtest.c  |    2 +-
 drivers/mtd/tests/mtd_pagetest.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/mtd/tests/mtd_oobtest.c~mtd-fix-read-buffer-overflow drivers/mtd/tests/mtd_oobtest.c
--- a/drivers/mtd/tests/mtd_oobtest.c~mtd-fix-read-buffer-overflow
+++ a/drivers/mtd/tests/mtd_oobtest.c
@@ -512,7 +512,7 @@ static int __init mtd_oobtest_init(void)
 		goto out;
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	/* Attempt to write off end of OOB */
diff -puN drivers/mtd/tests/mtd_pagetest.c~mtd-fix-read-buffer-overflow drivers/mtd/tests/mtd_pagetest.c
--- a/drivers/mtd/tests/mtd_pagetest.c~mtd-fix-read-buffer-overflow
+++ a/drivers/mtd/tests/mtd_pagetest.c
@@ -116,11 +116,11 @@ static int verify_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	addrn = mtd->size;
-	for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
 	set_random_data(writebuf, mtd->erasesize);
@@ -219,11 +219,11 @@ static int crosstest(void)
 	memset(pp1, 0, pgsize * 4);
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	addrn = mtd->size;
-	for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
 	/* Read 2nd-to-last page to pp1 */
@@ -317,7 +317,7 @@ static int erasecrosstest(void)
 
 	ebnum = 0;
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i) {
+	for (i = 0; i < ebcnt && bbt[i]; ++i) {
 		addr0 += mtd->erasesize;
 		ebnum += 1;
 	}
@@ -413,7 +413,7 @@ static int erasetest(void)
 
 	ebnum = 0;
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i) {
+	for (i = 0; i < ebcnt && bbt[i]; ++i) {
 		addr0 += mtd->erasesize;
 		ebnum += 1;
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
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
mips-read-buffer-overflow.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
misdn-fix-read-buffer-overflow.patch
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

