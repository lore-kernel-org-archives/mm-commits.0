From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-do_rmdir-elevate-write-count.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:57 -0800
Message-ID: <200702141852.l1EIqvoi005761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465AbXBNSxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:53:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: do_rmdir(): elevate write count
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-do_rmdir-elevate-write-count.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: do_rmdir(): elevate write count
From: Dave Hansen <hansendc@us.ibm.com>

Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count
+++ a/fs/namei.c
@@ -2097,7 +2097,12 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto exit3;
 	error = vfs_rmdir(nd.dentry->d_inode, dentry);
+	mnt_drop_write(nd.mnt);
+exit3:
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
