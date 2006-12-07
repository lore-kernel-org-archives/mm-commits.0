From: akpm@osdl.org
Subject: - affs-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:47 -0800
Message-ID: <200612072316.kB7NGl08030872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163782AbWLGXQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     affs: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     affs-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: affs: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/affs/bitmap.c |    3 +--
 fs/afs/server.c  |    3 +--
 fs/afs/super.c   |    4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/affs/bitmap.c~affs-replace-kmallocmemset-with-kzalloc fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~affs-replace-kmallocmemset-with-kzalloc
+++ a/fs/affs/bitmap.c
@@ -289,12 +289,11 @@ int affs_init_bitmap(struct super_block 
 	sbi->s_bmap_count = (sbi->s_partition_size - sbi->s_reserved +
 				 sbi->s_bmap_bits - 1) / sbi->s_bmap_bits;
 	size = sbi->s_bmap_count * sizeof(*bm);
-	bm = sbi->s_bitmap = kmalloc(size, GFP_KERNEL);
+	bm = sbi->s_bitmap = kzalloc(size, GFP_KERNEL);
 	if (!sbi->s_bitmap) {
 		printk(KERN_ERR "AFFS: Bitmap allocation failed\n");
 		return -ENOMEM;
 	}
-	memset(sbi->s_bitmap, 0, size);
 
 	bmap_blk = (__be32 *)sbi->s_root_bh->b_data;
 	blk = sb->s_blocksize / 4 - 49;
diff -puN fs/afs/server.c~affs-replace-kmallocmemset-with-kzalloc fs/afs/server.c
--- a/fs/afs/server.c~affs-replace-kmallocmemset-with-kzalloc
+++ a/fs/afs/server.c
@@ -55,13 +55,12 @@ int afs_server_lookup(struct afs_cell *c
 	_enter("%p,%08x,", cell, ntohl(addr->s_addr));
 
 	/* allocate and initialise a server record */
-	server = kmalloc(sizeof(struct afs_server), GFP_KERNEL);
+	server = kzalloc(sizeof(struct afs_server), GFP_KERNEL);
 	if (!server) {
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
 
-	memset(server, 0, sizeof(struct afs_server));
 	atomic_set(&server->usage, 1);
 
 	INIT_LIST_HEAD(&server->link);
diff -puN fs/afs/super.c~affs-replace-kmallocmemset-with-kzalloc fs/afs/super.c
--- a/fs/afs/super.c~affs-replace-kmallocmemset-with-kzalloc
+++ a/fs/afs/super.c
@@ -242,14 +242,12 @@ static int afs_fill_super(struct super_b
 	kenter("");
 
 	/* allocate a superblock info record */
-	as = kmalloc(sizeof(struct afs_super_info), GFP_KERNEL);
+	as = kzalloc(sizeof(struct afs_super_info), GFP_KERNEL);
 	if (!as) {
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
 
-	memset(as, 0, sizeof(struct afs_super_info));
-
 	afs_get_volume(params->volume);
 	as->volume = params->volume;
 
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch

