From: akpm@linux-foundation.org
Subject: - nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:16 -0700
Message-ID: <200705291629.l4TGTFEW005497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbXE2Q3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: more nfs4 in-kernel mount option parsing infrastructure
has been removed from the -mm tree.  Its filename was
     nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: more nfs4 in-kernel mount option parsing infrastructure
From: Chuck Lever <chuck.lever@oracle.com>

Add function for switching between an nfs4_mount_data structure from user
space (the current nfs4 mount mechanism) and generating an nfs4_mount_data
structure from a text string containing nfs4 mount options.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+)

diff -puN fs/nfs/super.c~nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure
+++ a/fs/nfs/super.c
@@ -1691,6 +1691,129 @@ static void *nfs_copy_user_string(char *
 	return dst;
 }
 
+static int nfs4_validate_mount_data(struct nfs4_mount_data **options,
+				    const char *dev_name,
+				    struct sockaddr_in *addr,
+				    rpc_authflavor_t *authflavour,
+				    char **hostname,
+				    char **mntpath,
+				    char *ip_addr)
+{
+	struct nfs4_mount_data *data = *options;
+	char *c;
+	unsigned len;
+
+	if (data == NULL) {
+		dprintk("%s: missing data argument\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	switch (data->version) {
+	case 1:
+		if (data->host_addrlen != sizeof(*addr))
+			return -EINVAL;
+		if (copy_from_user(addr, data->host_addr, sizeof(*addr)))
+			return -EFAULT;
+		if (addr->sin_port == 0)
+			addr->sin_port = htons(NFS_PORT);
+		if (!nfs_verify_server_address((struct sockaddr *) addr,
+					       data->host_addrlen))
+			return -EINVAL;
+
+		switch (data->auth_flavourlen) {
+		case 0:
+			*authflavour = RPC_AUTH_UNIX;
+			break;
+		case 1:
+			if (copy_from_user(authflavour, data->auth_flavours,
+					   sizeof(*authflavour)))
+				return -EFAULT;
+		default:
+			goto out_inval_auth;
+		}
+
+		c = nfs_copy_user_string(ip_addr, &data->client_addr, 80);
+		if (IS_ERR(c))
+			return PTR_ERR(c);
+
+		c = nfs_copy_user_string(NULL, &data->hostname, 256);
+		if (IS_ERR(c))
+			return PTR_ERR(c);
+		*hostname = c;
+
+		c = nfs_copy_user_string(NULL, &data->mnt_path, 1024);
+		if (IS_ERR(c)) {
+			kfree(*hostname);
+			return PTR_ERR(c);
+		}
+		*mntpath = c;
+		dprintk("MNTPATH: %s\n", *mntpath);
+
+		return 0;
+	default:
+		data = nfs4_convert_mount_opts((char *) data);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+		*options = data;
+
+		memcpy(addr, data->host_addr, sizeof(*addr));
+		if (!nfs_verify_server_address((struct sockaddr *) addr,
+						data->host_addrlen))
+			return -EINVAL;
+
+		switch (data->auth_flavourlen) {
+		case 0:
+			*authflavour = RPC_AUTH_UNIX;
+			break;
+		case 1:
+			*authflavour = (rpc_authflavor_t) data->auth_flavours[0];
+			break;
+		default:
+			goto out_inval_auth;
+		}
+
+		memset(ip_addr, '\0', data->client_addr.len + 1);
+		strncpy(ip_addr, data->client_addr.data, data->client_addr.len);
+
+		/*
+		 * Split "dev_name" into "hostname:mntpath".
+		 */
+		c = strchr(dev_name, ':');
+		if (c == NULL)
+			return -EINVAL;
+		/* while calculating len, pretend ':' is '\0' */
+		len = c - dev_name;
+		if (len > 256)
+			return -EINVAL;
+		*hostname = kzalloc(len, GFP_KERNEL);
+		if (*hostname == NULL)
+			return -ENOMEM;
+		strncpy(*hostname, dev_name, len - 1);
+
+		c++;			/* step over the ':' */
+		len = strlen(c);
+		if (len > 1023) {
+			kfree(*hostname);
+			return -EINVAL;
+		}
+		*mntpath = kzalloc(len + 1, GFP_KERNEL);
+		if (*mntpath == NULL) {
+			kfree(*hostname);
+			return -ENOMEM;
+		}
+		strncpy(*mntpath, c, len);
+
+		dprintk("MNTPATH: %s\n", *mntpath);
+
+		return 0;
+	}
+
+out_inval_auth:
+	dprintk("NFS4: Invalid number of RPC auth flavours %d\n",
+		data->auth_flavourlen);
+	return -EINVAL;
+}
+
 /*
  * Finish setting up a cloned NFS4 superblock
  */
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
