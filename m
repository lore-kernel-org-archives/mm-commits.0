Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510525761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742222; cv=none; b=uN7CE3mrHB/Zj4yDKl8kPxGUdMnjIuMjzuYyCLAx3gGGI9bxn6hm4RymIrQuPoT12l+zO0tXw6Xm/fQdPZNyheffxii5M315CZdFtsSvUAe3ixCi/rO9zHS8Fy522lKkm8UN9rSyPF+uIp7htt57/z5KZcApo9yjcQaLMvEdxnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742222; c=relaxed/simple;
	bh=FZENhSVp2Fc1rEasd1IkCM61t058wW2BieOVzszOh9I=;
	h=Date:To:From:Subject:Message-Id; b=l1vU/NgcCYoNhl7oapgBXW1meYPkpYh75VAK8lC1ODsBbevzNs5jNSnI4/0nHU9zgp3+sXKUMyf89YilrRQeQZzmvDlNKBcytA0uHOC/PBP/w2AtnDuDMNnfE10r/ypFzSIVB5dnYbAgCYBAsuDES/HpqXfJ0RIokzROD2Q8p0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NNwlR8D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NNwlR8D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE1DC4CED6;
	Mon, 13 Jan 2025 04:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742222;
	bh=FZENhSVp2Fc1rEasd1IkCM61t058wW2BieOVzszOh9I=;
	h=Date:To:From:Subject:From;
	b=NNwlR8D19DewQk2TaLU3HGWIz8mZITAye97ey+gwwIy39DZywa/u9JZrkY/p2dH0S
	 juTkULQhh+0QawL1ArfbfVHNDpfNpTyaSpWCcqHVfcy4iY8v8LPfCvAVb1nsz9Pmo2
	 u9ToTah1h+HGCOLaZV3P0d1tEn3dmOBQ4KBdK728=
Date: Sun, 12 Jan 2025 20:23:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20250113042342.6CE1DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_duplicate_clusters_by_page() to use a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


