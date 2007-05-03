From: akpm@linux-foundation.org
Subject: - nfs-statfs-error-handling-fix.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:21 -0700
Message-ID: <200705031931.l43JVLj2018262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767864AbXECTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amnonaar@gmail.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs statfs error-handling fix
has been removed from the -mm tree.  Its filename was
     nfs-statfs-error-handling-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs statfs error-handling fix
From: Amnon Aaronsohn <amnonaar@gmail.com>

The nfs statfs function returns a success code on error, and fills the
output buffer with invalid values.  The attached patch makes it return a
correct error code instead.

Signed-off-by: Amnon Aaronsohn <amnonaar@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/nfs/super.c~nfs-statfs-error-handling-fix fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-statfs-error-handling-fix
+++ a/fs/nfs/super.c
@@ -204,9 +204,9 @@ static int nfs_statfs(struct dentry *den
 	lock_kernel();
 
 	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
-	buf->f_type = NFS_SUPER_MAGIC;
 	if (error < 0)
-		goto out_err;
+		goto out;
+	buf->f_type = NFS_SUPER_MAGIC;
 
 	/*
 	 * Current versions of glibc do not correctly handle the
@@ -235,13 +235,7 @@ static int nfs_statfs(struct dentry *den
 	buf->f_namelen = server->namelen;
  out:
 	unlock_kernel();
-	return 0;
-
- out_err:
-	dprintk("%s: statfs error = %d\n", __FUNCTION__, -error);
-	buf->f_bsize = buf->f_blocks = buf->f_bfree = buf->f_bavail = -1;
-	goto out;
-
+	return error;
 }
 
 /*
_

Patches currently in -mm which might be from amnonaar@gmail.com are

git-nfs.patch
