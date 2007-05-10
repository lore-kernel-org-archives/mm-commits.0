From: akpm@linux-foundation.org
Subject: + afs-fix-a-couple-of-problems-with-unlinking-afs-files.patch added to -mm tree
Date: Thu, 10 May 2007 16:18:24 -0700
Message-ID: <200705102318.l4ANIOb6001123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbXEJXSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: fix a couple of problems with unlinking AFS files
has been added to the -mm tree.  Its filename is
     afs-fix-a-couple-of-problems-with-unlinking-afs-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFS: fix a couple of problems with unlinking AFS files
From: David Howells <dhowells@redhat.com>

Fix a couple of problems with unlinking AFS files.

 (1) The parent directory wasn't being updated properly between unlink() and
     the following lookup().

     It seems that, for some reason, invalidate_remote_inode() wasn't
     discarding the directory contents correctly, so this patch calls
     invalidate_inode_pages2() instead on non-regular files.

 (2) afs_vnode_deleted_remotely() should handle vnodes that don't have a
     source server recorded without oopsing.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c  |    2 +-
 fs/afs/inode.c |   10 +++++++---
 fs/afs/super.c |    3 ++-
 fs/afs/vnode.c |   33 +++++++++++++++++++++------------
 4 files changed, 31 insertions(+), 17 deletions(-)

diff -puN fs/afs/file.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files fs/afs/file.c
--- a/fs/afs/file.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files
+++ a/fs/afs/file.c
@@ -236,7 +236,7 @@ static void afs_invalidatepage(struct pa
 {
 	int ret = 1;
 
-	kenter("{%lu},%lu", page->index, offset);
+	_enter("{%lu},%lu", page->index, offset);
 
 	BUG_ON(!PageLocked(page));
 
diff -puN fs/afs/inode.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files fs/afs/inode.c
--- a/fs/afs/inode.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files
+++ a/fs/afs/inode.c
@@ -209,11 +209,15 @@ bad_inode:
  */
 void afs_zap_data(struct afs_vnode *vnode)
 {
-	_enter("zap data {%x:%u}", vnode->fid.vid, vnode->fid.vnode);
+	_enter("{%x:%u}", vnode->fid.vid, vnode->fid.vnode);
 
 	/* nuke all the non-dirty pages that aren't locked, mapped or being
-	 * written back */
-	invalidate_remote_inode(&vnode->vfs_inode);
+	 * written back in a regular file and completely discard the pages in a
+	 * directory or symlink */
+	if (S_ISREG(vnode->vfs_inode.i_mode))
+		invalidate_remote_inode(&vnode->vfs_inode);
+	else
+		invalidate_inode_pages2(vnode->vfs_inode.i_mapping);
 }
 
 /*
diff -puN fs/afs/super.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files fs/afs/super.c
--- a/fs/afs/super.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files
+++ a/fs/afs/super.c
@@ -488,6 +488,7 @@ static struct inode *afs_alloc_inode(str
 	vnode->flags		= 1 << AFS_VNODE_UNSET;
 	vnode->cb_promised	= false;
 
+	_leave(" = %p", &vnode->vfs_inode);
 	return &vnode->vfs_inode;
 }
 
@@ -498,7 +499,7 @@ static void afs_destroy_inode(struct ino
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 
-	_enter("{%lu}", inode->i_ino);
+	_enter("%p{%x:%u}", inode, vnode->fid.vid, vnode->fid.vnode);
 
 	_debug("DESTROY INODE %p", inode);
 
diff -puN fs/afs/vnode.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files fs/afs/vnode.c
--- a/fs/afs/vnode.c~afs-fix-a-couple-of-problems-with-unlinking-afs-files
+++ a/fs/afs/vnode.c
@@ -175,24 +175,33 @@ static void afs_vnode_deleted_remotely(s
 {
 	struct afs_server *server;
 
+	_enter("{%p}", vnode->server);
+
 	set_bit(AFS_VNODE_DELETED, &vnode->flags);
 
 	server = vnode->server;
-	if (vnode->cb_promised) {
-		spin_lock(&server->cb_lock);
+	if (server) {
 		if (vnode->cb_promised) {
-			rb_erase(&vnode->cb_promise, &server->cb_promises);
-			vnode->cb_promised = false;
+			spin_lock(&server->cb_lock);
+			if (vnode->cb_promised) {
+				rb_erase(&vnode->cb_promise,
+					 &server->cb_promises);
+				vnode->cb_promised = false;
+			}
+			spin_unlock(&server->cb_lock);
 		}
-		spin_unlock(&server->cb_lock);
-	}
 
-	spin_lock(&vnode->server->fs_lock);
-	rb_erase(&vnode->server_rb, &vnode->server->fs_vnodes);
-	spin_unlock(&vnode->server->fs_lock);
+		spin_lock(&server->fs_lock);
+		rb_erase(&vnode->server_rb, &server->fs_vnodes);
+		spin_unlock(&server->fs_lock);
+
+		vnode->server = NULL;
+		afs_put_server(server);
+	} else {
+		ASSERT(!vnode->cb_promised);
+	}
 
-	vnode->server = NULL;
-	afs_put_server(server);
+	_leave("");
 }
 
 /*
@@ -225,7 +234,7 @@ void afs_vnode_finalise_status_update(st
  */
 static void afs_vnode_status_update_failed(struct afs_vnode *vnode, int ret)
 {
-	_enter("%p,%d", vnode, ret);
+	_enter("{%x:%u},%d", vnode->fid.vid, vnode->fid.vnode, ret);
 
 	spin_lock(&vnode->lock);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch
afs-fix-a-couple-of-problems-with-unlinking-afs-files.patch
introduce-freezer-flags-rev-2.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
