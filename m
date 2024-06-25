Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C8C1428FA
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291615; cv=none; b=bWMCrZ+j3BE30uemEk2endHuMZR8I4OMk+Gca5U0WNbJXLLKZBnhEqgG+Nn/T4Wi1dDGVVgcY9lO6EMXaSmoEJRB4fFSkS4krYOktl78EaRl9oYhwc3Z8/ed52nkZhms0eGCy4i8B9r+ubnnvPUj7+1cOAgYRXjOPP/mm6ChpWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291615; c=relaxed/simple;
	bh=cpKvXonVmKLRkWrBVdxOGvL/vRcK8Ukma4NxIGrgpwQ=;
	h=Date:To:From:Subject:Message-Id; b=InLHZ612yTknZ1YAgAj1jbI+NxlrkrLT+bKMiliD24z4Vs+KOmM1+tfzviSYkTr9IX5PV4gntIkOWJ14TOmyL15TMw76GwndpO7Bm150whAJKv72jQD/i65tytw8mKc7056mqnvRfRBXU07jNb+/Lx7Tp4rgfTDss56VXsw1Xv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mvWmv0ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mvWmv0ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2DEC32782;
	Tue, 25 Jun 2024 05:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291615;
	bh=cpKvXonVmKLRkWrBVdxOGvL/vRcK8Ukma4NxIGrgpwQ=;
	h=Date:To:From:Subject:From;
	b=mvWmv0tySg1wB21izwwrlHM+aRQDY/AcY7PFRe0V5hOOXbXi08wqg/fmaPDuT97Uc
	 trYSv9GxGf8jMttqs7ODzSppQehoo58u29gU5wH/sZtzZS4mmxz1XQBy8shhfAyyfT
	 0/mLtMSfSr7mdLNs58J2hl10/glOyCZ00WoEUALk=
Date: Mon, 24 Jun 2024 22:00:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch removed from -mm tree
Message-Id: <20240625050015.AB2DEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()
Date: Thu, 30 May 2024 10:14:27 -0700

By using a folio in scan_movable_pages() we convert the last user of the
page-based hugetlb information macro functions to the folio version. 
After this conversion, we can safely remove the page-based definitions
from include/linux/hugetlb.h.

Link: https://lkml.kernel.org/r/20240530171427.242018-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +-----
 mm/memory_hotplug.c     |   11 +++++------
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages
+++ a/include/linux/hugetlb.h
@@ -616,9 +616,7 @@ static __always_inline						\
 bool folio_test_hugetlb_##flname(struct folio *folio)		\
 	{	void *private = &folio->private;		\
 		return test_bit(HPG_##flname, private);		\
-	}							\
-static inline int HPage##uname(struct page *page)		\
-	{ return test_bit(HPG_##flname, &(page->private)); }
+	}
 
 #define SETHPAGEFLAG(uname, flname)				\
 static __always_inline						\
@@ -637,8 +635,6 @@ void folio_clear_hugetlb_##flname(struct
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
 folio_test_hugetlb_##flname(struct folio *folio)		\
-	{ return 0; }						\
-static inline int HPage##uname(struct page *page)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
--- a/mm/memory_hotplug.c~mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages
+++ a/mm/memory_hotplug.c
@@ -1731,8 +1731,8 @@ static int scan_movable_pages(unsigned l
 	unsigned long pfn;
 
 	for (pfn = start; pfn < end; pfn++) {
-		struct page *page, *head;
-		unsigned long skip;
+		struct page *page;
+		struct folio *folio;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1753,7 +1753,7 @@ static int scan_movable_pages(unsigned l
 
 		if (!PageHuge(page))
 			continue;
-		head = compound_head(page);
+		folio = page_folio(page);
 		/*
 		 * This test is racy as we hold no reference or lock.  The
 		 * hugetlb page could have been free'ed and head is no longer
@@ -1761,10 +1761,9 @@ static int scan_movable_pages(unsigned l
 		 * cases false positives and negatives are possible.  Calling
 		 * code must deal with these scenarios.
 		 */
-		if (HPageMigratable(head))
+		if (folio_test_hugetlb_migratable(folio))
 			goto found;
-		skip = compound_nr(head) - (pfn - page_to_pfn(head));
-		pfn += skip - 1;
+		pfn |= folio_nr_pages(folio) - 1;
 	}
 	return -ENOENT;
 found:
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-use-mas_store_gfp-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
tools-testing-radix-tree-add-missing-module_description-definition.patch

