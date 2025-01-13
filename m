Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4365925761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742219; cv=none; b=uTUrmkDaejsbMjZUFnLjX2RvazR4wCEhAPgrIfMY5fZs0Gx7ezfM7Hwnz24U/CSzb9igaYm2AuaNGW4+nxcB3pj/L+by9kP+KD97b5KA9Ye9FT1N1SFT4OWM6031HcsA7/yT3CVYOGgIuOsmUhxsPwQ5/PrRc1yvlJjelaDDEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742219; c=relaxed/simple;
	bh=2Tzv0uouPPJHonHW4PvK/06rLaF89McfBRJCark/rL0=;
	h=Date:To:From:Subject:Message-Id; b=Ffma1m7ghx/+zvkCQ9xLE9Yx4d8lMJa3exHJWMe16HOC2Yl9c8EKgcANWcatK8cC/eLmcjzKVQOdtBki9IFBv1pSgvo2yAeBI3YJXt7ouzKA8RvYAKbXsHKoD3iBGMpM5r+71O7gYIzixuiLRzK0V1s0EJkdzyTs+RTEPtvIWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=is3eu/Wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="is3eu/Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0BC4CED6;
	Mon, 13 Jan 2025 04:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742219;
	bh=2Tzv0uouPPJHonHW4PvK/06rLaF89McfBRJCark/rL0=;
	h=Date:To:From:Subject:From;
	b=is3eu/Wb/DYmOjKR+oONqf3C5jKCLV1KYIL/bdZLNdRl7n1cUkWdiXULT2+1TGq80
	 buWToFwaT/6QkLpyl1bP+kSGpNjID7KdedAPQcNXxNVVqckAxKQwuk5SlqWspDQhWI
	 iyfsIPGk4RuvFWflS/BNOFuRDtsV8QsSNRS+JjOw=
Date: Sun, 12 Jan 2025 20:23:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch removed from -mm tree
Message-Id: <20250113042339.17E0BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
Date: Thu, 5 Dec 2024 17:16:42 +0000

All callers now have a folio, so pass it in instead of converting
folio->page->folio.

Link: https://lkml.kernel.org/r/20241205171653.3179945-15-willy@infradead.org
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

 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/aops.c  |   18 ++++++++----------
 fs/ocfs2/aops.h  |    2 +-
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks
+++ a/fs/ocfs2/alloc.c
@@ -6817,7 +6817,7 @@ void ocfs2_map_and_dirty_page(struct ino
 	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
 
-	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
+	ret = ocfs2_map_folio_blocks(folio, phys, inode, from, to, 0);
 	if (ret)
 		mlog_errno(ret);
 
--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks
+++ a/fs/ocfs2/aops.c
@@ -560,7 +560,7 @@ static void ocfs2_clear_page_regions(str
 /*
  * Nonsparse file systems fully allocate before we get to the write
  * code. This prevents ocfs2_write() from tagging the write as an
- * allocating one, which means ocfs2_map_page_blocks() might try to
+ * allocating one, which means ocfs2_map_folio_blocks() might try to
  * read-in the blocks at the tail of our file. Avoid reading them by
  * testing i_size against each block offset.
  */
@@ -585,11 +585,10 @@ static int ocfs2_should_read_blk(struct
  *
  * This will also skip zeroing, which is handled externally.
  */
-int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
+int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new)
 {
-	struct folio *folio = page_folio(page);
 	int ret = 0;
 	struct buffer_head *head, *bh, *wait[2], **wait_bh = wait;
 	unsigned int block_end, block_start;
@@ -971,12 +970,11 @@ static int ocfs2_prepare_folio_for_write
 		map_to = map_from + user_len;
 
 		if (new)
-			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-						    cluster_start, cluster_end,
-						    new);
+			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+					cluster_start, cluster_end, new);
 		else
-			ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-						    map_from, map_to, new);
+			ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+					map_from, map_to, new);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -999,8 +997,8 @@ static int ocfs2_prepare_folio_for_write
 		map_from = cluster_start;
 		map_to = cluster_end;
 
-		ret = ocfs2_map_page_blocks(page, p_blkno, inode,
-					    cluster_start, cluster_end, new);
+		ret = ocfs2_map_folio_blocks(folio, p_blkno, inode,
+				cluster_start, cluster_end, new);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
--- a/fs/ocfs2/aops.h~ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks
+++ a/fs/ocfs2/aops.h
@@ -13,7 +13,7 @@ handle_t *ocfs2_start_walk_page_trans(st
 							 unsigned from,
 							 unsigned to);
 
-int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
+int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


