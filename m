Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0257C9F
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244580; cv=none; b=JlCr+nIixykrrXVHdLn+GqvgrgJfC4+0a1Mzox2BzczxTenBNV5wJqRPqaPxUBQOsw8c0y47Zk2jTz7gnccprngRmS8fXERnZykVm81nxmZx8HO1ZBci3bOnTW9fmS16i6tHqTgaD4AzWIrSa/yiHPIYjmi0gB6hVc67p7J1ghA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244580; c=relaxed/simple;
	bh=pK0E/63Az47QmQjzGt4kvCpgyw+nWtW8rAru1CIvmZ8=;
	h=Date:To:From:Subject:Message-Id; b=FVZJjPewoDwy3MeX5FprgKPOYTXFwxtlb1WTrcwuYJhNsmaV6HtQPkoLZ9qA1q3Qo+t6B0F6iLlqgPvYHDAZjz/g6eO5fzGc7bCX1pu1D/skO4sw7zd4ArOsl74XuToaGFqM91/ij00SgM49VfxrtekdgTT75yesLpKmmpmlGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x5l5Ccp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x5l5Ccp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BF8C19424;
	Wed, 15 Apr 2026 09:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244580;
	bh=pK0E/63Az47QmQjzGt4kvCpgyw+nWtW8rAru1CIvmZ8=;
	h=Date:To:From:Subject:From;
	b=x5l5Ccp3Bq9xC+Pn7fRGEZpEDk3rPUeV9tr31lKGqBFRgt+4MubG8DtkiGbLfRek5
	 o84YauoFalvILZMz6qwZck1R8X+YvFvo5ruHuBW+gCHeeFo1736zr7h+Lq2tCnrId6
	 KXpv34gdDdSFqnkXCNQP9iuAWzCMG7uI0It8x9ig=
Date: Wed, 15 Apr 2026 02:16:16 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch removed from -mm tree
Message-Id: <20260415091619.79BF8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate dx_root extent list fields during block read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate dx_root extent list fields during block read
Date: Fri, 3 Apr 2026 17:08:00 +0800

Patch series "ocfs2: consolidate extent list validation into block read
callbacks".

ocfs2 validates extent list fields (l_count, l_next_free_rec) at various
points during extent tree traversal.  This is fragile because each caller
must remember to check for corrupted on-disk data before using it.

This series moves those checks into the block read validation callbacks
(ocfs2_validate_dx_root and ocfs2_validate_extent_block), so corrupted
fields are caught early at block read time.  Redundant post-read checks
are then removed.


This patch (of 4):

Move the extent list l_count validation from ocfs2_dx_dir_lookup_rec()
into ocfs2_validate_dx_root(), so that corrupted on-disk fields are caught
early at block read time rather than during directory lookups.

Additionally, add a l_next_free_rec <= l_count check to prevent
out-of-bounds access when iterating over extent records.

Both checks are skipped for inline dx roots (OCFS2_DX_FLAG_INLINE), which
use dr_entries instead of dr_list.

Link: https://lkml.kernel.org/r/20260403090803.3860971-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20260403090803.3860971-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-validate-dx_root-extent-list-fields-during-block-read
+++ a/fs/ocfs2/dir.c
@@ -593,7 +593,7 @@ static int ocfs2_validate_dx_root(struct
 		mlog(ML_ERROR,
 		     "Checksum failed for dir index root block %llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		return ret;
+		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
@@ -601,8 +601,32 @@ static int ocfs2_validate_dx_root(struct
 				  "Dir Index Root # %llu has bad signature %.*s\n",
 				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 				  7, dx_root->dr_signature);
+		goto bail;
 	}
 
+	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
+		struct ocfs2_extent_list *el = &dx_root->dr_list;
+
+		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_count %u (expected %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_count),
+					  ocfs2_extent_recs_per_dx_root(sb));
+			goto bail;
+		}
+
+		if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_next_free_rec %u (l_count %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_next_free_rec),
+					  le16_to_cpu(el->l_count));
+			goto bail;
+		}
+	}
+
+bail:
 	return ret;
 }
 
@@ -791,14 +815,6 @@ static int ocfs2_dx_dir_lookup_rec(struc
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec = NULL;
 
-	if (le16_to_cpu(el->l_count) !=
-	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has invalid extent list length %u\n",
-				  inode->i_ino, le16_to_cpu(el->l_count));
-		goto out;
-	}
-
 	if (el->l_tree_depth) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
 				      &eb_bh);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


