From: akpm@linux-foundation.org
Subject: + mount-options-fix-spufs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:53 -0800
Message-ID: <200801292322.m0TNMrCl009740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508AbYA2X0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, arnd@arndb.de, paulus@samba.org


The patch titled
     mount options: fix spufs
has been added to the -mm tree.  Its filename is
     mount-options-fix-spufs.patch

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
Subject: mount options: fix spufs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to spufs.

Use generic_show_options() and save the complete option string in
spufs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~mount-options-fix-spufs arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~mount-options-fix-spufs
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -744,8 +744,11 @@ spufs_fill_super(struct super_block *sb,
 		.statfs = simple_statfs,
 		.delete_inode = spufs_delete_inode,
 		.drop_inode = generic_delete_inode,
+		.show_options = generic_show_options,
 	};
 
+	save_mount_options(sb, data);
+
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
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
