Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015A0199BC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957025; cv=none; b=PAmSucdQ1kzNgoQtoZtrjz57w3i7T0HnFRmaW19fNhkGOLdC3Ec/7g6rGXCZW0Ad8HyVKXqdoI/Oj+bc41Z/Ylf2KDB+JYbJuGbFCNTuamkFG8JerXVWSPU1iJ5r76MDs3w5uo8W6sD9TQFm0+39Wcem5pPc5Ggg212oZy5K8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957025; c=relaxed/simple;
	bh=flrqXO9MJ2fJKmq2bUisYKZv4XrQKBKBYQvH2ZfDH1c=;
	h=Date:To:From:Subject:Message-Id; b=oB6CUoPcrp3Mjfo5xbSrPNkTv+O2Twat3ilcOpQfaTXyob1LhqtNdnKB+Lsl+kbDVpktu3CxczFSHH/A+m332amGa3b384fVrd7Q3jAYj9pvLMcfaMfLOFyjsl8FakmeycGnJGWjGY39/8RVX5vwir4XivAgZ5nVHNhsAFr/rEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JuKrf56T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JuKrf56T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EEBC113CC;
	Mon,  6 May 2024 00:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957024;
	bh=flrqXO9MJ2fJKmq2bUisYKZv4XrQKBKBYQvH2ZfDH1c=;
	h=Date:To:From:Subject:From;
	b=JuKrf56TDVEH2kcC3+UowCX/1oyZKZEV6WdTfTQCSoA20AvmaDX8ksxZIYI3kbM2D
	 OXMShmJvWxonav0EGdSS7DcL+qPhY4dns0kemtlLVEkKMJCQ6osdwnBzbvGcDHJmgb
	 WbdWbhg8i21qEs2ToI27B7D86DWxpg3/qeloYktI=
Date: Sun, 05 May 2024 17:57:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-folio-in-remove_stable_node.patch removed from -mm tree
Message-Id: <20240506005704.C9EEBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use folio in remove_stable_node
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-folio-in-remove_stable_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


