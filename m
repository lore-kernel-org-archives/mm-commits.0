Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146022264CA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343227; cv=none; b=EE3fL88YQDtgmIJ3Wof7mPAGF06R7AHZ9a6RZp7aK0rNc77p2+ohX4yeFIMNq2iOnNN6C0W20qDMvjupCGMG9uqWhpr1oq2f4lHEvDpwIKE4UmWjNeyxCeb6im+wcAdiw0CBtlRKpdbsAB7gC4/av2almwdmlPAD038+rnf9ut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343227; c=relaxed/simple;
	bh=Iy3Ph4lYa4AlqkRoIL7KeaFm+pMezoF0tloI02SH2Nk=;
	h=Date:To:From:Subject:Message-Id; b=VupdNUtjEB4VL0eXK4B1K/SL8cekHRK6WBr9wuEIwaqVc8NYHkzThkS8MC9s+jEI1jR7gFVP1mmMa2XiTo5AMUeYx2FUPvGQjCdwj4KwVNZadCYnrkbgUhYf1n6N6L/GCz5Yp/NnBJIw/LBe/S3aIxn2bGMPz0ZBJs7o1+81fPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRGthTTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRGthTTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AAEC116D0;
	Mon, 17 Nov 2025 01:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343226;
	bh=Iy3Ph4lYa4AlqkRoIL7KeaFm+pMezoF0tloI02SH2Nk=;
	h=Date:To:From:Subject:From;
	b=mRGthTTyo5dy5AbZZJfYMPlHHLrzToU+UVb+nnLmlbJXk8ydOyxek8iE57sGlkrcm
	 uAyPuold+2XKIZLAKChLKvnScaZq+6GdiRMmZeJRSxjH0BMOZKr4yy9NvlAU6NhaLC
	 eL9AAW2pmEVHb6kUKeT57xfNkb3q41KjJZgms1+0=
Date: Sun, 16 Nov 2025 17:33:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-avoid-reinvoking-folio_test_anon.patch removed from -mm tree
Message-Id: <20251117013346.85AAEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: avoid reinvoking folio_test_anon()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-avoid-reinvoking-folio_test_anon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: avoid reinvoking folio_test_anon()
Date: Tue, 21 Oct 2025 21:21:39 +0000

Patch series "mm/huge_memory: cleanup __split_unmapped_folio()", v3.

This patch series cleans up and optimizes the internal logic of the
__split_unmapped_folio() function.

The goal is to improve clarity and efficiency by eliminating redundant
checks, caching stable attribute values, and simplifying the iteration
logic used for updating folio statistics.

These changes make the code easier to follow and maintain.

The split_huge_page_test selftest pass.


This patch (of 4):

During the execution of __split_unmapped_folio(), the folio's anon/!anon
attribute is invariant (not expected to change).

Therefore, it is safe and more efficient to retrieve this attribute once
at the start and reuse it throughout the function.

Link: https://lkml.kernel.org/r/20251021212142.25766-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251016004613.514-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251016004613.514-2-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251021212142.25766-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-avoid-reinvoking-folio_test_anon
+++ a/mm/huge_memory.c
@@ -3401,6 +3401,7 @@ static int __split_unmapped_folio(struct
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, bool uniform_split)
 {
+	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
 	bool stop_split = false;
@@ -3408,7 +3409,7 @@ static int __split_unmapped_folio(struct
 	int split_order;
 	int ret = 0;
 
-	if (folio_test_anon(folio))
+	if (is_anon)
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	/*
@@ -3423,7 +3424,7 @@ static int __split_unmapped_folio(struct
 		struct folio *new_folio;
 
 		/* order-1 anonymous folio is not supported */
-		if (folio_test_anon(folio) && split_order == 1)
+		if (is_anon && split_order == 1)
 			continue;
 		if (uniform_split && split_order != new_order)
 			continue;
@@ -3475,7 +3476,7 @@ static int __split_unmapped_folio(struct
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

mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

