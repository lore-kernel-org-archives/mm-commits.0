Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E358C329399
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761947755; cv=none; b=TlUEboAzB5o3ph+XRx7p6xhrTAQvcV5IM8jI0WVGfbmlLqbZNOYeygXZv4S/0RYEhz9HKXLgiyp+u/sdj6Q+20wmpwv8h6cxkthLqy/dEuC+KlxlngfylOGnXKqxPbBLFJzuZ45w38Aq1sEdzdQcHfi4lwZU/70wIRP05fHCsnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761947755; c=relaxed/simple;
	bh=Q7NVwEk6csq4gNb/cfeFntrm7njvmTNzOa6FoMAUiVo=;
	h=Date:To:From:Subject:Message-Id; b=cCQVe0/C1sEKRBkmDXtCILMe/4fyn6Fx2CoDdzUG2kGrpsfdDuXYeJiF8d6XgTBfoi87y0IB2VvSDUlVQHs7UCAeLNliWC5afr/OdDnp6588O2PGyZOmzUACVLn4l8IZFe4ll5Sy8JdgLtY2/MD9UpSMnzKMmKXIac7v727vHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ttMVlD0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ttMVlD0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB809C4CEE7;
	Fri, 31 Oct 2025 21:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761947754;
	bh=Q7NVwEk6csq4gNb/cfeFntrm7njvmTNzOa6FoMAUiVo=;
	h=Date:To:From:Subject:From;
	b=ttMVlD0gbg2u1XT3JGH9MBWB7+oXqhvZ8HYR/xsTF7qoYTFFB/irkqoaprZ++uPqF
	 CoApTygb+hYoO6upuq9Y0emwtnJL2HLPFDJwqhnAkrKAQa4E+p6pMfpG0DniUE44VL
	 io97FqhTjGWfNBQ2dNUzo07dSvLFACNh2y6r8/cg=
Date: Fri, 31 Oct 2025 14:55:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-improve-large-block-size-folio-handling.patch added to mm-new branch
Message-Id: <20251031215554.AB809C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: improve large block size folio handling
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-improve-large-block-size-folio-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-improve-large-block-size-folio-handling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/memory-failure: improve large block size folio handling
Date: Fri, 31 Oct 2025 12:20:00 -0400

Large block size (LBS) folios cannot be split to order-0 folios but
min_order_for_folio().  Current split fails directly, but that is not
optimal.  Split the folio to min_order_for_folio(), so that, after split,
only the folio containing the poisoned page becomes unusable instead.

For soft offline, do not split the large folio if its
min_order_for_folio() is not 0.  Since the folio is still accessible from
userspace and premature split might lead to potential performance loss.

Link: https://lkml.kernel.org/r/20251031162001.670503-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-improve-large-block-size-folio-handling
+++ a/mm/memory-failure.c
@@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned
  * there is still more to do, hence the page refcount we took earlier
  * is still needed.
  */
-static int try_to_split_thp_page(struct page *page, bool release)
+static int try_to_split_thp_page(struct page *page, unsigned int new_order,
+		bool release)
 {
 	int ret;
 
 	lock_page(page);
-	ret = split_huge_page(page);
+	ret = split_huge_page_to_order(page, new_order);
 	unlock_page(page);
 
 	if (ret && release)
@@ -2280,6 +2281,9 @@ try_again:
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
+		const int new_order = min_order_for_split(folio);
+		int err;
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2294,7 +2298,16 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p, false) < 0) {
+		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		/*
+		 * If splitting a folio to order-0 fails, kill the process.
+		 * Split the folio regardless to minimize unusable pages.
+		 * Because the memory failure code cannot handle large
+		 * folios, this split is always treated as if it failed.
+		 */
+		if (err || new_order) {
+			/* get folio again in case the original one is split */
+			folio = page_folio(p);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
@@ -2621,7 +2634,17 @@ static int soft_offline_in_use_page(stru
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page, true)) {
+		const int new_order = min_order_for_split(folio);
+
+		/*
+		 * If new_order (target split order) is not 0, do not split the
+		 * folio at all to retain the still accessible large folio.
+		 * NOTE: if minimizing the number of soft offline pages is
+		 * preferred, split it to non-zero new_order like it is done in
+		 * memory_failure().
+		 */
+		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
+						       /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch

