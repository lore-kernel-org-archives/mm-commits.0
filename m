From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:45 -0800
Message-ID: <200702150833.l1F8XjTQ024664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965289AbXBOId6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate writer count for custom struct_file
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: elevate writer count for custom struct_file
From: Dave Hansen <hansendc@us.ibm.com>

Some filesystems forego the use of normal vfs calls to create struct files. 
Make sure that these users elevate the mnt writer count.  These probably don't
have any real meaning because there is no real backing store for these mounts,
but it is here for consistency.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-writer-count-for-custom-struct_file fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-writer-count-for-custom-struct_file
+++ a/fs/file_table.c
@@ -170,6 +170,10 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+	if (mode & FMODE_WRITE) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
