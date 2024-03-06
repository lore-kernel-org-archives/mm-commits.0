Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5670175B7
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759110; cv=none; b=C2XpbfdTHWvdlRROO1ZA/u08cnMSVOqgpZ4/DHlW050ofnBGZnhLFvYzaaNe5lU7n0M0JK5ht3+3NdpD1FVYo9zK1fYdfYUgCgsbnwE8R2eluIzhMDkeXGUs4F6wVF7RrxbBUvhJF3tkKP8tywqPqYoMo9s+Xl218JAO8M5C3hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759110; c=relaxed/simple;
	bh=Rj4f1BpKXxnqh9PZHWO34oXphMg6XjePpfTLkUs/HjA=;
	h=Date:To:From:Subject:Message-Id; b=b4LfZewa9nAwxLQ3OLBnK+bNOOeNLEJw59xoIHI2ZlkiNeb1i+/WOP1spWKOJcWpHEJH4/8Gg3nCJrQU6lZ6NXtduPHILul7Yh+vbXCgS3DPvlBSuC+gGNPvDvBJsSLm6iNHnY2t26ArxPd7SYIolbuGAPPI3Qj6ocTHN0KfKOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jcM+FxZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jcM+FxZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC62C43390;
	Wed,  6 Mar 2024 21:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759110;
	bh=Rj4f1BpKXxnqh9PZHWO34oXphMg6XjePpfTLkUs/HjA=;
	h=Date:To:From:Subject:From;
	b=jcM+FxZS3IgnYYAmaBDOlvIR/wfJ5yhhFyCfKI1UrPwJ+7Q7uQdEG89tTUxg4ZqC3
	 rhWCTO8FCDkUw2t+63zO2mIejJobL8CegR1GGaH28/NmrlJt3Lr3F7dMPPrk9jF90G
	 cyBICGGp68GUNdyCXbHCjhAXvHDP1qTT646mybQU=
Date: Wed, 06 Mar 2024 13:05:09 -0800
To: mm-commits@vger.kernel.org,gregory.price@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-a-folio-in-do_mbind.patch removed from -mm tree
Message-Id: <20240306210510.3AC62C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: use a folio in do_mbind()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-a-folio-in-do_mbind.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: use a folio in do_mbind()
Date: Thu, 29 Feb 2024 15:29:45 +0000

We actually add folios to the pagelist already, but then work with them as
pages.  Removes a call to compound_head() in PageKsm() and removes a
reference to page->index.

Link: https://lkml.kernel.org/r/20240229153015.1996829-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price <gregory.price@memverge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-a-folio-in-do_mbind
+++ a/mm/mempolicy.c
@@ -1356,29 +1356,30 @@ static long do_mbind(unsigned long start
 		 */
 		if (new->mode == MPOL_INTERLEAVE ||
 		    new->mode == MPOL_WEIGHTED_INTERLEAVE) {
-			struct page *page;
+			struct folio *folio;
 			unsigned int order;
 			unsigned long addr = -EFAULT;
 
-			list_for_each_entry(page, &pagelist, lru) {
-				if (!PageKsm(page))
+			list_for_each_entry(folio, &pagelist, lru) {
+				if (!folio_test_ksm(folio))
 					break;
 			}
-			if (!list_entry_is_head(page, &pagelist, lru)) {
+			if (!list_entry_is_head(folio, &pagelist, lru)) {
 				vma_iter_init(&vmi, mm, start);
 				for_each_vma_range(vmi, vma, end) {
-					addr = page_address_in_vma(page, vma);
+					addr = page_address_in_vma(
+						folio_page(folio, 0), vma);
 					if (addr != -EFAULT)
 						break;
 				}
 			}
 			if (addr != -EFAULT) {
-				order = compound_order(page);
+				order = folio_order(folio);
 				/* We already know the pol, but not the ilx */
 				mpol_cond_put(get_vma_policy(vma, addr, order,
 							     &mmpol.ilx));
 				/* Set base from which to increment by index */
-				mmpol.ilx -= page->index >> order;
+				mmpol.ilx -= folio->index >> order;
 			}
 		}
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


