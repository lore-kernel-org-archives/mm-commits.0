Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD382149C50
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248854; cv=none; b=G2TufrhClljvLEVTb4NuSerIWeq6J8E9UMXUwFIbHSht7PRh6FAk65ymS1v8ICsCPq/PKZdU6q7JjsnolBiUQz/Eg+wHdQ0O/DByUZAOwDB8LPhOuBSEuAZG5ajdcLoHUPTOKFvnNT/VKifLya9MfRC8MYIDj/VEhAkFGsB6h6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248854; c=relaxed/simple;
	bh=rPVUvwMC/kQ/0Y8ZfObFo7DBKXVQmHVMnoejMgBXiBI=;
	h=Date:To:From:Subject:Message-Id; b=TKTwQskI5VFOI79P9MR6h8WElC22DNo3tykN1LBPak3/UuvD1CGbJDnZieLnxZNx7GJYFnD2x5YtQnYu+CVSIo8+8oXHFTFu73BOuQTK9DRCPgIm0xig5fltK1yT7iqjh7zwHqzvPrYSlC3Eky5G+bLBrVPKVXnS+qMKOoMP05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yEa/z/tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yEa/z/tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F12C4CEC2;
	Mon,  2 Sep 2024 03:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248854;
	bh=rPVUvwMC/kQ/0Y8ZfObFo7DBKXVQmHVMnoejMgBXiBI=;
	h=Date:To:From:Subject:From;
	b=yEa/z/tcDqpFCUUGBl+3gmCeltZdJQkGVCuUvstLgSXnyPnRXuHX0+bb8LPMsIumR
	 79/lT3ke3pHGbtTxfPzdJ62krP+aIY56CsQK0keOJcCIxumo3A0mJahJlcZO81oYCj
	 W3vhxcUbr4YBJ4G3a4d3vVpzeIP59MORpuckvRco=
Date: Sun, 01 Sep 2024 20:47:34 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch removed from -mm tree
Message-Id: <20240902034734.94F12C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: eliminate the shared counter and spinlock for i_generation
has been removed from the -mm tree.  Its filename was
     nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: eliminate the shared counter and spinlock for i_generation
Date: Tue, 27 Aug 2024 02:41:12 +0900

Use get_random_u32() as the source for inode->i_generation for new inodes,
and eliminate the original source, the shared counter ns_next_generation
along with its exclusive access spinlock ns_next_gen_lock.

Link: https://lkml.kernel.org/r/20240826174116.5008-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c     |    6 ++----
 fs/nilfs2/the_nilfs.c |    5 -----
 fs/nilfs2/the_nilfs.h |    6 ------
 3 files changed, 2 insertions(+), 15 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/inode.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/fiemap.h>
+#include <linux/random.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
@@ -320,7 +321,6 @@ static int nilfs_insert_inode_locked(str
 struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
-	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
@@ -381,9 +381,7 @@ struct inode *nilfs_new_inode(struct ino
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
-	spin_lock(&nilfs->ns_next_gen_lock);
-	inode->i_generation = nilfs->ns_next_generation++;
-	spin_unlock(&nilfs->ns_next_gen_lock);
+	inode->i_generation = get_random_u32();
 	if (nilfs_insert_inode_locked(inode, root, ino) < 0) {
 		err = -EIO;
 		goto failed_after_creation;
--- a/fs/nilfs2/the_nilfs.c~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/the_nilfs.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
-#include <linux/random.h>
 #include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
@@ -69,7 +68,6 @@ struct the_nilfs *alloc_nilfs(struct sup
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
-	spin_lock_init(&nilfs->ns_next_gen_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
@@ -754,9 +752,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 	nilfs->ns_blocksize = blocksize;
 
-	get_random_bytes(&nilfs->ns_next_generation,
-			 sizeof(nilfs->ns_next_generation));
-
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
--- a/fs/nilfs2/the_nilfs.h~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/the_nilfs.h
@@ -71,8 +71,6 @@ enum {
  * @ns_dirty_files: list of dirty files
  * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
- * @ns_next_generation: next generation number for inodes
- * @ns_next_gen_lock: lock protecting @ns_next_generation
  * @ns_mount_opt: mount options
  * @ns_resuid: uid for reserved blocks
  * @ns_resgid: gid for reserved blocks
@@ -161,10 +159,6 @@ struct the_nilfs {
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
-	/* Inode allocator */
-	u32			ns_next_generation;
-	spinlock_t		ns_next_gen_lock;
-
 	/* Mount options */
 	unsigned long		ns_mount_opt;
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


