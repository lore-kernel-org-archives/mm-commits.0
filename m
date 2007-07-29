From: akpm@linux-foundation.org
Subject: + nfs-fix-put_nfs_open_context.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:40:54 -0700
Message-ID: <200707290640.l6T6esiQ012069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759137AbXG2Glz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, bfields@fieldses.org


The patch titled
     NFS: Fix put_nfs_open_context
has been added to the -mm tree.  Its filename is
     nfs-fix-put_nfs_open_context.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Fix put_nfs_open_context
From: Trond Myklebust <Trond.Myklebust@netapp.com>

We need to grab the inode->i_lock atomically with the last reference put in
order to remove the open context that is being freed from the
nfsi->open_files list.

Fix by converting the kref to a standard atomic counter and then using
atomic_dec_and_lock()...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/inode.c         |   24 ++++++++----------------
 include/linux/nfs_fs.h |    2 +-
 2 files changed, 9 insertions(+), 17 deletions(-)

diff -puN fs/nfs/inode.c~nfs-fix-put_nfs_open_context fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-fix-put_nfs_open_context
+++ a/fs/nfs/inode.c
@@ -468,7 +468,7 @@ static struct nfs_open_context *alloc_nf
 		ctx->lockowner = current->files;
 		ctx->error = 0;
 		ctx->dir_cookie = 0;
-		kref_init(&ctx->kref);
+		atomic_set(&ctx->count, 1);
 	}
 	return ctx;
 }
@@ -476,21 +476,18 @@ static struct nfs_open_context *alloc_nf
 struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx)
 {
 	if (ctx != NULL)
-		kref_get(&ctx->kref);
+		atomic_inc(&ctx->count);
 	return ctx;
 }
 
-static void nfs_free_open_context(struct kref *kref)
+void put_nfs_open_context(struct nfs_open_context *ctx)
 {
-	struct nfs_open_context *ctx = container_of(kref,
-			struct nfs_open_context, kref);
+	struct inode *inode = ctx->path.dentry->d_inode;
 
-	if (!list_empty(&ctx->list)) {
-		struct inode *inode = ctx->path.dentry->d_inode;
-		spin_lock(&inode->i_lock);
-		list_del(&ctx->list);
-		spin_unlock(&inode->i_lock);
-	}
+	if (!atomic_dec_and_lock(&ctx->count, &inode->i_lock))
+		return;
+	list_del(&ctx->list);
+	spin_unlock(&inode->i_lock);
 	if (ctx->state != NULL)
 		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
 	if (ctx->cred != NULL)
@@ -500,11 +497,6 @@ static void nfs_free_open_context(struct
 	kfree(ctx);
 }
 
-void put_nfs_open_context(struct nfs_open_context *ctx)
-{
-	kref_put(&ctx->kref, nfs_free_open_context);
-}
-
 /*
  * Ensure that mmap has a recent RPC credential for use when writing out
  * shared pages
diff -puN include/linux/nfs_fs.h~nfs-fix-put_nfs_open_context include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-fix-put_nfs_open_context
+++ a/include/linux/nfs_fs.h
@@ -69,7 +69,7 @@ struct nfs_access_entry {
 
 struct nfs4_state;
 struct nfs_open_context {
-	struct kref kref;
+	atomic_t count;
 	struct path path;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

nfs-fix-put_nfs_open_context.patch
nfs-convert-to-new-aops.patch
sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch
locks-kill-redundant-local-variable.patch
