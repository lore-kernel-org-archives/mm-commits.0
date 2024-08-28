Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0744153A7
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803800; cv=none; b=gexYFjzjG9Lcb4X3/2hbKcnCUCj+u3MvYEICE6Digp/YL7wa3EQGqdmR8zo0WP4sSbT8VBahTgtQFMAae70WZvXpDoP6JYhlfy+TIFie2rxUQZC92n+CMn7RHcyjSTpx4F+j3dv3/zb6dumDkzhoY2rnYJ0KNL+MoSdSjYCX5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803800; c=relaxed/simple;
	bh=UzLer3JlUMCbIVzkZQlOUKRLiQSUo0v4ke5G60TWbQs=;
	h=Date:To:From:Subject:Message-Id; b=PZQgR2HDMVJUs17n4uyglH4fsVaiXJ5d0rEDXml+8sOw3YutvvyyWzEsz4L9ITN24PPblYPrswDgofkVKcoBb+tz3WW8u/2tFjZHtcBXclrVA5/cujyrePjexjAw2qUDGu0kiHhHaiKd4iM3c7FrfS7CLBsC9D7pTT9B99LBiL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ol/ajvJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ol/ajvJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728F1C4AF48;
	Wed, 28 Aug 2024 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803799;
	bh=UzLer3JlUMCbIVzkZQlOUKRLiQSUo0v4ke5G60TWbQs=;
	h=Date:To:From:Subject:From;
	b=Ol/ajvJ2OBAkfK5JGywxwq13iq3wa3UoWA63TuR2wDhzr3UgCHqv7GsoUtAvGjxs7
	 yI3Y29a/oql7Gv3YNR7WPOgatTDadmgboQVMH+ADjnpBpQP0IrUwJ7AJQfgBPXOuAN
	 Swj0hGchptZgK8Pq1HrKqKQ5QTNNRAI0k73DCVTo=
Date: Tue, 27 Aug 2024 17:09:58 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-separate-inode-type-information-from-i_state-field.patch added to mm-nonmm-unstable branch
Message-Id: <20240828000959.728F1C4AF48@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: separate inode type information from i_state field
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-separate-inode-type-information-from-i_state-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-separate-inode-type-information-from-i_state-field.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: separate inode type information from i_state field
Date: Tue, 27 Aug 2024 02:41:11 +0900

In nilfs_iget_locked() and nilfs_ilookup(), which are used to find or
obtain nilfs2 inodes, the nilfs_iget_args structure used to identify
inodes has type information divided into multiple booleans, making type
determination complicated.

Simplify inode type determination by consolidating inode type information
into an unsigned integer represented by a comibination of flags and by
separating the type identification information for on-memory inodes from
the i_state member in the nilfs_inode_info structure.

Link: https://lkml.kernel.org/r/20240826174116.5008-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c   |   56 ++++++++++--------------------------------
 fs/nilfs2/nilfs.h   |   15 +++++++++--
 fs/nilfs2/segment.c |    2 -
 fs/nilfs2/super.c   |    1 
 4 files changed, 28 insertions(+), 46 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-separate-inode-type-information-from-i_state-field
+++ a/fs/nilfs2/inode.c
@@ -28,17 +28,13 @@
  * @ino: inode number
  * @cno: checkpoint number
  * @root: pointer on NILFS root object (mounted checkpoint)
- * @for_gc: inode for GC flag
- * @for_btnc: inode for B-tree node cache flag
- * @for_shadow: inode for shadowed page cache flag
+ * @type: inode type
  */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
 	struct nilfs_root *root;
-	bool for_gc;
-	bool for_btnc;
-	bool for_shadow;
+	unsigned int type;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -315,8 +311,7 @@ static int nilfs_insert_inode_locked(str
 				     unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -343,6 +338,7 @@ struct inode *nilfs_new_inode(struct ino
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
 	ii->i_state = BIT(NILFS_I_NEW);
+	ii->i_type = NILFS_I_TYPE_NORMAL;
 	ii->i_root = root;
 
 	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
@@ -546,23 +542,10 @@ static int nilfs_iget_test(struct inode
 		return 0;
 
 	ii = NILFS_I(inode);
-	if (test_bit(NILFS_I_BTNC, &ii->i_state)) {
-		if (!args->for_btnc)
-			return 0;
-	} else if (args->for_btnc) {
+	if (ii->i_type != args->type)
 		return 0;
-	}
-	if (test_bit(NILFS_I_SHADOW, &ii->i_state)) {
-		if (!args->for_shadow)
-			return 0;
-	} else if (args->for_shadow) {
-		return 0;
-	}
 
-	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
-		return !args->for_gc;
-
-	return args->for_gc && args->cno == ii->i_cno;
+	return !(args->type & NILFS_I_TYPE_GC) || args->cno == ii->i_cno;
 }
 
 static int nilfs_iget_set(struct inode *inode, void *opaque)
@@ -572,15 +555,9 @@ static int nilfs_iget_set(struct inode *
 	inode->i_ino = args->ino;
 	NILFS_I(inode)->i_cno = args->cno;
 	NILFS_I(inode)->i_root = args->root;
+	NILFS_I(inode)->i_type = args->type;
 	if (args->root && args->ino == NILFS_ROOT_INO)
 		nilfs_get_root(args->root);
-
-	if (args->for_gc)
-		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
-	if (args->for_btnc)
-		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
-	if (args->for_shadow)
-		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -588,8 +565,7 @@ struct inode *nilfs_ilookup(struct super
 			    unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -599,8 +575,7 @@ struct inode *nilfs_iget_locked(struct s
 				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -631,8 +606,7 @@ struct inode *nilfs_iget_for_gc(struct s
 				__u64 cno)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = NULL, .cno = cno, .type = NILFS_I_TYPE_GC
 	};
 	struct inode *inode;
 	int err;
@@ -677,9 +651,7 @@ int nilfs_attach_btree_node_cache(struct
 	args.ino = inode->i_ino;
 	args.root = ii->i_root;
 	args.cno = ii->i_cno;
-	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
-	args.for_btnc = true;
-	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
+	args.type = ii->i_type | NILFS_I_TYPE_BTNC;
 
 	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
 				  nilfs_iget_set, &args);
@@ -733,8 +705,8 @@ void nilfs_detach_btree_node_cache(struc
 struct inode *nilfs_iget_for_shadow(struct inode *inode)
 {
 	struct nilfs_iget_args args = {
-		.ino = inode->i_ino, .root = NULL, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = true
+		.ino = inode->i_ino, .root = NULL, .cno = 0,
+		.type = NILFS_I_TYPE_SHADOW
 	};
 	struct inode *s_inode;
 	int err;
@@ -900,7 +872,7 @@ static void nilfs_clear_inode(struct ino
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
-	if (!test_bit(NILFS_I_BTNC, &ii->i_state))
+	if (!(ii->i_type & NILFS_I_TYPE_BTNC))
 		nilfs_detach_btree_node_cache(inode);
 
 	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
--- a/fs/nilfs2/nilfs.h~nilfs2-separate-inode-type-information-from-i_state-field
+++ a/fs/nilfs2/nilfs.h
@@ -22,6 +22,7 @@
 /**
  * struct nilfs_inode_info - nilfs inode data in memory
  * @i_flags: inode flags
+ * @i_type: inode type (combination of flags that inidicate usage)
  * @i_state: dynamic state flags
  * @i_bmap: pointer on i_bmap_data
  * @i_bmap_data: raw block mapping
@@ -37,6 +38,7 @@
  */
 struct nilfs_inode_info {
 	__u32 i_flags;
+	unsigned int i_type;
 	unsigned long  i_state;		/* Dynamic state flags */
 	struct nilfs_bmap *i_bmap;
 	struct nilfs_bmap i_bmap_data;
@@ -90,9 +92,16 @@ enum {
 	NILFS_I_UPDATED,		/* The file has been written back */
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
-	NILFS_I_GCINODE,		/* inode for GC, on memory only */
-	NILFS_I_BTNC,			/* inode for btree node cache */
-	NILFS_I_SHADOW,			/* inode for shadowed page cache */
+};
+
+/*
+ * Flags to identify the usage of on-memory inodes (i_type)
+ */
+enum {
+	NILFS_I_TYPE_NORMAL =	0,
+	NILFS_I_TYPE_GC =	0x0001,	/* For data caching during GC */
+	NILFS_I_TYPE_BTNC =	0x0002,	/* For btree node cache */
+	NILFS_I_TYPE_SHADOW =	0x0004,	/* For shadowed page cache */
 };
 
 /*
--- a/fs/nilfs2/segment.c~nilfs2-separate-inode-type-information-from-i_state-field
+++ a/fs/nilfs2/segment.c
@@ -519,7 +519,7 @@ static void nilfs_segctor_end_finfo(stru
 
 	ii = NILFS_I(inode);
 
-	if (test_bit(NILFS_I_GCINODE, &ii->i_state))
+	if (ii->i_type & NILFS_I_TYPE_GC)
 		cno = ii->i_cno;
 	else if (NILFS_ROOT_METADATA_FILE(inode->i_ino))
 		cno = 0;
--- a/fs/nilfs2/super.c~nilfs2-separate-inode-type-information-from-i_state-field
+++ a/fs/nilfs2/super.c
@@ -160,6 +160,7 @@ struct inode *nilfs_alloc_inode(struct s
 		return NULL;
 	ii->i_bh = NULL;
 	ii->i_state = 0;
+	ii->i_type = 0;
 	ii->i_cno = 0;
 	ii->i_assoc_inode = NULL;
 	ii->i_bmap = &ii->i_bmap_data;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

