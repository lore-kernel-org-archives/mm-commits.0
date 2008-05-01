From: akpm@linux-foundation.org
Subject: - fuse-fix-max-i-o-size-calculation.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:10 -0700
Message-ID: <200805010932.m419WAbi030962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYEAJcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix max i/o size calculation
has been removed from the -mm tree.  Its filename was
     fuse-fix-max-i-o-size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix max i/o size calculation
From: Miklos Szeredi <mszeredi@suse.cz>

Fix a bug that Werner Baumann reported: fuse can send a bigger write request
than the maximum specified.  This only affected direct_io operation.

In addition set a sane minimum for the max_read and max_write tunables, so I/O
always makes some progress.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c  |    7 ++++---
 fs/fuse/inode.c |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/fuse/file.c~fuse-fix-max-i-o-size-calculation fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-max-i-o-size-calculation
+++ a/fs/fuse/file.c
@@ -966,14 +966,15 @@ static ssize_t fuse_direct_io(struct fil
 
 	while (count) {
 		size_t nres;
-		size_t nbytes = min(count, nmax);
-		int err = fuse_get_user_pages(req, buf, nbytes, !write);
+		size_t nbytes_limit = min(count, nmax);
+		size_t nbytes;
+		int err = fuse_get_user_pages(req, buf, nbytes_limit, !write);
 		if (err) {
 			res = err;
 			break;
 		}
 		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
-		nbytes = min(count, nbytes);
+		nbytes = min(nbytes_limit, nbytes);
 		if (write)
 			nres = fuse_send_write(req, file, inode, pos, nbytes,
 					       current->files);
diff -puN fs/fuse/inode.c~fuse-fix-max-i-o-size-calculation fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-max-i-o-size-calculation
+++ a/fs/fuse/inode.c
@@ -584,6 +584,7 @@ static void process_init_reply(struct fu
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
+		fc->max_write = min_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
 	fuse_put_request(fc, req);
@@ -658,7 +659,7 @@ static int fuse_fill_super(struct super_
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;
 	fc->group_id = d.group_id;
-	fc->max_read = d.max_read;
+	fc->max_read = min_t(unsigned, 4096, d.max_read);
 
 	/* Used by get_root_inode() */
 	sb->s_fs_info = fc;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

