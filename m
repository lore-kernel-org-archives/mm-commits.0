From: akpm@linux-foundation.org
Subject: + ntfs-use-is_power_of_2-function-for-clarity.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:09:41 -0700
Message-ID: <200904242009.n3OK9fPN004735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbZDXUL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, aia21@cantab.net


The patch titled
     ntfs: use is_power_of_2() function for clarity.
has been added to the -mm tree.  Its filename is
     ntfs-use-is_power_of_2-function-for-clarity.patch

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
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

