From: akpm@linux-foundation.org
Subject: + nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:07 -0700
Message-ID: <200705212141.l4LLf7d4020686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757010AbXEUVow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     NFS: refactor IP address sanity checks in NFS client
has been added to the -mm tree.  Its filename is
     nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: refactor IP address sanity checks in NFS client
From: Chuck Lever <chuck.lever@oracle.com>

Provide mechanism for adding IPv6 address support at some later point.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff -puN fs/nfs/super.c~nfs-refactor-ip-address-sanity-checks-in-nfs-client fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-refactor-ip-address-sanity-checks-in-nfs-client
+++ a/fs/nfs/super.c
@@ -435,6 +435,28 @@ static void nfs_umount_begin(struct vfsm
 }
 
 /*
+ * Sanity-check a server address provided by the mount command
+ */
+static int nfs_verify_server_address(struct sockaddr *addr, size_t len)
+{
+	if (len > sizeof(struct sockaddr))
+		goto out_invalid;
+
+	switch (addr->sa_family) {
+	case AF_INET: {
+		struct sockaddr_in *sa = (struct sockaddr_in *) addr;
+		if (sa->sin_addr.s_addr != INADDR_ANY)
+			return 1;
+		break;
+	}
+	}
+
+out_invalid:
+	dprintk("NFS: mount program passed an invalid remote address\n");
+	return 0;
+}
+
+/*
  * Validate the NFS2/NFS3 mount data
  * - fills in the mount root filehandle
  */
@@ -489,11 +511,9 @@ static int nfs_validate_mount_data(struc
 #endif /* CONFIG_NFS_V3 */
 
 	/* We now require that the mount process passes the remote address */
-	if (data->addr.sin_addr.s_addr == INADDR_ANY) {
-		dprintk("%s: mount program didn't pass remote address!\n",
-			__FUNCTION__);
-		return -EINVAL;
-	}
+	if (!nfs_verify_server_address((struct sockaddr *) &data->addr,
+						sizeof(data->addr)))
+ 		return -EINVAL;
 
 	/* Prepare the root filehandle */
 	if (data->flags & NFS_MOUNT_VER3)
@@ -877,13 +897,10 @@ static int nfs4_get_sb(struct file_syste
 	if (copy_from_user(&addr, data->host_addr, sizeof(addr)))
 		return -EFAULT;
 
-	if (addr.sin_family != AF_INET ||
-	    addr.sin_addr.s_addr == INADDR_ANY
-	    ) {
-		dprintk("%s: mount program didn't pass remote IP address!\n",
-				__FUNCTION__);
+	if (!nfs_verify_server_address((struct sockaddr *) &addr,
+					data->host_addrlen))
 		return -EINVAL;
-	}
+
 	/* RFC3530: The default port for NFS is 2049 */
 	if (addr.sin_port == 0)
 		addr.sin_port = htons(NFS_PORT);
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
