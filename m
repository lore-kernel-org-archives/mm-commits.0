From: akpm@linux-foundation.org
Subject: - uml-hostfs-variable-renaming.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:23 -0700
Message-ID: <200703292337.l2TNbNkL015095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945927AbXC2XhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: hostfs variable renaming
has been removed from the -mm tree.  Its filename was
     uml-hostfs-variable-renaming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: hostfs variable renaming
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

* rename name to host_root_path
* rename data to req_root.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-variable-renaming fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-variable-renaming
+++ a/fs/hostfs/hostfs_kern.c
@@ -938,7 +938,7 @@ static const struct address_space_operat
 static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 {
 	struct inode *root_inode;
-	char *name, *data = d;
+	char *host_root_path, *req_root = d;
 	int err;
 
 	sb->s_blocksize = 1024;
@@ -947,16 +947,16 @@ static int hostfs_fill_sb_common(struct 
 	sb->s_op = &hostfs_sbops;
 
 	/* NULL is printed as <NULL> by sprintf: avoid that. */
-	if (data == NULL)
-		data = "";
+	if (req_root == NULL)
+		req_root = "";
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(root_ino) + 1
-			+ strlen(data) + 1, GFP_KERNEL);
-	if(name == NULL)
+	host_root_path = kmalloc(strlen(root_ino) + 1
+				 + strlen(req_root) + 1, GFP_KERNEL);
+	if(host_root_path == NULL)
 		goto out;
 
-	sprintf(name, "%s/%s", root_ino, data);
+	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)
@@ -966,10 +966,10 @@ static int hostfs_fill_sb_common(struct 
 	if(err)
 		goto out_put;
 
-	HOSTFS_I(root_inode)->host_filename = name;
-	/* Avoid that in the error path, iput(root_inode) frees again name through
-	 * hostfs_destroy_inode! */
-	name = NULL;
+	HOSTFS_I(root_inode)->host_filename = host_root_path;
+	/* Avoid that in the error path, iput(root_inode) frees again
+	 * host_root_path through hostfs_destroy_inode! */
+	host_root_path = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
@@ -989,7 +989,7 @@ static int hostfs_fill_sb_common(struct 
  out_put:
         iput(root_inode);
  out_free:
-	kfree(name);
+	kfree(host_root_path);
  out:
 	return(err);
 }
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
git-gccbug.patch
