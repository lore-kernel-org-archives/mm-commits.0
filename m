From: akpm@linux-foundation.org
Subject: + nfs-move-nfs_copy_user_string.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:28 -0700
Message-ID: <200705212141.l4LLfSCZ020716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468AbXEUVom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     NFS: move nfs_copy_user_string
has been added to the -mm tree.  Its filename is
     nfs-move-nfs_copy_user_string.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: move nfs_copy_user_string
From: Chuck Lever <chuck.lever@oracle.com>

Next patch will add a new function that calls nfs_copy_user_string.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/nfs/super.c~nfs-move-nfs_copy_user_string fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-move-nfs_copy_user_string
+++ a/fs/nfs/super.c
@@ -1670,6 +1670,27 @@ out_err:
 	return ERR_PTR(-EINVAL);
 }
 
+static void *nfs_copy_user_string(char *dst, struct nfs_string *src, int maxlen)
+{
+	void *p = NULL;
+
+	if (!src->len)
+		return ERR_PTR(-EINVAL);
+	if (src->len < maxlen)
+		maxlen = src->len;
+	if (dst == NULL) {
+		p = dst = kmalloc(maxlen + 1, GFP_KERNEL);
+		if (p == NULL)
+			return ERR_PTR(-ENOMEM);
+	}
+	if (copy_from_user(dst, src->data, maxlen)) {
+		kfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+	dst[maxlen] = '\0';
+	return dst;
+}
+
 /*
  * Finish setting up a cloned NFS4 superblock
  */
@@ -1694,27 +1715,6 @@ static void nfs4_fill_super(struct super
 	nfs_initialise_sb(sb);
 }
 
-static void *nfs_copy_user_string(char *dst, struct nfs_string *src, int maxlen)
-{
-	void *p = NULL;
-
-	if (!src->len)
-		return ERR_PTR(-EINVAL);
-	if (src->len < maxlen)
-		maxlen = src->len;
-	if (dst == NULL) {
-		p = dst = kmalloc(maxlen + 1, GFP_KERNEL);
-		if (p == NULL)
-			return ERR_PTR(-ENOMEM);
-	}
-	if (copy_from_user(dst, src->data, maxlen)) {
-		kfree(p);
-		return ERR_PTR(-EFAULT);
-	}
-	dst[maxlen] = '\0';
-	return dst;
-}
-
 /*
  * Get the superblock for an NFS4 mountpoint
  */
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
sunrpc-rename-rpcb_getport_external-routine.patch
sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch
nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch
nfs-clean-up-in-kernel-nfs-mount.patch
nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
