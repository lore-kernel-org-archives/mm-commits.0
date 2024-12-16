Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706631C3F0E
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327690; cv=none; b=OhzT9vPDokEmUM/pCDPn1Sd167zSJng8ujIB7tpqAWcGZp8kvkC2YZ8SXc8PCYoMZlG2sHfu2BR/c7lab6DOCrZ3+8beGLCIsbzw1N+XLK9eqgWe0tHlIDmLCo4CQWz7cRg5yNGS9LazF03LLRBrPktxKECORjGAm8IYgi46flQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327690; c=relaxed/simple;
	bh=NKbXIuPxYanYi5fxaFjrELpnnQs3s4PZqijzEA2UPbA=;
	h=Date:To:From:Subject:Message-Id; b=bmq39+8Z+QOLaAe5BlVob7KKMlzHEH3eey9C8eUsHkIHq46WNVsYAApm0E3zgAhwuOvXYI87d2hsgJ6lV/ypvKzVnXjAwpfdxzs4ki+keBeTn144U3fLVFQwQIy+oSUiHAFK/SBOyLqA3XtbPaOvWSCW1iY8R1zU8WNqgpH/RU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=amVsLqk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="amVsLqk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45618C4CED0;
	Mon, 16 Dec 2024 05:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327690;
	bh=NKbXIuPxYanYi5fxaFjrELpnnQs3s4PZqijzEA2UPbA=;
	h=Date:To:From:Subject:From;
	b=amVsLqk1VRYnWiFL/Pzc1rsxLXWX6KLWsuyIwAn9pcJHlgJI2iDdZzBOk7mxJOONT
	 /DvruJzviZ9WPG+EnoYYDfI9dkc1x87te4F7uEGDo3fbSWdR0pdhQl8fWwIAHlWVBF
	 kgOnBZUtpGb2TLF/6ZPa2xizHTwBLyRp6hEzGmPs=
Date: Sun, 15 Dec 2024 21:41:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054130.45618C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: support large folios in ocfs2_zero_cluster_folios()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch

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
Subject: ocfs2: support large folios in ocfs2_zero_cluster_folios()
Date: Thu, 5 Dec 2024 17:16:50 +0000

Remove assumptions that a folio is one page in size.

Link: https://lkml.kernel.org/r/20241205171653.3179945-23-willy@infradead.org
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

 fs/ocfs2/alloc.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios
+++ a/fs/ocfs2/alloc.c
@@ -6851,7 +6851,6 @@ static void ocfs2_zero_cluster_folios(st
 		u64 phys, handle_t *handle)
 {
 	int i;
-	unsigned int from, to = PAGE_SIZE;
 	struct super_block *sb = inode->i_sb;
 
 	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
@@ -6859,21 +6858,18 @@ static void ocfs2_zero_cluster_folios(st
 	if (numfolios == 0)
 		goto out;
 
-	to = PAGE_SIZE;
 	for (i = 0; i < numfolios; i++) {
 		struct folio *folio = folios[i];
+		size_t to = folio_size(folio);
+		size_t from = offset_in_folio(folio, start);
 
-		from = start & (PAGE_SIZE - 1);
-		if ((end >> PAGE_SHIFT) == folio->index)
-			to = end & (PAGE_SIZE - 1);
-
-		BUG_ON(from > PAGE_SIZE);
-		BUG_ON(to > PAGE_SIZE);
+		if (to > end - folio_pos(folio))
+			to = end - folio_pos(folio);
 
 		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
 				&phys);
 
-		start = (folio->index + 1) << PAGE_SHIFT;
+		start = folio_next_index(folio) << PAGE_SHIFT;
 	}
 out:
 	if (folios)
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

