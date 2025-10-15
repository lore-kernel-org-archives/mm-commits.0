Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD66E44C63
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760486591; cv=none; b=mum3W84Yq+gsHL6Z9i2hoOYuiWl8cl5PjpF/lGKqsAt/jV02h9xZL1tLIwuOr6p6U85f0ZJy3hez3XAE23hK4iqWwUyldeg2DdGpaZGz+Je5WPIzfM8LZIUhAIq37QCUI51iW+rzpzGll32eZpTx0X1MGz7QNGYf+S/F1adYBYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760486591; c=relaxed/simple;
	bh=4qbwYBR1r/pZl9Sf00owFU3J7/PJ3nWrMw0BzEVYk1k=;
	h=Date:To:From:Subject:Message-Id; b=tHkSvwX6sFbW2A+cG9Y6znGYQsXf4UrUN/xjG7sKHPbHhBIi7/uhVieUWMV1hsVHpjiE6VZzu2pjvAsWtjV7/y6VU1AIDTY3GVWnipWaHhVDyfRVvXLxZu99vqEqb3zN8x2H3bk62avQ7fapPB26lwykEMIm4C1p1i63j+PubX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcYeZOkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcYeZOkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445D3C4CEE7;
	Wed, 15 Oct 2025 00:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760486589;
	bh=4qbwYBR1r/pZl9Sf00owFU3J7/PJ3nWrMw0BzEVYk1k=;
	h=Date:To:From:Subject:From;
	b=LcYeZOkfaTpBnGeIyBWJMevlVidLfSfn7N6MQTAtMxaMX+CS/sSIQBWizaezDSq/D
	 XYaREyrouGN+byuYgS0Is6huCkC2vWzPEjvaXfm23CAT4gxxbJ5Z8EHg5aydMJzwLY
	 ZLflN+MSCeeIA5WFSnvzEi7Dos/7yBu4u1TUzrvM=
Date: Tue, 14 Oct 2025 17:03:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch added to mm-new branch
Message-Id: <20251015000309.445D3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: cache folio attribute in __split_unmapped_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: cache folio attribute in __split_unmapped_folio()
Date: Tue, 14 Oct 2025 13:46:02 +0000

Patch series "mm/huge_memory: cleanup __split_unmapped_folio()".

This series cleans up and optimizes the internal logic of folio splitting,
particularly focusing on __split_unmapped_folio().

The goal is to improve clarity and efficiency by eliminating redundant
checks, caching stable attribute values, and simplifying the iteration
logic used for updating folio statistics.

These changes make the code easier to follow and maintain.


This patch (of 5):

During the execution of __split_unmapped_folio(), the folio's anon/!anon
attribute is invariant (not expected to change).

Therefore, it is safe and more efficient to retrieve this attribute once
at the start and reuse it throughout the function.

Link: https://lkml.kernel.org/r/20251014134606.22543-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251014134606.22543-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio
+++ a/mm/huge_memory.c
@@ -3527,6 +3527,7 @@ static int __split_unmapped_folio(struct
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, bool uniform_split)
 {
+	bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
 	bool stop_split = false;
@@ -3534,7 +3535,7 @@ static int __split_unmapped_folio(struct
 	int split_order;
 	int ret = 0;
 
-	if (folio_test_anon(folio))
+	if (is_anon)
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3551,7 +3552,7 @@ static int __split_unmapped_folio(struct
 		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
-		if (folio_test_anon(folio) && split_order == 1)
+		if (is_anon && split_order == 1)
 			continue;
 		if (uniform_split && split_order != new_order)
 			continue;
@@ -3603,7 +3604,7 @@ static int __split_unmapped_folio(struct
 				if (split_order != new_order && !stop_split)
 					continue;
 			}
-			if (folio_test_anon(new_folio))
+			if (is_anon)
 				mod_mthp_stat(folio_order(new_folio),
 					      MTHP_STAT_NR_ANON, 1);
 		}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch

