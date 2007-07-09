From: akpm@linux-foundation.org
Subject: - nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch removed from -mm tree
Date: Sun, 08 Jul 2007 23:44:46 -0700
Message-ID: <200707090644.l696ikvX023028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbXGIGpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 02:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: refactor IP address sanity checks in NFS client
has been removed from the -mm tree.  Its filename was
     nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 28 insertions(+), 11 deletions(-)

diff -puN fs/nfs/super.c~nfs-refactor-ip-address-sanity-checks-in-nfs-client fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-refactor-ip-address-sanity-checks-in-nfs-client
+++ a/fs/nfs/super.c
@@ -448,6 +448,28 @@ static void nfs_umount_begin(struct vfsm
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
@@ -502,11 +524,9 @@ static int nfs_validate_mount_data(struc
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
@@ -890,13 +910,10 @@ static int nfs4_get_sb(struct file_syste
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
