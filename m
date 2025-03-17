Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2188140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189512; cv=none; b=de5xLIPeef63KUJTs/1I1m7Nl7f+8jOJHYpyji71dIiGYCRUTA+grH0A63D4LZQvRx4OTOyGKmmO6bTXbD9DFAumiIrIhPrgwkUpjZxAy2TuOk5E+3wM1O40frLWx6Vd0RHzDrjtqFx6JYFFlmn3L8yAPuIRkkqPTTxukdRT4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189512; c=relaxed/simple;
	bh=u7VJsMsoz37+8K1g0ktyBmh3gz4sZ3fvMOIuEBWLznI=;
	h=Date:To:From:Subject:Message-Id; b=ZQuWZnd8zQFHR3d92hcy2T7wi9ED5hiUree+EKOWnvPx9s8RoYXeSFKYNy61Yk9V+6h9NWuqLjjZtL4eOnCVWP+e0UtvNO/wnTHTxFq/7imyRNS8i1v+G4WbE59mRfojsy0tx73gYGycpXiAU5Rc/5eD9VjfZGT4FQXnpjacYIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwbVY4Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwbVY4Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E95C4CEEC;
	Mon, 17 Mar 2025 05:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189512;
	bh=u7VJsMsoz37+8K1g0ktyBmh3gz4sZ3fvMOIuEBWLznI=;
	h=Date:To:From:Subject:From;
	b=MwbVY4Ql2r9jXtPod+julXR52SM04m07DAkZZJPDAH/w3kvmftk6x0ryHBT7yMNnh
	 1Epx9nIRpdVAeqIx9bOEjLtaWvhTb9iYK8FegpqEYfeubMr/IkpJu1WpP7zKhO/0Du
	 BwZJrA0Sx7aBPyyz2aA8E6MWsDxwLu1k0idodtkc=
Date: Sun, 16 Mar 2025 22:31:52 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch removed from -mm tree
Message-Id: <20250317053152.96E95C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use memcpy_to_folio() in ocfs2_symlink_get_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: use memcpy_to_folio() in ocfs2_symlink_get_block()
Date: Thu, 13 Feb 2025 21:45:30 +0000

Replace use of kmap_atomic() with the higher-level construct
memcpy_to_folio().  This removes a use of b_page and supports large folios
as well as being easier to understand.  It also removes the check for
kmap_atomic() failing (because it can't).

Link: https://lkml.kernel.org/r/20250213214533.2242224-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block
+++ a/fs/ocfs2/aops.c
@@ -46,7 +46,6 @@ static int ocfs2_symlink_get_block(struc
 	struct buffer_head *bh = NULL;
 	struct buffer_head *buffer_cache_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	void *kaddr;
 
 	trace_ocfs2_symlink_get_block(
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -91,17 +90,11 @@ static int ocfs2_symlink_get_block(struc
 		 * could've happened. Since we've got a reference on
 		 * the bh, even if it commits while we're doing the
 		 * copy, the data is still good. */
-		if (buffer_jbd(buffer_cache_bh)
-		    && ocfs2_inode_is_new(inode)) {
-			kaddr = kmap_atomic(bh_result->b_page);
-			if (!kaddr) {
-				mlog(ML_ERROR, "couldn't kmap!\n");
-				goto bail;
-			}
-			memcpy(kaddr + (bh_result->b_size * iblock),
-			       buffer_cache_bh->b_data,
-			       bh_result->b_size);
-			kunmap_atomic(kaddr);
+		if (buffer_jbd(buffer_cache_bh) && ocfs2_inode_is_new(inode)) {
+			memcpy_to_folio(bh_result->b_folio,
+					bh_result->b_size * iblock,
+					buffer_cache_bh->b_data,
+					bh_result->b_size);
 			set_buffer_uptodate(bh_result);
 		}
 		brelse(buffer_cache_bh);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

