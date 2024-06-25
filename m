Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5721459E6
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293223; cv=none; b=kRi4+HonP3DjPs7jlwo5oR8BgabGePLdxZSlhyDIcgzGkZcHTXW6/Pu+sPCu1pM2rfRMRxLVB0V2W5ZOwakivZo2H3WX4ynnoMivp7jkqS6Pbrw04yeKQSCOfztqCOxerpS1HQXtvX6tYmR4/oNFRC5Ny3N3f7h23hqblDBA2hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293223; c=relaxed/simple;
	bh=MF64HGxixdzty4thaKKLddo7yAvowwrdcLNsqQ16d3c=;
	h=Date:To:From:Subject:Message-Id; b=Kwt/HqBGAs8LcrGKxhWXD5FAqXY8VgQNeOwFMFNT9q8UmjZ7XHmndeJ1aBoHv7LawbEpYulRxIsiKglmYVVqPjoxwCicC1Nmn1QAMjc+vN4V0WColLkFQMbcuOohoBHtSYIjvzzin3H4zCgeSGDD9q4UWk7FDd8obZjMS/0gPxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXG+LjYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXG+LjYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4AEC32789;
	Tue, 25 Jun 2024 05:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293223;
	bh=MF64HGxixdzty4thaKKLddo7yAvowwrdcLNsqQ16d3c=;
	h=Date:To:From:Subject:From;
	b=CXG+LjYU/VXovAROMXIfkMg/a6yoW/NN8VOf+nquah4UcYQ2yeiKM1cmdkhcrKoG2
	 zFsUjMMA1WBw+Z4k4R0J0buO+//ri9zkMEolmBfPtsZ5mjLyVyCujt00Sik9tsi9f3
	 qJitIR0ip3P52ReFcrEtinDiCUEKYtMxZbGaEwew=
Date: Mon, 24 Jun 2024 22:27:02 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-constify-struct-ocfs2_lock_res_ops.patch removed from -mm tree
Message-Id: <20240625052703.0E4AEC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: constify struct ocfs2_lock_res_ops
has been removed from the -mm tree.  Its filename was
     ocfs2-constify-struct-ocfs2_lock_res_ops.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: constify struct ocfs2_lock_res_ops
Date: Fri, 14 Jun 2024 18:25:07 +0200

"struct ocfs2_lock_res_ops" are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

In order to do it, "struct ocfs2_lock_res" also needs to be adjusted to
this new const qualifier.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  83038	   2632	    400	  86070	  15036	fs/ocfs2/dlmglue.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  83806	   1992	    272	  86070	  15036	fs/ocfs2/dlmglue.o

Link: https://lkml.kernel.org/r/43d3e2ae3a97d3cbe93d6ba6ce48ae5ec04d7526.1718382288.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   28 ++++++++++++++--------------
 fs/ocfs2/ocfs2.h   |    2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-constify-struct-ocfs2_lock_res_ops
+++ a/fs/ocfs2/dlmglue.c
@@ -221,12 +221,12 @@ struct ocfs2_lock_res_ops {
  */
 #define LOCK_TYPE_USES_LVB		0x2
 
-static struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
@@ -234,50 +234,50 @@ static struct ocfs2_lock_res_ops ocfs2_i
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_super_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_super_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_rename_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_rename_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.get_osb	= ocfs2_get_file_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
 	.set_lvb	= ocfs2_set_qinfo_lvb,
 	.get_osb	= ocfs2_get_qinfo_osb,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH | LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
 	.check_downconvert = ocfs2_check_refcount_downconvert,
 	.downconvert_worker = ocfs2_refcount_convert_worker,
 	.flags		= 0,
@@ -510,7 +510,7 @@ static inline void ocfs2_init_start_time
 static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *res,
 				       enum ocfs2_lock_type type,
-				       struct ocfs2_lock_res_ops *ops,
+				       const struct ocfs2_lock_res_ops *ops,
 				       void *priv)
 {
 	res->l_type          = type;
@@ -553,7 +553,7 @@ void ocfs2_inode_lock_res_init(struct oc
 			       unsigned int generation,
 			       struct inode *inode)
 {
-	struct ocfs2_lock_res_ops *ops;
+	const struct ocfs2_lock_res_ops *ops;
 
 	switch(type) {
 		case OCFS2_LOCK_TYPE_RW:
--- a/fs/ocfs2/ocfs2.h~ocfs2-constify-struct-ocfs2_lock_res_ops
+++ a/fs/ocfs2/ocfs2.h
@@ -154,7 +154,7 @@ struct ocfs2_lock_stats {
 
 struct ocfs2_lock_res {
 	void                    *l_priv;
-	struct ocfs2_lock_res_ops *l_ops;
+	const struct ocfs2_lock_res_ops *l_ops;
 
 
 	struct list_head         l_blocked_list;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


