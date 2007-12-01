From: akpm@linux-foundation.org
Subject: - fuse-fix-attribute-caching-after-rename.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:57 -0800
Message-ID: <200712010022.lB10Mvv0031957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290AbXLAA10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix attribute caching after rename
has been removed from the -mm tree.  Its filename was
     fuse-fix-attribute-caching-after-rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix attribute caching after rename
From: Miklos Szeredi <miklos@szeredi.hu>

Invalidate attributes on rename, since some filesystems may update
st_ctime.  Reported by Szabolcs Szakacsits

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/fuse/dir.c~fuse-fix-attribute-caching-after-rename fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-attribute-caching-after-rename
+++ a/fs/fuse/dir.c
@@ -657,6 +657,9 @@ static int fuse_rename(struct inode *old
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
+		/* ctime changes */
+		fuse_invalidate_attr(oldent->d_inode);
+
 		fuse_invalidate_attr(olddir);
 		if (olddir != newdir)
 			fuse_invalidate_attr(newdir);
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
