From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:32:27 -0700
Message-ID: <53960bcb.G9fwk0IKaEdHFuG/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fabf@skynet.be

Subject: [merged] fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch removed from -mm tree
To: fabf@skynet.be,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:27 -0700


The patch titled
     Subject: fs/hfsplus: fix pr_foo() and hfs_dbg formats
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: fix pr_foo() and hfs_dbg formats

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-By: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    7 +++----
 fs/hfsplus/super.c   |    3 ++-
 fs/hfsplus/xattr.c   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/hfsplus/extents.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats
+++ a/fs/hfsplus/extents.c
@@ -436,10 +436,9 @@ int hfsplus_file_extend(struct inode *in
 	if (sbi->alloc_file->i_size * 8 <
 	    sbi->total_blocks - sbi->free_blocks + 8) {
 		/* extend alloc file */
-		pr_err("extend alloc file! "
-				"(%llu,%u,%u)\n",
-			sbi->alloc_file->i_size * 8,
-			sbi->total_blocks, sbi->free_blocks);
+		pr_err("extend alloc file! (%llu,%u,%u)\n",
+		       sbi->alloc_file->i_size * 8,
+		       sbi->total_blocks, sbi->free_blocks);
 		return -ENOSPC;
 	}
 
diff -puN fs/hfsplus/super.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats
+++ a/fs/hfsplus/super.c
@@ -131,9 +131,10 @@ static int hfsplus_system_write_inode(st
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree) {
 		int err = hfs_btree_write(tree);
+
 		if (err) {
 			pr_err("b-tree write err: %d, ino %lu\n",
-					err, inode->i_ino);
+			       err, inode->i_ino);
 			return err;
 		}
 	}
diff -puN fs/hfsplus/xattr.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats
+++ a/fs/hfsplus/xattr.c
@@ -70,7 +70,7 @@ static void hfsplus_init_header_node(str
 	loff_t tmp;
 
 	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %u\n",
-				clump_size, node_size);
+		clump_size, node_size);
 
 	/* The end of the node contains list of record offsets */
 	rec_offsets = (__be16 *)(buf + node_size);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

