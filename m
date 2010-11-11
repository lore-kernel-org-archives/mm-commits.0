From: akpm@linux-foundation.org
Subject: [to-be-updated] fuse-clear-attribute-cache-for-openo_trunc.patch removed from -mm tree
Date: Thu, 11 Nov 2010 14:06:40 -0800
Message-ID: <201011112206.oABM6eu9005363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab0KKWHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 17:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ksumrall@android.com, anfei.zhou@gmail.com, avati@gluster.com, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: clear attribute cache for open(O_TRUNC)
has been removed from the -mm tree.  Its filename was
     fuse-clear-attribute-cache-for-openo_trunc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: clear attribute cache for open(O_TRUNC)
From: Ken Sumrall <ksumrall@android.com>

The attribute cache for a file was not being cleared when a file is opened
with O_TRUNC.

Signed-off-by: Ken Sumrall <ksumrall@android.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Anfei <anfei.zhou@gmail.com>
Cc: "Anand V. Avati" <avati@gluster.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/fuse/file.c~fuse-clear-attribute-cache-for-openo_trunc fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-clear-attribute-cache-for-openo_trunc
+++ a/fs/fuse/file.c
@@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
 void fuse_finish_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
@@ -141,6 +142,8 @@ void fuse_finish_open(struct inode *inod
 		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC))
+		fuse_invalidate_attr(inode);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
_

Patches currently in -mm which might be from ksumrall@android.com are


