From: akpm@linux-foundation.org
Subject: - fuse-cleanup-add-fuse_get_attr_version.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:48 -0800
Message-ID: <200712010022.lB10Mmbx031945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbXLAA1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: cleanup: add fuse_get_attr_version()
has been removed from the -mm tree.  Its filename was
     fuse-cleanup-add-fuse_get_attr_version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: cleanup: add fuse_get_attr_version()
From: Miklos Szeredi <mszeredi@suse.cz>

Extract repeated code into helper function, as suggested by Akpm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN fs/fuse/dir.c~fuse-cleanup-add-fuse_get_attr_version fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-cleanup-add-fuse_get_attr_version
+++ a/fs/fuse/dir.c
@@ -132,6 +132,21 @@ static void fuse_lookup_init(struct fuse
 	req->out.args[0].value = outarg;
 }
 
+static u64 fuse_get_attr_version(struct fuse_conn *fc)
+{
+	u64 curr_version;
+
+	/*
+	 * The spin lock isn't actually needed on 64bit archs, but we
+	 * don't yet care too much about such optimizations.
+	 */
+	spin_lock(&fc->lock);
+	curr_version = fc->attr_version;
+	spin_unlock(&fc->lock);
+
+	return curr_version;
+}
+
 /*
  * Check whether the dentry is still valid
  *
@@ -171,9 +186,7 @@ static int fuse_dentry_revalidate(struct
 			return 0;
 		}
 
-		spin_lock(&fc->lock);
-		attr_version = fc->attr_version;
-		spin_unlock(&fc->lock);
+		attr_version = fuse_get_attr_version(fc);
 
 		parent = dget_parent(entry);
 		fuse_lookup_init(req, parent->d_inode, entry, &outarg);
@@ -264,9 +277,7 @@ static struct dentry *fuse_lookup(struct
 		return ERR_PTR(PTR_ERR(forget_req));
 	}
 
-	spin_lock(&fc->lock);
-	attr_version = fc->attr_version;
-	spin_unlock(&fc->lock);
+	attr_version = fuse_get_attr_version(fc);
 
 	fuse_lookup_init(req, dir, entry, &outarg);
 	request_send(fc, req);
@@ -733,9 +744,7 @@ static int fuse_do_getattr(struct inode 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	spin_lock(&fc->lock);
-	attr_version = fc->attr_version;
-	spin_unlock(&fc->lock);
+	attr_version = fuse_get_attr_version(fc);
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
