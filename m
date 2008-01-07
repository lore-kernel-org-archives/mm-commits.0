From: akpm@linux-foundation.org
Subject: - nfs-fix-nfs_free_unlinkdata.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:43 -0800
Message-ID: <200801072139.m07LdNVM013562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbYAGVnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:43:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, SteveD@redhat.com, mm-commits@vger.kernel.org


The patch titled
     NFS: Fix nfs_free_unlinkdata()
has been removed from the -mm tree.  Its filename was
     nfs-fix-nfs_free_unlinkdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NFS: Fix nfs_free_unlinkdata()
From: Trond Myklebust <Trond.Myklebust@netapp.com>

We should really only be calling nfs_sb_deactive() at the end of an RPC call,
to balance the nfs_sb_active() call in nfs_do_call_unlink().  OTOH,
nfs_free_unlinkdata() can be called from a variety of other situations.

Fix is to move the call to nfs_sb_deactive() into nfs_async_unlink_release().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Steve Dickson <SteveD@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/unlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/unlink.c~nfs-fix-nfs_free_unlinkdata fs/nfs/unlink.c
--- a/fs/nfs/unlink.c~nfs-fix-nfs_free_unlinkdata
+++ a/fs/nfs/unlink.c
@@ -31,7 +31,6 @@ struct nfs_unlinkdata {
 static void
 nfs_free_unlinkdata(struct nfs_unlinkdata *data)
 {
-	nfs_sb_deactive(NFS_SERVER(data->dir));
 	iput(data->dir);
 	put_rpccred(data->cred);
 	kfree(data->args.name.name);
@@ -116,6 +115,7 @@ static void nfs_async_unlink_release(voi
 	struct nfs_unlinkdata	*data = calldata;
 
 	nfs_dec_sillycount(data->dir);
+	nfs_sb_deactive(NFS_SERVER(data->dir));
 	nfs_free_unlinkdata(data);
 }
 
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

git-nfs.patch
