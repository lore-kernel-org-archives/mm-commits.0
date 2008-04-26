From: akpm@linux-foundation.org
Subject: - nfs-fix-potential-null-pointer-dereference-v2.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:57 -0700
Message-ID: <200804261641.m3QGfv3t031163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757888AbYDZQmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: fix potential NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     nfs-fix-potential-null-pointer-dereference-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: fix potential NULL pointer dereference
From: Cyrill Gorcunov <gorcunov@gmail.com>

There is a possible NULL pointer dereference if kstr[n]dup failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN fs/nfs/super.c~nfs-fix-potential-null-pointer-dereference-v2 fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-potential-null-pointer-dereference-v2
+++ a/fs/nfs/super.c
@@ -1295,6 +1295,8 @@ static int nfs_validate_mount_data(void 
 		args->namlen		= data->namlen;
 		args->bsize		= data->bsize;
 		args->auth_flavors[0]	= data->pseudoflavor;
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		/*
 		 * The legacy version 6 binary mount data from userspace has a
@@ -1341,6 +1343,8 @@ static int nfs_validate_mount_data(void 
 		len = c - dev_name;
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		c++;
 		if (strlen(c) > NFS_MAXPATHLEN)
@@ -1384,6 +1388,10 @@ out_v3_not_compiled:
 	return -EPROTONOSUPPORT;
 #endif /* !CONFIG_NFS_V3 */
 
+out_nomem:
+	dfprintk(MOUNT, "NFS: not enough memory to handle mount options\n");
+	return -ENOMEM;
+
 out_no_address:
 	dfprintk(MOUNT, "NFS: mount program didn't pass remote address\n");
 	return -EINVAL;
@@ -1890,12 +1898,16 @@ static int nfs4_validate_mount_data(void
 			return -ENAMETOOLONG;
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		c++;			/* step over the ':' */
 		len = strlen(c);
 		if (len > NFS4_MAXPATHLEN)
 			return -ENAMETOOLONG;
 		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
+		if (!args->nfs_server.export_path)
+			goto out_nomem;
 
 		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
 
@@ -1917,6 +1929,10 @@ out_inval_auth:
 		 data->auth_flavourlen);
 	return -EINVAL;
 
+out_nomem:
+	dfprintk(MOUNT, "NFS4: not enough memory to handle mount options\n");
+	return -ENOMEM;
+
 out_no_address:
 	dfprintk(MOUNT, "NFS4: mount program didn't pass remote address\n");
 	return -EINVAL;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
thinkpad-acpi-fix-possible-null-pointer-dereference.patch
git-m32r.patch
capifs-fix-memory-leak-on-remount.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

