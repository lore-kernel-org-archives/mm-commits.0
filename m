From: akpm@linux-foundation.org
Subject: [merged] fs-affs-amigaffsc-remove-unneeded-initialization.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:56 -0700
Message-ID: <559adb30.8KlF48NddHB1VrCF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbbGFTq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/amigaffs.c: remove unneeded initialization
has been removed from the -mm tree.  Its filename was
     fs-affs-amigaffsc-remove-unneeded-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/amigaffs.c: remove unneeded initialization

bh is initialized unconditionally in affs_remove_link()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-unneeded-initialization fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-unneeded-initialization
+++ a/fs/affs/amigaffs.c
@@ -140,7 +140,7 @@ affs_remove_link(struct dentry *dentry)
 {
 	struct inode *dir, *inode = d_inode(dentry);
 	struct super_block *sb = inode->i_sb;
-	struct buffer_head *bh = NULL, *link_bh = NULL;
+	struct buffer_head *bh, *link_bh = NULL;
 	u32 link_ino, ino;
 	int retval;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch

