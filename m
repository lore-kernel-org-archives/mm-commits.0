From: akpm@osdl.org
Subject: - jffs-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:51 -0800
Message-ID: <200612072316.kB7NGpms030883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163820AbWLGXRA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     jffs-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jffs: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jffs/intrep.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/jffs/intrep.c~jffs-replace-kmallocmemset-with-kzalloc fs/jffs/intrep.c
--- a/fs/jffs/intrep.c~jffs-replace-kmallocmemset-with-kzalloc
+++ a/fs/jffs/intrep.c
@@ -592,7 +592,7 @@ jffs_add_virtual_root(struct jffs_contro
 	D2(printk("jffs_add_virtual_root(): "
 		  "Creating a virtual root directory.\n"));
 
-	if (!(root = kmalloc(sizeof(struct jffs_file), GFP_KERNEL))) {
+	if (!(root = kzalloc(sizeof(struct jffs_file), GFP_KERNEL))) {
 		return -ENOMEM;
 	}
 	no_jffs_file++;
@@ -604,7 +604,6 @@ jffs_add_virtual_root(struct jffs_contro
 	DJM(no_jffs_node++);
 	memset(node, 0, sizeof(struct jffs_node));
 	node->ino = JFFS_MIN_INO;
-	memset(root, 0, sizeof(struct jffs_file));
 	root->ino = JFFS_MIN_INO;
 	root->mode = S_IFDIR | S_IRWXU | S_IRGRP
 		     | S_IXGRP | S_IROTH | S_IXOTH;
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

