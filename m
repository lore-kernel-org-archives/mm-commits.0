From: akpm@linux-foundation.org
Subject: - nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:10 -0700
Message-ID: <200705291629.l4TGT9gl005485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbXE2Q3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: implement NFSv2/3 in-kernel mount option parsing
has been removed from the -mm tree.  Its filename was
     nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: implement NFSv2/3 in-kernel mount option parsing
From: Chuck Lever <chuck.lever@oracle.com>

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |  132 +++++++++++++++++++++++++++++------------------
 1 files changed, 83 insertions(+), 49 deletions(-)

diff -puN fs/nfs/super.c~nfs-implement-nfsv2-3-in-kernel-mount-option-parsing fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-implement-nfsv2-3-in-kernel-mount-option-parsing
+++ a/fs/nfs/super.c
@@ -934,8 +934,6 @@ static struct nfs_mount_data *nfs_conver
 	if (args == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	args->nmd.version = 7;
-
 	args->nmd.flags = (NFS_MOUNT_VER3 | NFS_MOUNT_TCP);
 	args->nmd.rsize = NFS_MAX_FILE_IO_SIZE;
 	args->nmd.wsize = NFS_MAX_FILE_IO_SIZE;
@@ -988,71 +986,74 @@ out_invalid:
  * Validate the NFS2/NFS3 mount data
  * - fills in the mount root filehandle
  */
-static int nfs_validate_mount_data(struct nfs_mount_data *data,
-				   struct nfs_fh *mntfh)
-{
-	if (data == NULL) {
-		dprintk("%s: missing data argument\n", __FUNCTION__);
-		return -EINVAL;
-	}
+static int nfs_validate_mount_data(struct nfs_mount_data **options,
+				   struct nfs_fh *mntfh,
+				   const char *dev_name)
+{
+	struct nfs_mount_data *data = *options;
+	unsigned int len;
+	char *c;
+	int status;
 
-	if (data->version <= 0 || data->version > NFS_MOUNT_VERSION) {
-		dprintk("%s: bad mount version\n", __FUNCTION__);
-		return -EINVAL;
-	}
+	if (data == NULL)
+		goto out_no_data;
 
 	switch (data->version) {
-		case 1:
-			data->namlen = 0;
-		case 2:
-			data->bsize  = 0;
-		case 3:
-			if (data->flags & NFS_MOUNT_VER3) {
-				dprintk("%s: mount structure version %d does not support NFSv3\n",
-						__FUNCTION__,
-						data->version);
-				return -EINVAL;
-			}
-			data->root.size = NFS2_FHSIZE;
-			memcpy(data->root.data, data->old_root.data, NFS2_FHSIZE);
-		case 4:
-			if (data->flags & NFS_MOUNT_SECFLAVOUR) {
-				dprintk("%s: mount structure version %d does not support strong security\n",
-						__FUNCTION__,
-						data->version);
-				return -EINVAL;
-			}
-		case 5:
-			memset(data->context, 0, sizeof(data->context));
+	case 1:
+		data->namlen = 0;
+	case 2:
+		data->bsize  = 0;
+	case 3:
+		if (data->flags & NFS_MOUNT_VER3)
+			goto out_no_v3;
+		data->root.size = NFS2_FHSIZE;
+		memcpy(data->root.data, data->old_root.data, NFS2_FHSIZE);
+	case 4:
+		if (data->flags & NFS_MOUNT_SECFLAVOUR)
+			goto out_no_sec;
+	case 5:
+		memset(data->context, 0, sizeof(data->context));
+	case 6:
+		break;
+	default:
+		data = nfs_convert_mount_opts((char *) data);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+		*options = data;
+
+		c = strchr(dev_name, ':');
+		if (c == NULL)
+			return -EINVAL;
+		len = c - dev_name - 1;
+		if (len > 256)
+			return -EINVAL;
+		strncpy(data->hostname, dev_name, len);
+
+		status = nfs_try_mount(data, ++c);
+		if (status)
+			return -EINVAL;
 	}
 
-	/* Set the pseudoflavor */
 	if (!(data->flags & NFS_MOUNT_SECFLAVOUR))
 		data->pseudoflavor = RPC_AUTH_UNIX;
 
 #ifndef CONFIG_NFS_V3
-	/* If NFSv3 is not compiled in, return -EPROTONOSUPPORT */
-	if (data->flags & NFS_MOUNT_VER3) {
-		dprintk("%s: NFSv3 not compiled into kernel\n", __FUNCTION__);
-		return -EPROTONOSUPPORT;
-	}
-#endif /* CONFIG_NFS_V3 */
+	if (data->flags & NFS_MOUNT_VER3)
+		goto out_v3_not_compiled;
+#endif /* !CONFIG_NFS_V3 */
 
 	/* We now require that the mount process passes the remote address */
 	if (!nfs_verify_server_address((struct sockaddr *) &data->addr,
 						sizeof(data->addr)))
  		return -EINVAL;
 
-	/* Prepare the root filehandle */
 	if (data->flags & NFS_MOUNT_VER3)
 		mntfh->size = data->root.size;
 	else
 		mntfh->size = NFS2_FHSIZE;
 
-	if (mntfh->size > sizeof(mntfh->data)) {
-		dprintk("%s: invalid root filehandle\n", __FUNCTION__);
-		return -EINVAL;
-	}
+	if (mntfh->size > sizeof(mntfh->data))
+		goto out_invalid_fh;
 
 	memcpy(mntfh->data, data->root.data, mntfh->size);
 	if (mntfh->size < sizeof(mntfh->data))
@@ -1060,6 +1061,30 @@ static int nfs_validate_mount_data(struc
 		       sizeof(mntfh->data) - mntfh->size);
 
 	return 0;
+
+out_no_data:
+	dprintk("NFS: mount program didn't pass any mount data\n");
+	return -EINVAL;
+
+out_no_v3:
+	dprintk("NFS: nfs_mount_data version %d does not support NFSv3\n",
+		data->version);
+	return -EINVAL;
+
+out_no_sec:
+	dprintk("NFS: nfs_mount_data version %d supports only AUTH_SYS\n",
+		data->version);
+	return -EINVAL;
+
+#ifndef CONFIG_NFS_V3
+out_v3_not_compiled:
+	dprintk("NFS: NFSv3 is not compiled into kernel\n");
+	return -EPROTONOSUPPORT;
+#endif /* !CONFIG_NFS_V3 */
+
+out_invalid_fh:
+	dprintk("NFS: invalid root filehandle\n");
+	return -EINVAL;
 }
 
 /*
@@ -1206,9 +1231,12 @@ static int nfs_get_sb(struct file_system
 	int error;
 
 	/* Validate the mount data */
-	error = nfs_validate_mount_data(data, &mntfh);
-	if (error < 0)
+	error = nfs_validate_mount_data(&data, &mntfh, dev_name);
+	if (error < 0) {
+		if (data != raw_data)
+			kfree(data);
 		return error;
+	}
 
 	/* Get a volume representation */
 	server = nfs_create_server(data, &mntfh);
@@ -1250,16 +1278,22 @@ static int nfs_get_sb(struct file_system
 	s->s_flags |= MS_ACTIVE;
 	mnt->mnt_sb = s;
 	mnt->mnt_root = mntroot;
+	if (data != raw_data)
+		kfree(data);
 	return 0;
 
 out_err_nosb:
 	nfs_free_server(server);
 out_err_noserver:
+	if (data != raw_data)
+		kfree(data);
 	return error;
 
 error_splat_super:
 	up_write(&s->s_umount);
 	deactivate_super(s);
+	if (data != raw_data)
+		kfree(data);
 	return error;
 }
 
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
