From: akpm@linux-foundation.org
Subject: + mount-options-fix-hostfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:39 -0800
Message-ID: <200801292322.m0TNMdcx009713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbYA2XXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:23:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jdike@addtoit.com


The patch titled
     mount options: fix hostfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-hostfs.patch

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
Subject: mount options: fix hostfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add the "host path" option to /proc/mounts for UML hostfs filesystems.

The mount source (mnt_devname) should really be used for this, but not
easy to change now in a backward compatible way.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/hostfs/hostfs_kern.c~mount-options-fix-hostfs fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~mount-options-fix-hostfs
+++ a/fs/hostfs/hostfs_kern.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
+#include <linux/seq_file.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
@@ -322,12 +323,25 @@ static void hostfs_destroy_inode(struct 
 	kfree(HOSTFS_I(inode));
 }
 
+static int hostfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct inode *root = vfs->mnt_sb->s_root->d_inode;
+	const char *root_path = HOSTFS_I(root)->host_filename;
+	size_t offset = strlen(root_ino) + 1;
+
+	if (strlen(root_path) > offset)
+		seq_printf(seq, ",%s", root_path + offset);
+
+	return 0;
+}
+
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
 	.destroy_inode	= hostfs_destroy_inode,
 	.statfs		= hostfs_statfs,
+	.show_options	= hostfs_show_options,
 };
 
 int hostfs_readdir(struct file *file, void *ent, filldir_t filldir)
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
