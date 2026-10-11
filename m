Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1676D407597;
	Sun, 11 Oct 2026 22:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757201; cv=none; b=m7+baRITtK1gxjn+PSJ/pT7MnvGtyzdBLYa0zLLtLO9YKGF4ikH+m++39dLA8tmEf11LC1FPQhOFk4MCL3n3zvcoteD7AM5m587HsyFxzBqWGOixxhHZPJTK6imSFyNE1WRAu5pBw+afEDOHGbjPpsONlFI1zPxje1q3opqMb1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757201; c=relaxed/simple;
	bh=1kLKdn1im0Gq3YtffIT2g1mMsTSeG82QyTF9sVI4hU4=;
	h=Date:To:From:Subject:Message-Id; b=dH8GTPTeXj1LYIT3zKg4LeWvuvAVSR2WenvyUIQWRBvyNdBWdW8vE2hOYpCCJNidzCIGJZ/jorb8p1cH8VHcFy7RkXsSChP0vBSAH5+zwHQluieRcGyu5aM5Q1Surger/sAaWYuouV7ch3ZmkAfCcs1z5GhDXskrm5wp7UQ9sHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NZgSaSlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZgSaSlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B021F0089B;
	Sun, 11 Oct 2026 22:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757199;
	bh=QAECPm9Lf6glJsVHND1w6DhatQEG0zfSXwqkqRvC260=;
	h=Date:To:From:Subject;
	b=NZgSaSlLo17Djz4BdCWvSJgRhssy5WtX+BLprT1EkNT0Rywigq9tFWaEKuX73t6h0
	 xmI8hJMIdRUFE/Em/4NiLhFhpUm6xrkOwlgVQwtlqWFS4TY4PsiosyEHM+f0pcAQlc
	 Wx1KPVE/vsRmiNZHqlGBWwXqPs1IjrNflkU/rEpY=
Date: Sun, 11 Oct 2026 15:19:59 -0700
To: mm-commits@vger.kernel.org,xmei5@asu.edu,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gkobakhi@asu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch removed from -mm tree
Message-Id: <20261011221959.88B021F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix array out of bound access in __ocfs2_find_path()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Giorgi Kobakhia <gkobakhi@asu.edu>
Subject: ocfs2: fix array out of bound access in __ocfs2_find_path()
Date: Tue, 22 Sep 2026 13:21:59 -0700

__ocfs2_find_path() walks down the extent tree and records path by calling
find_path_ins(), which appends entry to path->p_node[].  It only has 5
spots.

A corrupted ocfs2 image whose extent block is pointing to itself causes
__ocfs2_find_path() descent endlessly, writing past the end of
path->p_node[] array.

 UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:677:14
 index 5 is out of range for type 'ocfs2_path_item [5]'
 Call Trace:
  <TASK>
  find_path_ins (fs/ocfs2/alloc.c:677 fs/ocfs2/alloc.c:1914)
  __ocfs2_find_path.constprop.0 (fs/ocfs2/alloc.c:1882)
  ocfs2_commit_truncate (fs/ocfs2/alloc.c:1924 fs/ocfs2/alloc.c:7286)
  ocfs2_truncate_file (fs/ocfs2/file.c:515)
  ocfs2_setattr (fs/ocfs2/file.c:1224)
  notify_change (fs/attr.c:556)
  do_truncate (fs/open.c:68)
  do_ftruncate (fs/open.c:194 (discriminator 1))
  ksys_ftruncate (fs/open.c:206)
  __x64_sys_ftruncate (fs/open.c:211 fs/open.c:209 fs/open.c:209)

Commit a406aff8c051 ("ocfs2: validate l_tree_depth to avoid out-of-bounds
access") already restricts el->l_tree_depth to be less than
OCFS2_MAX_PATH_DEPTH, which is equal to 5.  However, does not handle the
infinite descent case.

Check if the el->l_tree_depth decreases on each descent.  Maximum descents
are restricted to 4 and the path->p_node[] array does not overflow.

Link: https://lore.kernel.org/20260922202159.2421642-1-gkobakhi@asu.edu
Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path
+++ a/fs/ocfs2/alloc.c
@@ -1844,6 +1844,7 @@ static int __ocfs2_find_path(struct ocfs
 	int i, ret = 0;
 	u32 range;
 	u64 blkno;
+	u32 prev_depth = OCFS2_MAX_PATH_DEPTH;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
@@ -1851,14 +1852,16 @@ static int __ocfs2_find_path(struct ocfs
 
 	el = root_el;
 	while (el->l_tree_depth) {
-		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= prev_depth)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    "Owner %llu has invalid tree depth %u in extent list (max %u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    le16_to_cpu(el->l_tree_depth));
+				    le16_to_cpu(el->l_tree_depth), prev_depth - 1);
 			ret = -EROFS;
 			goto out;
 		}
+		prev_depth = le16_to_cpu(el->l_tree_depth);
+
 		if (!el->l_next_free_rec || !el->l_count) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n"
_

Patches currently in -mm which might be from gkobakhi@asu.edu are


