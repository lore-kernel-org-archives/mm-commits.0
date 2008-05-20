From: akpm@linux-foundation.org
Subject: - nfs-path_getput-cleanups.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:23 -0700
Message-ID: <200805202114.m4KLENnk011460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763350AbYETVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: path_{get,put}() cleanups
has been removed from the -mm tree.  Its filename was
     nfs-path_getput-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: path_{get,put}() cleanups
From: Jan Blunck <jblunck@suse.de>

Here are some more places where path_{get,put}() can be used instead of
dput()/mntput() pair.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/inode.c     |    3 +--
 fs/nfs/namespace.c |    3 +--
 fs/nfs/nfs4proc.c  |    6 ++----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/nfs/inode.c~nfs-path_getput-cleanups fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-path_getput-cleanups
+++ a/fs/nfs/inode.c
@@ -541,8 +541,7 @@ static void __put_nfs_open_context(struc
 	}
 	if (ctx->cred != NULL)
 		put_rpccred(ctx->cred);
-	dput(ctx->path.dentry);
-	mntput(ctx->path.mnt);
+	path_put(&ctx->path);
 	kfree(ctx);
 }
 
diff -puN fs/nfs/namespace.c~nfs-path_getput-cleanups fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~nfs-path_getput-cleanups
+++ a/fs/nfs/namespace.c
@@ -137,8 +137,7 @@ static void * nfs_follow_mountpoint(stru
 			goto out_follow;
 		goto out_err;
 	}
-	mntput(nd->path.mnt);
-	dput(nd->path.dentry);
+	path_put(&nd->path);
 	nd->path.mnt = mnt;
 	nd->path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
diff -puN fs/nfs/nfs4proc.c~nfs-path_getput-cleanups fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~nfs-path_getput-cleanups
+++ a/fs/nfs/nfs4proc.c
@@ -306,8 +306,7 @@ static void nfs4_opendata_free(struct kr
 		nfs4_put_open_state(p->state);
 	nfs4_put_state_owner(p->owner);
 	dput(p->dir);
-	dput(p->path.dentry);
-	mntput(p->path.mnt);
+	path_put(&p->path);
 	kfree(p);
 }
 
@@ -1210,8 +1209,7 @@ static void nfs4_free_closedata(void *da
 	nfs4_put_open_state(calldata->state);
 	nfs_free_seqid(calldata->arg.seqid);
 	nfs4_put_state_owner(sp);
-	dput(calldata->path.dentry);
-	mntput(calldata->path.mnt);
+	path_put(&calldata->path);
 	kfree(calldata);
 }
 
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
git-unionfs.patch
vfs-path_getput-cleanups.patch

