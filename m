From: akpm@linux-foundation.org
Subject: - ubi-fix-sparse-errors-in-ubih.patch removed from -mm tree
Date: Fri, 15 Feb 2008 16:10:19 -0800
Message-ID: <200802160010.m1G0AKdg031455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761911AbYBPAKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 19:10:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ubi: fix sparse errors in ubi.h
has been removed from the -mm tree.  Its filename was
     ubi-fix-sparse-errors-in-ubih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ubi: fix sparse errors in ubi.h
From: Harvey Harrison <harvey.harrison@gmail.com>

In C, signed 1-bit bitfields can only take the values 0 and -1, only 0 and 1
are ever assigned in current code.  Make them unsigned bitfields.

Fixes the (repeated) sparse errors:
drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/ubi.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/ubi/ubi.h~ubi-fix-sparse-errors-in-ubih drivers/mtd/ubi/ubi.h
--- a/drivers/mtd/ubi/ubi.h~ubi-fix-sparse-errors-in-ubih
+++ a/drivers/mtd/ubi/ubi.h
@@ -217,11 +217,11 @@ struct ubi_volume {
 	void *upd_buf;
 
 	int *eba_tbl;
-	int checked:1;
-	int corrupted:1;
-	int upd_marker:1;
-	int updating:1;
-	int changing_leb:1;
+	unsigned int checked:1;
+	unsigned int corrupted:1;
+	unsigned int upd_marker:1;
+	unsigned int updating:1;
+	unsigned int changing_leb:1;
 
 #ifdef CONFIG_MTD_UBI_GLUEBI
 	/*
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
git-ubi.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
