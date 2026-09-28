Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311ED369D47;
	Mon, 28 Sep 2026 21:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632138; cv=none; b=a/5ix7G/V7fgbFj4NvYRi0qFFsIy6L6hhI0nggnCWkzSj4rwn5TlywEK1DydHBI8ejbkg8534ZdnpGeXkoNcZ+saIxygJGrS12mHjv86cPga40eUOPb7T3rvgg3Pc4/qlvqmCS1+LmySbLgId46lF+Y4hQbkDeLkN5cli5kXF2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632138; c=relaxed/simple;
	bh=Us2N+M2qHKAzCi/co26PXSNrBunIT+ICLPLe74GgF1g=;
	h=Date:To:From:Subject:Message-Id; b=RecHDeXu6LH5PothlT2YQLEYCebRs8waxE9WdKLa3OvGYOC93DMbJi2MlH5lomxs7ENdqc2KcmNX1K6xRaNRAi3O3o71VPDeEt2H8WI+5gi3+D/hEzzCcUWEE1eDJThNSSque7ETjzqwuLoaAlCgyPIg05/D044XIlyaJv4i038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShwozFe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShwozFe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF10E1F00893;
	Mon, 28 Sep 2026 21:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632134;
	bh=CLR49A+UfMlGhxEZurONATU3eIdiwigAUypiGCgCsSA=;
	h=Date:To:From:Subject;
	b=ShwozFe1whc3FKDJc7OjvthWC8OZC8CXnviU5uX55LsZbN6k1L7Zy7CSVEFUQqgHA
	 w/j+Dv/ZqzSGWRuMyaZAwikXjnF7oIc9UYWL4xp3hretivrR0c0nhg5sZLrodAfa+5
	 Q6vsa1BUnNv6nppOww+3JqeB/fWSJ1JXZF0P+baY=
Date: Mon, 28 Sep 2026 14:48:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yukuai@fnnas.com,yizhang089@gmail.com,yangerkun@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joannelkoong@gmail.com,jack@suse.cz,hughd@google.com,djwong@kernel.org,david@kernel.org,chengzhihao1@huawei.com,bfoster@redhat.com,baolin.wang@linux.alibaba.com,yi.zhang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-look-up-the-end-edge-straddler-by-index.patch added to mm-new branch
Message-Id: <20260928214854.AF10E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: look up the end-edge straddler by index
has been added to the -mm mm-new branch.  Its filename is
     mm-truncate-look-up-the-end-edge-straddler-by-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-look-up-the-end-edge-straddler-by-index.patch

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
Subject: mm/truncate: look up the end-edge straddler by index
Date: Mon, 28 Sep 2026 20:08:31 +0800

In truncate_inode_partial_folio(), after the first split at the start
edge, folio_split() unlocks and drops the refcount of the after-split
sub-folios.  The sub-folio straddling the end of the truncation range is
therefore unlocked and only transiently ref'd in the page cache while the
code still derives it from a page pointer inside the original folio.

Between the first split finishing and page_folio() resolving split_at2,
that tail page can be reclaimed, freed and reallocated as a new large
folio in the same mapping at a different file offset.  folio2 then points
at a folio that does not cover the end boundary, yet folio2->mapping ==
folio->mapping still holds, so the stale pointer passes the mapping check
and folio_split_or_unmap() splits a folio at a wrong position (or, with a
transient refcount, a use-after-free window opens between try_get and the
split).  __folio_split()'s own folio != page_folio(split_at) check cannot
catch this either since split_at2 has been reallocated as part of the new
folio, so page_folio(split_at2) resolves back to folio2.

Look the straddler up by its page index instead.  __filemap_get_folio()
returns the folio currently covering the boundary, ref'd and locked, with
the mapping validated under the lock, so the split target is always the
real folio at the end edge.

Link: https://lore.kernel.org/20260928120833.3440834-3-yi.zhang@huaweicloud.com
Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Zi Yan <ziy@nvidia.com>
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
Cc: <stable@vger.kernel.org>
---

 mm/truncate.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/mm/truncate.c~mm-truncate-look-up-the-end-edge-straddler-by-index
+++ a/mm/truncate.c
@@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		pgoff_t end_idx;
 
 		if (offset + length == size)
 			goto no_split;
 
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);
-
-		if (!folio_try_get(folio2))
+		/*
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at end_idx
+		 * and returns it locked and ref'd with the mapping
+		 * validated.
+		 */
+		end_idx = (pos + offset + length) >> PAGE_SHIFT;
+		folio2 = __filemap_get_folio(folio->mapping, end_idx,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2))
 			goto no_split;
 
+		/* make sure folio2 is large */
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
-			goto out;
-
-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
-
-		folio_unlock(folio2);
+		split_at2 = folio_page(folio2, (end_idx - folio2->index));
+		folio_split_or_unmap(folio2, split_at2, min_order);
 out:
+		folio_unlock(folio2);
 		folio_put(folio2);
 no_split:
 		return true;
_

Patches currently in -mm which might be from yi.zhang@huawei.com are

mm-truncate-align-truncation-boundaries-to-mapping-minimum-folio-order.patch
mm-truncate-look-up-the-end-edge-straddler-by-index.patch
mm-truncate-fix-data-loss-when-splitting-straddling-large-folios-fails.patch
mm-truncate-clarify-return-value-of-truncate_inode_partial_folio.patch

