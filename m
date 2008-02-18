From: akpm@linux-foundation.org
Subject: + pata_amd-replace-macro-with-static-inline-in-libatah.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:59:06 -0800
Message-ID: <200802181000.m1IA032E018895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbYBRKAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:00:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     pata_amd: replace macro with static inline in libata.h
has been added to the -mm tree.  Its filename is
     pata_amd-replace-macro-with-static-inline-in-libatah.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_amd: replace macro with static inline in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>

Current code is essentially choosing between dividing by 1 or
dividing by two, make the conditions a little more obvious.

As a bonus, removes a sparse error:
drivers/ata/pata_amd.c:59:11: warning: symbol '__x' shadows an earlier one
drivers/ata/pata_amd.c:59:11: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-replace-macro-with-static-inline-in-libatah drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-replace-macro-with-static-inline-in-libatah
+++ a/drivers/ata/pata_amd.c
@@ -56,7 +56,9 @@ static void timing_setup(struct ata_port
 	u8 t;
 
 	T = 1000000000 / amd_clock;
-	UT = T / min_t(int, max_t(int, clock, 1), 2);
+	UT = T;
+	if (clock >= 2)
+		UT = T / 2;
 
 	if (ata_timing_compute(adev, speed, &at, T, UT) < 0) {
 		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", speed);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
