From: akpm@linux-foundation.org
Subject: + nfs-fix-potential-null-pointer-dereference-v2.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:01:16 -0700
Message-ID: <200804172101.m3HL1GvI027791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616AbYDQVBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix potential NULL pointer dereference
has been added to the -mm tree.  Its filename is
     nfs-fix-potential-null-pointer-dereference-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-x86.patch
git-avr32.patch
git-dvb.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
nfs-fix-potential-null-pointer-dereference-v2.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

