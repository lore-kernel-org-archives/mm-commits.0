Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDEC374E5A
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632141; cv=none; b=EGh7V99UoJ/h2vrNeZUUUz2kV7Hzft9wSmdF3YgrrENwSBuLacYu37wu55aXmHdYSx6IG5pmQOYIB9dyZ/8pU0SdCk4YJDeMvSrHKc91+sUlUozkPMk7CtbdRMELJcyuK1q24Mopsz1+YSyMdLkFDfotJLvhCqcvy3sVsOOVNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632141; c=relaxed/simple;
	bh=myGtpfOW2adoMeGyIq3CaUw8XnL/PGy0TOL9WpEiCik=;
	h=Date:To:From:Subject:Message-Id; b=tyJa5Emq+6AYCk4/YAC/wXVXiSBQ/Z/njshBP4dXZfT5Z0pN6ViS8iAdFgxkIR0MMUd2hQ1bIV2V163/DT+7dLMM/CIcTwCXlhEe3h3P7t/xfjlY+GHGqVhDLnDApEV+EevdaDeltdqvp5lI9Yl9lh9Y3P6YBurDn4wstM/GtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=045epUiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="045epUiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB5B1F000FF;
	Mon, 28 Sep 2026 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632139;
	bh=VM5Z7LrZ0OChlS1sswFYEStGCcXNYTYh1yGh4twq0Zs=;
	h=Date:To:From:Subject;
	b=045epUiYGZ1PlsCiy+db7re/zIn5TTINjniAk22LcNuRZEuY/qRpawU9QBabGkIF5
	 OEg1H2FRgo9RHDEwCFs04lYB7IbDSudvtUAeXjkBB1Atg/SFLIliVDkEvrp6dpMrqO
	 elvQjJ5JLn4ZQVMjzESxO+b3L2NlJa9R+0ONBQ8E=
Date: Mon, 28 Sep 2026 14:48:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yukuai@fnnas.com,yizhang089@gmail.com,yangerkun@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joannelkoong@gmail.com,jack@suse.cz,hughd@google.com,djwong@kernel.org,david@kernel.org,chengzhihao1@huawei.com,bfoster@redhat.com,baolin.wang@linux.alibaba.com,yi.zhang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch added to mm-new branch
Message-Id: <20260928214859.9BB5B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: clarify return value of truncate_inode_partial_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Zhang Yi <yi.zhang@huawei.com>
Subject: mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Mon, 28 Sep 2026 20:08:33 +0800

With the earlier rework the callers no longer rely on the return value of
truncate_inode_partial_folio() to decide whether to adjust the truncation
range.  The pstart/pend out-parameters carry that information instead. 
The callers now only use the return value as a flag indicating whether the
loop should be reset to pick up newly split sub-folios on the shmem path.

Return true if at least one split succeeded, and false otherwise.  This
clarifies the existing confusing return value semantics.

Link: https://lore.kernel.org/20260928120833.3440834-5-yi.zhang@huaweicloud.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: <yizhang089@gmail.com>
Cc: Yang Erkun <yangerkun@huawei.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <yukuai@fnnas.com>
---

 mm/truncate.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/truncate.c~mm-truncate-clarify-return-value-of-truncate_inode_partial_folio
+++ a/mm/truncate.c
@@ -216,8 +216,7 @@ static int folio_split_or_unmap(struct f
  * aligned inwards to min_order, i.e. the range of folios wholly within
  * [lstart, lend] and so safe to discard.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * Return %true if at least one split succeeded, %false otherwise.
  */
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
@@ -247,7 +246,7 @@ bool truncate_inode_partial_folio(struct
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		return false;
 	}
 
 	/*
@@ -264,7 +263,7 @@ bool truncate_inode_partial_folio(struct
 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	if (folio_order(folio) == min_order)
-		return true;
+		return false;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
@@ -327,10 +326,9 @@ out:
 			*pend = end;
 		return true;
 	}
-	if (folio_test_dirty(folio))
-		return false;
-	truncate_inode_folio(folio->mapping, folio);
-	return true;
+	if (!folio_test_dirty(folio))
+		truncate_inode_folio(folio->mapping, folio);
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from yi.zhang@huawei.com are

mm-truncate-align-truncation-boundaries-to-mapping-minimum-folio-order.patch
mm-truncate-look-up-the-end-edge-straddler-by-index.patch
mm-truncate-fix-data-loss-when-splitting-straddling-large-folios-fails.patch
mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch

