From: akpm@linux-foundation.org
Subject: + nfs-fix-nfs_free_unlinkdata.patch added to -mm tree
Date: Mon, 19 Nov 2007 21:40:23 -0800
Message-ID: <200711200540.lAK5eNtR016132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbXKTFlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 00:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, SteveD@redhat.com


The patch titled
     NFS: Fix nfs_free_unlinkdata()
has been added to the -mm tree.  Its filename is
     nfs-fix-nfs_free_unlinkdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch
nfs-fix-up-problems-with-steves-sillyrename-fix.patch
nfs-fix-nfs_free_unlinkdata.patch
nfs-fix-the-ustat-regression.patch
