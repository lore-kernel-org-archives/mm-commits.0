From: akpm@linux-foundation.org
Subject: + 9p-convert-d_iname-references-to-d_namename.patch added to -mm tree
Date: Wed, 26 Nov 2008 16:05:04 -0800
Message-ID: <200811270005.mAR054ss019319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385AbYK0AFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 19:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ericvh@gmail.com, lucho@ionkov.net, wfg@linux.intel.com


The patch titled
     9p: convert d_iname references to d_name.name
has been added to the -mm tree.  Its filename is
     9p-convert-d_iname-references-to-d_namename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: convert d_iname references to d_name.name
From: Wu Fengguang <fengguang.wu@intel.com>

d_iname is rubbish for long file names.
Use d_name.name in printks instead.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/fid.c        |    4 ++--
 fs/9p/vfs_dentry.c |    6 +++---
 fs/9p/vfs_inode.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/9p/fid.c~9p-convert-d_iname-references-to-d_namename fs/9p/fid.c
--- a/fs/9p/fid.c~9p-convert-d_iname-references-to-d_namename
+++ a/fs/9p/fid.c
@@ -45,7 +45,7 @@ int v9fs_fid_add(struct dentry *dentry, 
 	struct v9fs_dentry *dent;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "fid %d dentry %s\n",
-					fid->fid, dentry->d_iname);
+					fid->fid, dentry->d_name.name);
 
 	dent = dentry->d_fsdata;
 	if (!dent) {
@@ -79,7 +79,7 @@ static struct p9_fid *v9fs_fid_find(stru
 	struct p9_fid *fid, *ret;
 
 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p) uid %d any %d\n",
-		dentry->d_iname, dentry, uid, any);
+		dentry->d_name.name, dentry, uid, any);
 	dent = (struct v9fs_dentry *) dentry->d_fsdata;
 	ret = NULL;
 	if (dent) {
diff -puN fs/9p/vfs_dentry.c~9p-convert-d_iname-references-to-d_namename fs/9p/vfs_dentry.c
--- a/fs/9p/vfs_dentry.c~9p-convert-d_iname-references-to-d_namename
+++ a/fs/9p/vfs_dentry.c
@@ -52,7 +52,7 @@
 
 static int v9fs_dentry_delete(struct dentry *dentry)
 {
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	return 1;
 }
@@ -69,7 +69,7 @@ static int v9fs_dentry_delete(struct den
 static int v9fs_cached_dentry_delete(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	if(!inode)
 		return 1;
@@ -88,7 +88,7 @@ void v9fs_dentry_release(struct dentry *
 	struct v9fs_dentry *dent;
 	struct p9_fid *temp, *current_fid;
 
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 	dent = dentry->d_fsdata;
 	if (dent) {
 		list_for_each_entry_safe(current_fid, temp, &dent->fidlist,
diff -puN fs/9p/vfs_inode.c~9p-convert-d_iname-references-to-d_namename fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~9p-convert-d_iname-references-to-d_namename
+++ a/fs/9p/vfs_inode.c
@@ -963,7 +963,7 @@ static int v9fs_vfs_readlink(struct dent
 	if (buflen > PATH_MAX)
 		buflen = PATH_MAX;
 
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name, dentry);
 
 	retval = v9fs_readlink(dentry, link, buflen);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
block-dont-take-lock-while-changing-ra_pages.patch
9p-convert-d_iname-references-to-d_namename.patch

