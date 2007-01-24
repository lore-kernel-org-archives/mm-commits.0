From: akpm@osdl.org
Subject: + ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:05:49 -0800
Message-ID: <200701240805.l0O85nIf012332@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbXAXIFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
has been added to the -mm tree.  Its filename is
     ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Call the new lookup_one_len_nd() rather than lookup_one_len().  This fixes an
oops when stacked on NFS.

Note that there are still some issues with eCryptfs on NFS having to do with
directory deletion (I'm not getting an oops, just an -EBUSY).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd
+++ a/fs/ecryptfs/inode.c
@@ -283,7 +283,9 @@ static struct dentry *ecryptfs_lookup(st
 	int rc = 0;
 	struct dentry *lower_dir_dentry;
 	struct dentry *lower_dentry;
+	struct dentry *dentry_save;
 	struct vfsmount *lower_mnt;
+	struct vfsmount *mnt_save;
 	char *encoded_name;
 	unsigned int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
@@ -311,9 +313,13 @@ static struct dentry *ecryptfs_lookup(st
 	}
 	ecryptfs_printk(KERN_DEBUG, "encoded_name = [%s]; encoded_namelen "
 			"= [%d]\n", encoded_name, encoded_namelen);
-	lower_dentry = lookup_one_len(encoded_name, lower_dir_dentry,
-				      encoded_namelen - 1);
+	dentry_save = nd->dentry;
+	mnt_save = nd->mnt;
+	lower_dentry = lookup_one_len_nd(encoded_name, lower_dir_dentry,
+					 (encoded_namelen - 1), nd);
 	kfree(encoded_name);
+	nd->mnt = mnt_save;
+	nd->dentry = dentry_save;
 	if (IS_ERR(lower_dentry)) {
 		ecryptfs_printk(KERN_ERR, "ERR from lower_dentry\n");
 		rc = PTR_ERR(lower_dentry);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-xattr-flags-and-mount-options.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-encrypted-passthrough.patch
ecryptfs-convert-f_op-write-to-vfs_write.patch
ecryptfs-convert-kmap-to-kmap_atomic.patch
ecryptfs-open-code-flag-checking-and-manipulation.patch
ecryptfs-add-flush_dcache_page-calls.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
