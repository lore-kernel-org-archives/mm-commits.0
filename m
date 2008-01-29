From: akpm@linux-foundation.org
Subject: + mount-options-fix-hugetlbfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:43 -0800
Message-ID: <200801292322.m0TNMho7009722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbYA2XXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, agl@us.ibm.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     mount options: fix hugetlbfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-hugetlbfs.patch

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
Subject: mount options: fix hugetlbfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hugetlbfs.

Use generic_show_options() and save the complete option string in
hugetlbfs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hugetlbfs/inode.c~mount-options-fix-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mount-options-fix-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -734,6 +734,7 @@ static const struct super_operations hug
 	.delete_inode	= hugetlbfs_delete_inode,
 	.drop_inode	= hugetlbfs_drop_inode,
 	.put_super	= hugetlbfs_put_super,
+	.show_options	= generic_show_options,
 };
 
 static int
@@ -817,6 +818,8 @@ hugetlbfs_fill_super(struct super_block 
 	struct hugetlbfs_config config;
 	struct hugetlbfs_sb_info *sbinfo;
 
+	save_mount_options(sb, data);
+
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
 	config.uid = current->fsuid;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
