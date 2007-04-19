From: akpm@linux-foundation.org
Subject: - ext4-use-null-for-pointers.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:36 -0700
Message-ID: <200704192002.l3JK2ahi029400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767002AbXDSUCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: use NULL for pointers
has been removed from the -mm tree.  Its filename was
     ext4-use-null-for-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: use NULL for pointers
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers:
fs/ext4/writeback.c:874:24: warning: Using plain integer as NULL pointer
fs/ext4/writeback.c:1105:23: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ext4/writeback.c~ext4-use-null-for-pointers fs/ext4/writeback.c
--- a/fs/ext4/writeback.c~ext4-use-null-for-pointers
+++ a/fs/ext4/writeback.c
@@ -41,6 +41,7 @@
 #include <linux/jbd.h>
 #include <linux/ext4_fs_extents.h>
 #include <linux/smp_lock.h>
+#include <linux/stddef.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
@@ -871,7 +872,7 @@ int ext4_wb_prepare_write(struct file *f
 				wb_debug("read block %u\n",
 						(unsigned) bhw->b_blocknr);
 				set_bh_page(bhw, page, 0);
-				bhw->b_this_page = 0;
+				bhw->b_this_page = NULL;
 				bhw->b_size = 1 << inode->i_blkbits;
 				atomic_set(&bhw->b_count, 1);
 				ll_rw_block(READ, 1, &bhw);
@@ -1102,7 +1103,7 @@ int ext4_wb_block_truncate_page(handle_t
 			wb_debug("read block %u for part.trunc on %lu\n",
 					(unsigned) bhw->b_blocknr, page->index);
 			set_bh_page(bhw, page, 0);
-			bhw->b_this_page = 0;
+			bhw->b_this_page = NULL;
 			bhw->b_size = 1 << inode->i_blkbits;
 			atomic_set(&bhw->b_count, 1);
 			ll_rw_block(READ, 1, &bhw);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
