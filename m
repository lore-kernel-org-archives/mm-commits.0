Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268D1754B
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868454; cv=none; b=YZzDGNvRnne2zV63uk6/ZHg222FLOxtZS8j7TdFUgO1eUo7vrfPpv3Nj0laGhLqv60xXHj+UxJyN+hmTsivnSAJaXuUssE52d2n0PuBKwDhihloJjSunvSQmXFaIH+X7jjhn6+ETh8FSKgGp/F4GKneBFxg7zCd73lhERku41Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868454; c=relaxed/simple;
	bh=MuvnTQ7vyvuFYPTlT9FRi7vVsUXrBRPX2jcLGi5jc+Q=;
	h=Date:To:From:Subject:Message-Id; b=TBCa5xgCRpPWImzO/KzXfonYFyPLdKQTO30ONRhg724t5cja670EzRMlm5zfC6+3Y1v6oA7pIdcaJM4ilQhy6aruz1T3Ph+zvnkh2SV+9awJzpwKYT7+39etHFI36m09/Gjjg31mIhrR8GOy4maCzgZe+OHNpU4nE8EBG7GAc74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jK54OIZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jK54OIZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F38C113CC;
	Thu, 11 Apr 2024 20:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712868453;
	bh=MuvnTQ7vyvuFYPTlT9FRi7vVsUXrBRPX2jcLGi5jc+Q=;
	h=Date:To:From:Subject:From;
	b=jK54OIZKCeLRPQBXPiA+xeAHjS2QH1IJndQfFlMuE9fGqVVo73wUkfwARHBuCBsXx
	 Ulzoq0dTkUihGpcbeHQUkODuLCP97DUPg8ieyw+4r8JLOQ/mmjZyKIxzOZgLcgtUsL
	 Rtby/+HNAnKOEmdGWPDwbb6lEJiz2YpqKyB6o/Kg=
Date: Thu, 11 Apr 2024 13:47:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-folio-in-remove_stable_node.patch added to mm-unstable branch
Message-Id: <20240411204733.A2F38C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: use folio in remove_stable_node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-folio-in-remove_stable_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-folio-in-remove_stable_node.patch

This patch will later appear in the mm-unstable branch at
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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use folio in remove_stable_node
Date: Thu, 11 Apr 2024 14:17:05 +0800

Pages in stable tree are all single normal page, so uses ksm_get_folio()
and folio_set_stable_node(), also saves 3 calls to compound_head().

Link: https://lkml.kernel.org/r/20240411061713.1847574-5-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-folio-in-remove_stable_node
+++ a/mm/ksm.c
@@ -1121,13 +1121,13 @@ static inline void folio_set_stable_node
  */
 static int remove_stable_node(struct ksm_stable_node *stable_node)
 {
-	struct page *page;
+	struct folio *folio;
 	int err;
 
-	page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
-	if (!page) {
+	folio = ksm_get_folio(stable_node, GET_KSM_PAGE_LOCK);
+	if (!folio) {
 		/*
-		 * get_ksm_page did remove_node_from_stable_tree itself.
+		 * ksm_get_folio did remove_node_from_stable_tree itself.
 		 */
 		return 0;
 	}
@@ -1138,22 +1138,22 @@ static int remove_stable_node(struct ksm
 	 * merge_across_nodes/max_page_sharing be switched.
 	 */
 	err = -EBUSY;
-	if (!page_mapped(page)) {
+	if (!folio_mapped(folio)) {
 		/*
-		 * The stable node did not yet appear stale to get_ksm_page(),
-		 * since that allows for an unmapped ksm page to be recognized
+		 * The stable node did not yet appear stale to ksm_get_folio(),
+		 * since that allows for an unmapped ksm folio to be recognized
 		 * right up until it is freed; but the node is safe to remove.
-		 * This page might be in an LRU cache waiting to be freed,
-		 * or it might be PageSwapCache (perhaps under writeback),
+		 * This folio might be in an LRU cache waiting to be freed,
+		 * or it might be in the swapcache (perhaps under writeback),
 		 * or it might have been removed from swapcache a moment ago.
 		 */
-		set_page_stable_node(page, NULL);
+		folio_set_stable_node(folio, NULL);
 		remove_node_from_stable_tree(stable_node);
 		err = 0;
 	}
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return err;
 }
 
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

