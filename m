Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9FB3EA97B
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525618; cv=none; b=KXOAetGBVSdRQnHkyuRcXi7Tqq8joPOvdMPfX5vl9SgLyjJPraL+VVXr3hJ3MDKoOScaGghfCtUm+ZvM2ExG6hefRJfsqQ44AjLpHxW9yDO1AJmv2sJG3PYthXtGR7t2Rvf5Sies4GoaXO56Oj5KRkn5sCXehE3/cst9e/u7UUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525618; c=relaxed/simple;
	bh=nZifsPZbAm0eF1+EO+XxFola5N1rSnRVMjajG6yiiPU=;
	h=Date:To:From:Subject:Message-Id; b=hSZWaeGfmAdJfJeSJTsfcbz5OTDAH0kElm0Gi5/5ChJ5fAjFl0+LDYnZq72pTSdHWMURz/QJH9u7zgtUJqUk9SuAWc1uiCZmlwIEaFfBQjXVQF4uD4gbG7XGJPgsNQMA5ZXM4YGOgN5Q+x9VulQPSs51CJ9RkLrUilencz3RMsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=orFVYRyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="orFVYRyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2121F000FF;
	Fri,  9 Oct 2026 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525616;
	bh=GOU688qzRXNil7AvDBm7hF5yAxbzJJv2Gh6MuDDYA/w=;
	h=Date:To:From:Subject;
	b=orFVYRynnjLrZryrYBBZ/JcN/mVVY2MnC55Z9Bc/7/8BErDg05zWfm0odTAwMu9R0
	 sO7NZhzXx2wxrA4uQgnGKizty1DSPlP+3IGNh6ZqIAFmPzXeh+IZN9DTMH2HzR0p9e
	 PlpipYyexeznxXcmKzVj9FDn5RuGnldlcA/ieAMw=
Date: Thu, 08 Oct 2026 23:00:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch removed from -mm tree
Message-Id: <20261009060016.BC2121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
Date: Wed, 23 Sep 2026 23:32:48 +0200

The mapping parameter only served as a non-NULL check to detect whether
page cache entries need updating.  The xa_state pointer conveys exactly
the same information: the anon split helper passes NULL and the file split
helper passes &xas, which is non-NULL iff the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-17-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio
+++ a/mm/huge_memory.c
@@ -3833,7 +3833,6 @@ static void __split_folio_to_order(struc
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3866,7 +3865,7 @@ static void __split_folio_to_order(struc
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3890,7 +3889,7 @@ static int __split_frozen_folio(struct f
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4089,8 +4088,7 @@ static int __folio_freeze_split_anon(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4226,8 +4224,7 @@ static int __folio_freeze_split_file(str
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
_

Patches currently in -mm which might be from kasong@tencent.com are


