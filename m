From: akpm@linux-foundation.org
Subject: - kill-udffs_dateversion.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:45 -0800
Message-ID: <200802082017.m18KHQfI010817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYBHUpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kill UDFFS_{DATE,VERSION}
has been removed from the -mm tree.  Its filename was
     kill-udffs_dateversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill UDFFS_{DATE,VERSION}
From: Adrian Bunk <bunk@kernel.org>

Printing date and version of a driver makes sense if there's a maintainer
who's maintaining and using these, but printing ancient version information
only confuses users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c         |    3 +--
 include/linux/udf_fs.h |    3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/udf/super.c~kill-udffs_dateversion fs/udf/super.c
--- a/fs/udf/super.c~kill-udffs_dateversion
+++ a/fs/udf/super.c
@@ -1792,9 +1792,8 @@ static int udf_fill_super(struct super_b
 	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, sbi->s_record_time);
-		udf_info("UDF %s (%s) Mounting volume '%s', "
+		udf_info("UDF: Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			 UDFFS_VERSION, UDFFS_DATE,
 			 sbi->s_volume_ident, ts.year, ts.month, ts.day,
 			 ts.hour, ts.minute, ts.typeAndTimezone);
 	}
diff -puN include/linux/udf_fs.h~kill-udffs_dateversion include/linux/udf_fs.h
--- a/include/linux/udf_fs.h~kill-udffs_dateversion
+++ a/include/linux/udf_fs.h
@@ -32,9 +32,6 @@
 #define UDF_PREALLOCATE
 #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 
-#define UDFFS_DATE			"2004/29/09"
-#define UDFFS_VERSION			"0.9.8.1"
-
 #undef UDFFS_DEBUG
 
 #ifdef UDFFS_DEBUG
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
reiser4.patch
