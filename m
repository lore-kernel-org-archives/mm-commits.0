From: akpm@linux-foundation.org
Subject: [merged] ntfs-use-is_power_of_2-function-for-clarity.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:12 -0700
Message-ID: <200906171837.n5HIbCBm003291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbZFQSp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: use is_power_of_2() function for clarity.
has been removed from the -mm tree.  Its filename was
     ntfs-use-is_power_of_2-function-for-clarity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: use is_power_of_2() function for clarity.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c   |    3 ++-
 fs/ntfs/logfile.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ntfs/inode.c~ntfs-use-is_power_of_2-function-for-clarity fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~ntfs-use-is_power_of_2-function-for-clarity
+++ a/fs/ntfs/inode.c
@@ -27,6 +27,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #include "aops.h"
 #include "attrib.h"
@@ -1570,7 +1571,7 @@ static int ntfs_read_locked_index_inode(
 	ntfs_debug("Index collation rule is 0x%x.",
 			le32_to_cpu(ir->collation_rule));
 	ni->itype.index.block_size = le32_to_cpu(ir->index_block_size);
-	if (ni->itype.index.block_size & (ni->itype.index.block_size - 1)) {
+	if (!is_power_of_2(ni->itype.index.block_size)) {
 		ntfs_error(vi->i_sb, "Index block size (%u) is not a power of "
 				"two.", ni->itype.index.block_size);
 		goto unm_err_out;
diff -puN fs/ntfs/logfile.c~ntfs-use-is_power_of_2-function-for-clarity fs/ntfs/logfile.c
--- a/fs/ntfs/logfile.c~ntfs-use-is_power_of_2-function-for-clarity
+++ a/fs/ntfs/logfile.c
@@ -26,6 +26,7 @@
 #include <linux/highmem.h>
 #include <linux/buffer_head.h>
 #include <linux/bitops.h>
+#include <linux/log2.h>
 
 #include "attrib.h"
 #include "aops.h"
@@ -65,7 +66,7 @@ static bool ntfs_check_restart_page_head
 			logfile_log_page_size < NTFS_BLOCK_SIZE ||
 			logfile_system_page_size &
 			(logfile_system_page_size - 1) ||
-			logfile_log_page_size & (logfile_log_page_size - 1)) {
+			!is_power_of_2(logfile_log_page_size)) {
 		ntfs_error(vi->i_sb, "$LogFile uses unsupported page size.");
 		return false;
 	}
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch

