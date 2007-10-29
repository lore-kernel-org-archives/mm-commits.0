From: akpm@linux-foundation.org
Subject: + kill-udffs_dateversion.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:48:50 -0700
Message-ID: <200710292048.l9TKmotR022597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbXJ2Utg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     kill UDFFS_{DATE,VERSION}
has been added to the -mm tree.  Its filename is
     kill-udffs_dateversion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1542,9 +1542,8 @@ static int udf_fill_super(struct super_b
 	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
-		udf_info("UDF %s (%s) Mounting volume '%s', "
+		udf_info("UDF: Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			 UDFFS_VERSION, UDFFS_DATE,
 			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
 			 ts.typeAndTimezone);
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
ipmi-fix-comparison-in-demangle_device_id.patch
git-acpi.patch
git-hwmon.patch
git-ieee1394.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
kill-udffs_dateversion.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
