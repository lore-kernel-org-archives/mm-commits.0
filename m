From: akpm@linux-foundation.org
Subject: [merged] fuse-fix-attributes-after-openo_trunc.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:50:58 -0800
Message-ID: <201011291951.oATJpR0G007289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab0K2Tvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ksumrall@android.com, anfei.zhou@gmail.com, avati@gluster.com, miklos@szeredi.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fuse: fix attributes after open(O_TRUNC)
has been removed from the -mm tree.  Its filename was
     fuse-fix-attributes-after-openo_trunc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix attributes after open(O_TRUNC)
From: Ken Sumrall <ksumrall@android.com>

The attribute cache for a file was not being cleared when a file is opened
with O_TRUNC.

If the filesystem's open operation truncates the file ("atomic_o_trunc"
feature flag is set) then the kernel should invalidate the cached st_mtime
and st_ctime attributes.

Also i_size should be explicitly be set to zero as it is used sometimes
without refreshing the cache.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
Cc: Anfei <anfei.zhou@gmail.com>
Cc: "Anand V. Avati" <avati@gluster.com>
Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/fuse/file.c~fuse-fix-attributes-after-openo_trunc fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-attributes-after-openo_trunc
+++ a/fs/fuse/file.c
@@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +142,15 @@ void fuse_finish_open(struct inode *inod
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		spin_lock(&fc->lock);
+		fi->attr_version = ++fc->attr_version;
+		i_size_write(inode, 0);
+		spin_unlock(&fc->lock);
+		fuse_invalidate_attr(inode);
+	}
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
_

Patches currently in -mm which might be from ksumrall@android.com are

origin.patch

