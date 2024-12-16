Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FCC10F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327679; cv=none; b=Tblb9VyKEmnMZQgQ1v8VpBPzWDVy1iWBvqN/0JM+9zsXxXei9nX5v8dGr1j/3iJ7Ih9KnaVlxQwYMWwRe7Nb20Z/PnFGf7K7r2HJWK71GzS0N4kt6ZP593cBKNX4e2RTUWU8vpK7k1cCXlL5w7LYF9/R/zFenupXZEPPzMBo2tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327679; c=relaxed/simple;
	bh=Zio5zIOMmY53Loyr5EnBm/oWv3rRqDBXpXXmcD82UMg=;
	h=Date:To:From:Subject:Message-Id; b=Gl9Z8in0Qu8JjmvyrmZtrVRTnjb35tZ3VOElAi/fGlgRZnQyfpWsX/nvTXPILPtn4QlSEVgisQs433ar96pbdBcDTPCHroEJDs1+GzWlORGsMBtQ9VzTbwOs6Ff2Bsz2u8E0txl1v+N9eDmLsScRKFnh9rpcFPDcQCjlB452ir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ruHKy8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ruHKy8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38964C4CED0;
	Mon, 16 Dec 2024 05:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327679;
	bh=Zio5zIOMmY53Loyr5EnBm/oWv3rRqDBXpXXmcD82UMg=;
	h=Date:To:From:Subject:From;
	b=1ruHKy8a1SsJxzouqadYWLcgvswGkA9+g4LdH6XAsEM3/ji+X61lEusku+bTfgHbC
	 XgCIMLTuj0MPcbhfbNU993qO4aDBZOB8YVLuk7c1jifn/ZLweD4jZQElvV4OU5mV+n
	 dzXRr43WqTg/44VWXEfVUaQY1u8Fp8Xlv8nu5hOw=
Date: Sun, 15 Dec 2024 21:41:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054119.38964C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_duplicate_clusters_by_page() to use a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch

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
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert ocfs2_duplicate_clusters_by_page() to use a folio
Date: Thu, 5 Dec 2024 17:16:45 +0000

Retrieve folios from the page cache, not pages, and use a folio throughout
this function.  Removes seven calls to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-18-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio
+++ a/fs/ocfs2/refcounttree.c
@@ -2902,7 +2902,6 @@ int ocfs2_duplicate_clusters_by_page(han
 	int ret = 0, partial;
 	struct super_block *sb = inode->i_sb;
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
-	struct page *page;
 	pgoff_t page_index;
 	unsigned int from, to;
 	loff_t offset, end, map_end;
@@ -2921,6 +2920,7 @@ int ocfs2_duplicate_clusters_by_page(han
 		end = i_size_read(inode);
 
 	while (offset < end) {
+		struct folio *folio;
 		page_index = offset >> PAGE_SHIFT;
 		map_end = ((loff_t)page_index + 1) << PAGE_SHIFT;
 		if (map_end > end)
@@ -2933,9 +2933,10 @@ int ocfs2_duplicate_clusters_by_page(han
 			to = map_end & (PAGE_SIZE - 1);
 
 retry:
-		page = find_or_create_page(mapping, page_index, GFP_NOFS);
-		if (!page) {
-			ret = -ENOMEM;
+		folio = __filemap_get_folio(mapping, page_index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio);
 			mlog_errno(ret);
 			break;
 		}
@@ -2945,9 +2946,9 @@ retry:
 		 * page, so write it back.
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
-			if (PageDirty(page)) {
-				unlock_page(page);
-				put_page(page);
+			if (folio_test_dirty(folio)) {
+				folio_unlock(folio);
+				folio_put(folio);
 
 				ret = filemap_write_and_wait_range(mapping,
 						offset, map_end - 1);
@@ -2955,9 +2956,7 @@ retry:
 			}
 		}
 
-		if (!PageUptodate(page)) {
-			struct folio *folio = page_folio(page);
-
+		if (!folio_test_uptodate(folio)) {
 			ret = block_read_full_folio(folio, ocfs2_get_block);
 			if (ret) {
 				mlog_errno(ret);
@@ -2966,8 +2965,8 @@ retry:
 			folio_lock(folio);
 		}
 
-		if (page_has_buffers(page)) {
-			ret = walk_page_buffers(handle, page_buffers(page),
+		if (folio_buffers(folio)) {
+			ret = walk_page_buffers(handle, folio_buffers(folio),
 						from, to, &partial,
 						ocfs2_clear_cow_buffer);
 			if (ret) {
@@ -2978,12 +2977,11 @@ retry:
 
 		ocfs2_map_and_dirty_page(inode,
 					 handle, from, to,
-					 page, 0, &new_block);
-		mark_page_accessed(page);
+					 &folio->page, 0, &new_block);
+		folio_mark_accessed(folio);
 unlock:
-		unlock_page(page);
-		put_page(page);
-		page = NULL;
+		folio_unlock(folio);
+		folio_put(folio);
 		offset = map_end;
 		if (ret)
 			break;
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

ocfs2-convert-w_target_page-to-w_target_folio.patch
ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch
ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch
ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch
ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch
ocfs2-convert-w_pages-to-w_folios.patch
ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch
ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch
ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch
ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch
ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch
ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch
ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch
ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch
ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

