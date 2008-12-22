From: akpm@linux-foundation.org
Subject: - 9p-convert-d_iname-references-to-d_namename.patch removed from -mm tree
Date: Mon, 22 Dec 2008 11:48:32 -0800
Message-ID: <200812221948.mBMJmWnA002206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYLVTsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 14:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ericvh@gmail.com, lucho@ionkov.net, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     9p: convert d_iname references to d_name.name
has been removed from the -mm tree.  Its filename was
     9p-convert-d_iname-references-to-d_namename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

