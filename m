Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA42DEA9B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236465; cv=none; b=LifMQo4i3b/qNGFbYF5Eub+el9NJZ2WgbE5X4jIWPNP3z7kuc/7OoeT0cc4meGqnaizZugaGgTExCIPVyMxpLQYruXJ7Vwuq/6KhvZmlBqQY9ra4dSBIW4JQfoBzc1n9S9vQ1WntUB97x0giQhdAGb6GFs//bPPC/xtLsBmMlOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236465; c=relaxed/simple;
	bh=L56/5bYz47TCE4qBRh62pF7FZy2y3Onzayg4bthssII=;
	h=Date:To:From:Subject:Message-Id; b=bueUDgeqVdvoiJV/Y4NqJwRdfvarFlPLDVXp8tD5HEU8a2K+wMF68SMwLIc4DiHwj+bKTiJxcuY6qSDLO9MoafgF97S525Ab8Zghl83AiYSbJllOIUu9UfzBiHqABVcdzcmjFvaatB3UZsm2vNzsN3wTR/EfTvHz7W5MU8eSMOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wGhNT/vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wGhNT/vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF47C4CEF7;
	Fri,  3 Apr 2026 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236464;
	bh=L56/5bYz47TCE4qBRh62pF7FZy2y3Onzayg4bthssII=;
	h=Date:To:From:Subject:From;
	b=wGhNT/vjXRn6AMxhsFV3BH08X9xML7Xes9BXyiXZmohaL1diATEl/BNGh29FD5wtr
	 iKJsAkVsxegxmeggBmzMKS5XN/ZK1L7UfeyUCuqyMjL206/WfpUgAt9EfCgDfTVk6j
	 YHM/0eRjktAIMIhzlSeglMO4vYcFjxIzMP6BEo3o=
Date: Fri, 03 Apr 2026 10:14:23 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171424.6CF47C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate dx_root extent list fields during block read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
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

ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch
ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch
ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch
ocfs2-validate-extent-block-list-fields-during-block-read.patch
ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

