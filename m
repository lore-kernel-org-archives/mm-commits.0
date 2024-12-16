Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03CB10F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327671; cv=none; b=YkLTLBGwuBUFh1gWvvJY8nGAAB/AMuI/2jkv72zkL90eFgDc+IuBVtCfpQjwBKrK3YRKwP9uJtWuP79x85efgT8vgkIDJqP5DtAiS/OsLHTPwnMRGG1iGaXucOlKtt616F8xxiMk340Dp7GSnQIDwvv906T1Az/2lETtdOaqJuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327671; c=relaxed/simple;
	bh=zEYBjNkxtudRvTCkhNQT4wopAkm4HWecHo2qL8X3RRA=;
	h=Date:To:From:Subject:Message-Id; b=tTaEaf435ibTiuspmybx48OMP3jPcXwEWFqv+fkuLFlA1+ZrRy1jNwdxh12Zd2rmeDTYBnvozV7+78zX3sRzpazdnq/ltxF7Fq5WPau/rS92ZnsnoeIRwM+OVDyUDlkJbjcl9gRH8gIrf9/jt5lNIlD/154a0b7QmKVcGPXIpEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DeN00sZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DeN00sZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE7C4CED0;
	Mon, 16 Dec 2024 05:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327671;
	bh=zEYBjNkxtudRvTCkhNQT4wopAkm4HWecHo2qL8X3RRA=;
	h=Date:To:From:Subject:From;
	b=DeN00sZDIO/592RP5nPcOTwG+546kCzbMwbFVDpnG8Jvo0ZmiISWMq33JDR2iZOXM
	 ipXBJsCJPhRvVKvVPjGXbY0bbOm/d4DzAtRkCpeZ5ILsZYr0lEaX0WzpeGzDwPVn74
	 ePSvdgUJ5rNarnH7qOWWX6H3l9PXryeqfHqcQb4I=
Date: Sun, 15 Dec 2024 21:41:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054111.6CDE7C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch

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

