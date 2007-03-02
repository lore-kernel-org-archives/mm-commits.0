From: akpm@linux-foundation.org
Subject: + ecryptfs-lower-root-result-must-be-adirectory.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:24:24 -0800
Message-ID: <200703022224.l22MOOLV020819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXCBWZI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: lower root result must be adirectory
has been added to the -mm tree.  Its filename is
     ecryptfs-lower-root-result-must-be-adirectory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: lower root result must be adirectory
From: Dmitriy Monakhov <dmonakhov@sw.ru>

- Currently after path_lookup succeed we dot't have any guarantie what
  it is DIR. This must be explicitly demanded.
- path_lookup can't return negative dentry, So inode check is useless.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |    8 +-------
 1 files changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-lower-root-result-must-be-adirectory fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-lower-root-result-must-be-adirectory
+++ a/fs/ecryptfs/main.c
@@ -484,18 +484,12 @@ static int ecryptfs_read_super(struct su
 	struct vfsmount *lower_mnt;
 
 	memset(&nd, 0, sizeof(struct nameidata));
-	rc = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
+	rc = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
 		goto out;
 	}
 	lower_root = nd.dentry;
-	if (!lower_root->d_inode) {
-		ecryptfs_printk(KERN_WARNING,
-				"No directory to interpose on\n");
-		rc = -ENOENT;
-		goto out_free;
-	}
 	lower_mnt = nd.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

ecryptfs-check-xattr-operation-support-fix.patch
ecryptfs-lower-root-result-must-be-adirectory.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
