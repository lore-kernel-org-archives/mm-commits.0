Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2254907
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247748; cv=none; b=ASHfNyttJgHf5/mFPU8GFlv+yF1ivX0sj4fPtV4UT/WbUxMwvYVT6DmibGlHGAOcZd0Vy6lH++b6XwjCLhoq7Aic3n3+RwEV5b3mYqhbBPrW1REejBr8VSJ0NDdgu25BNUYDmVlnw2S6HgOgG1gWm2cb44MXFsLMqCobwxRtpbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247748; c=relaxed/simple;
	bh=HmloKJNzVsF7XPQAnBtZi7j3FMmJ2z1SyxcKbbPMlOA=;
	h=Date:To:From:Subject:Message-Id; b=sidVtdEN57k6ZiPBrJGa3AfMMvxsLi82+Mp5vhu6Rcbwj/4+dWus0VHtC6yUehKUgjBJhuq4a4K2TZfYQvakngyTe24F1gZtcG95PYlKCuUJssZL8VZ5Ve4Lc3mJDh42Rcm17R+ImKYS02mr5ECfVy9p4CODVkTamyFHSadOwuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=io2Olb0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="io2Olb0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B25C4CEC2;
	Mon,  2 Sep 2024 03:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247748;
	bh=HmloKJNzVsF7XPQAnBtZi7j3FMmJ2z1SyxcKbbPMlOA=;
	h=Date:To:From:Subject:From;
	b=io2Olb0gvUgVzmSeeb3qAfeYETZ8KCLoKYZ3eSAY0ohOJMwEzN6sOmvA7P8os3+RF
	 HZkCv2oX4mMeTmgyRnh0XPxsAeQ3JsbqnyCBpGBhetJYZ7hCPViid1zFCXGZ0FG8Ch
	 WOR7NXvAfEdlGr6Fwfrnk5/3JL9aHWkkEHexSWfY=
Date: Sun, 01 Sep 2024 20:29:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032908.90B25C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: convert split_huge_pages_pid() from follow_page() to folio_walk
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: convert split_huge_pages_pid() from follow_page() to folio_walk
Date: Fri, 2 Aug 2024 17:55:20 +0200

Let's remove yet another follow_page() user.  Note that we have to do the
split without holding the PTL, after folio_walk_end().  We don't care
about losing the secretmem check in follow_page().

[david@redhat.com: teach can_split_folio() that we are not holding an additional reference]
  Link: https://lkml.kernel.org/r/c75d1c6c-8ea6-424f-853c-1ccda6c77ba2@redhat.com
Link: https://lkml.kernel.org/r/20240802155524.517137-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |   27 ++++++++++++++++-----------
 mm/vmscan.c             |    2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk
+++ a/include/linux/huge_mm.h
@@ -314,7 +314,7 @@ unsigned long thp_get_unmapped_area_vmfl
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
 
-bool can_split_folio(struct folio *folio, int *pextra_pins);
+bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 static inline int split_huge_page(struct page *page)
@@ -470,7 +470,7 @@ thp_get_unmapped_area_vmflags(struct fil
 }
 
 static inline bool
-can_split_folio(struct folio *folio, int *pextra_pins)
+can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk
+++ a/mm/huge_memory.c
@@ -40,6 +40,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/pagewalk.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -3017,7 +3018,7 @@ static void __split_huge_page(struct pag
 }
 
 /* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int *pextra_pins)
+bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	int extra_pins;
 
@@ -3029,7 +3030,8 @@ bool can_split_folio(struct folio *folio
 		extra_pins = folio_nr_pages(folio);
 	if (pextra_pins)
 		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins - 1;
+	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
+					caller_pins;
 }
 
 /*
@@ -3197,7 +3199,7 @@ int split_huge_page_to_list_to_order(str
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, &extra_pins)) {
+	if (!can_split_folio(folio, 1, &extra_pins)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3504,7 +3506,7 @@ static int split_huge_pages_pid(int pid,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
-		struct page *page;
+		struct folio_walk fw;
 		struct folio *folio;
 
 		if (!vma)
@@ -3516,13 +3518,10 @@ static int split_huge_pages_pid(int pid,
 			continue;
 		}
 
-		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
-
-		if (IS_ERR_OR_NULL(page))
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio)
 			continue;
 
-		folio = page_folio(page);
 		if (!is_transparent_hugepage(folio))
 			goto next;
 
@@ -3536,18 +3535,24 @@ static int split_huge_pages_pid(int pid,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, NULL))
+		    !can_split_folio(folio, 0, NULL))
 			goto next;
 
 		if (!folio_trylock(folio))
 			goto next;
+		folio_get(folio);
+		folio_walk_end(&fw, vma);
 
 		if (!split_folio_to_order(folio, new_order))
 			split++;
 
 		folio_unlock(folio);
-next:
 		folio_put(folio);
+
+		cond_resched();
+		continue;
+next:
+		folio_walk_end(&fw, vma);
 		cond_resched();
 	}
 	mmap_read_unlock(mm);
--- a/mm/vmscan.c~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk
+++ a/mm/vmscan.c
@@ -1227,7 +1227,7 @@ retry:
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, NULL))
+					if (!can_split_folio(folio, 1, NULL))
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

