From: akpm@linux-foundation.org
Subject: + nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:32 -0700
Message-ID: <200705212141.l4LLfWBb020722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756392AbXEUVon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     NFS: integrate support for processing nfs4 mount options in fs/nfs/super.c
has been added to the -mm tree.  Its filename is
     nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: integrate support for processing nfs4 mount options in fs/nfs/super.c
From: Chuck Lever <chuck.lever@oracle.com>

Finally, hook in the new mount option parsing logic.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   87 ++++++++++-------------------------------------
 1 files changed, 19 insertions(+), 68 deletions(-)

diff -puN fs/nfs/super.c~nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc
+++ a/fs/nfs/super.c
@@ -13,6 +13,8 @@
  *
  *  Split from inode.c by David Howells <dhowells@redhat.com>
  *
+ *  In-kernel mount option parsing by Chuck Lever <chuck.lever@oracle.com>
+ *
  * - superblocks are indexed on server only - all inodes, dentries, etc. associated with a
  *   particular server are held in the same superblock
  * - NFS superblocks can have several effective roots to the dentry tree
@@ -1580,7 +1582,6 @@ static int nfs4_parse_options(char *raw,
 			if (len > 80)
 				goto out_clntaddr_long;
 			match_strcpy(mnt->clientaddr, args);
-			mnt->nmd.client_addr.data = mnt->clientaddr;
 			mnt->nmd.client_addr.len = len;
 			break;
 		}
@@ -1653,10 +1654,8 @@ static struct nfs4_mount_data *nfs4_conv
 	args->nmd.acdirmax = 60;
 
 	args->nmd.auth_flavourlen = 0;
-	args->nmd.auth_flavours = &args->authflavor;
 
 	args->nmd.host_addrlen = sizeof(args->addr);
-	args->nmd.host_addr = (struct sockaddr *) &args->addr;
 
 	args->addr.sin_port = htons(NFS_PORT);
 
@@ -1700,6 +1699,7 @@ static int nfs4_validate_mount_data(stru
 				    char *ip_addr)
 {
 	struct nfs4_mount_data *data = *options;
+	struct nfs4_mount_args *args;
 	char *c;
 	unsigned len;
 
@@ -1755,25 +1755,26 @@ static int nfs4_validate_mount_data(stru
 		if (IS_ERR(data))
 			return PTR_ERR(data);
 		*options = data;
+		args = (struct nfs4_mount_args *) data;
 
-		memcpy(addr, data->host_addr, sizeof(*addr));
-		if (!nfs_verify_server_address((struct sockaddr *) addr,
+		if (!nfs_verify_server_address((struct sockaddr *) &args->addr,
 						data->host_addrlen))
 			return -EINVAL;
+		memcpy(addr, &args->addr, sizeof(*addr));
 
 		switch (data->auth_flavourlen) {
 		case 0:
 			*authflavour = RPC_AUTH_UNIX;
 			break;
 		case 1:
-			*authflavour = (rpc_authflavor_t) data->auth_flavours[0];
+			*authflavour = (rpc_authflavor_t) args->authflavor;
 			break;
 		default:
 			goto out_inval_auth;
 		}
 
 		memset(ip_addr, '\0', data->client_addr.len + 1);
-		strncpy(ip_addr, data->client_addr.data, data->client_addr.len);
+		strncpy(ip_addr, args->clientaddr, data->client_addr.len);
 
 		/*
 		 * Split "dev_name" into "hostname:mntpath".
@@ -1852,68 +1853,18 @@ static int nfs4_get_sb(struct file_syste
 	struct nfs_fh mntfh;
 	struct dentry *mntroot;
 	char *mntpath = NULL, *hostname = NULL, ip_addr[16];
-	void *p;
 	int (*compare_super)(struct super_block *,void *) = nfs_compare_super;
 	int error;
 
-	if (data == NULL) {
-		dprintk("%s: missing data argument\n", __FUNCTION__);
-		return -EINVAL;
-	}
-	if (data->version <= 0 || data->version > NFS4_MOUNT_VERSION) {
-		dprintk("%s: bad mount version\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	/* We now require that the mount process passes the remote address */
-	if (data->host_addrlen != sizeof(addr))
-		return -EINVAL;
-
-	if (copy_from_user(&addr, data->host_addr, sizeof(addr)))
-		return -EFAULT;
-
-	if (!nfs_verify_server_address((struct sockaddr *) &addr,
-					data->host_addrlen))
-		return -EINVAL;
-
-	/* RFC3530: The default port for NFS is 2049 */
-	if (addr.sin_port == 0)
-		addr.sin_port = htons(NFS_PORT);
-
-	/* Grab the authentication type */
-	authflavour = RPC_AUTH_UNIX;
-	if (data->auth_flavourlen != 0) {
-		if (data->auth_flavourlen != 1) {
-			dprintk("%s: Invalid number of RPC auth flavours %d.\n",
-					__FUNCTION__, data->auth_flavourlen);
-			error = -EINVAL;
-			goto out_err_noserver;
-		}
-
-		if (copy_from_user(&authflavour, data->auth_flavours,
-				   sizeof(authflavour))) {
-			error = -EFAULT;
-			goto out_err_noserver;
-		}
+ 	error = nfs4_validate_mount_data(&data, dev_name, &addr,
+ 					 &authflavour, &hostname,
+ 					 &mntpath, ip_addr);
+	if (error < 0) {
+		if (data != raw_data)
+			kfree(data);
+		return error;
 	}
 
-	p = nfs_copy_user_string(NULL, &data->hostname, 256);
-	if (IS_ERR(p))
-		goto out_err;
-	hostname = p;
-
-	p = nfs_copy_user_string(NULL, &data->mnt_path, 1024);
-	if (IS_ERR(p))
-		goto out_err;
-	mntpath = p;
-
-	dprintk("MNTPATH: %s\n", mntpath);
-
-	p = nfs_copy_user_string(ip_addr, &data->client_addr,
-				 sizeof(ip_addr) - 1);
-	if (IS_ERR(p))
-		goto out_err;
-
 	/* Get a volume representation */
 	server = nfs4_create_server(data, hostname, &addr, mntpath, ip_addr,
 				    authflavour, &mntfh);
@@ -1957,17 +1908,17 @@ static int nfs4_get_sb(struct file_syste
 	mnt->mnt_root = mntroot;
 	kfree(mntpath);
 	kfree(hostname);
+	if (data != raw_data)
+		kfree(data);
 	return 0;
 
-out_err:
-	error = PTR_ERR(p);
-	goto out_err_noserver;
-
 out_free:
 	nfs_free_server(server);
 out_err_noserver:
 	kfree(mntpath);
 	kfree(hostname);
+	if (data != raw_data)
+		kfree(data);
 	return error;
 
 error_splat_super:
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
