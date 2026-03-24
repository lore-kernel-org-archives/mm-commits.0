Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F759365A00
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388630; cv=none; b=bBjCG10dS9Sm2OCBcbyn04tUyskXADsALY//pgevMdxlhXsiGVbyEhDfUOg6PEq1EMI+FFJd18iMvV1WKdwfq0cZ1rbkBKsrQpka3I3C6Z5syBwW2KLuvmMiD5M8UAzTkxvDJi2bZB+ydHVsl61y4KCTuOV/FBrWnrzmPyPjOs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388630; c=relaxed/simple;
	bh=gf4o5ue6abE8zfkLU7+Lnj2/MG5UzYtTZ90wbVXtlSQ=;
	h=Date:To:From:Subject:Message-Id; b=Y8GBzZQaTtKOlbTUyY/HHK8W616ArXbJRckujtKlcvoqzPeD+19zeBZYEWVt2YNdVWPau85c61bsaRg35DUcjvwpc7YsrPup7ReUu0bDdmb5KAKHxGGVnj7QSOSyqeUG0zygSNI9Gt+DjX23gH6YJ9qyBt1xmEd1COoWlDPxnn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0PHv1AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0PHv1AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486ECC19424;
	Tue, 24 Mar 2026 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388630;
	bh=gf4o5ue6abE8zfkLU7+Lnj2/MG5UzYtTZ90wbVXtlSQ=;
	h=Date:To:From:Subject:From;
	b=F0PHv1AYkvkePGxxPk4gsXPfaRPutm3slUst8nfVBo6x+OTbtsTRNeJUZVOkZL6ev
	 DpcyS49Tr5OJ0qWs1ofp1qdXQW+aE1XVdHOxlw/pi4lVX5YnQVbe2IueJGNBLnnb4m
	 pEDJjqPzAnfZRkEjAW/WWBdPSYlCBzfy80YQxohQ=
Date: Tue, 24 Mar 2026 14:43:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-the-interface-of-prep_compound_tail.patch removed from -mm tree
Message-Id: <20260324214350.486ECC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change the interface of prep_compound_tail()
has been removed from the -mm tree.  Its filename was
     mm-change-the-interface-of-prep_compound_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: change the interface of prep_compound_tail()
Date: Fri, 27 Feb 2026 19:42:40 +0000

Instead of passing down the head page and tail page index, pass the tail
and head pages directly, as well as the order of the compound page.

This is a preparation for changing how the head position is encoded in the
tail page.

Link: https://lkml.kernel.org/r/20260227194302.274384-3-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +++--
 mm/hugetlb.c               |    8 +++++---
 mm/internal.h              |   11 +++++------
 mm/mm_init.c               |    2 +-
 mm/page_alloc.c            |    2 +-
 5 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/page-flags.h~mm-change-the-interface-of-prep_compound_tail
+++ a/include/linux/page-flags.h
@@ -870,9 +870,10 @@ static inline bool folio_test_large(cons
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
 {
-	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
+	WRITE_ONCE(tail->compound_head, (unsigned long)head + 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
--- a/mm/hugetlb.c~mm-change-the-interface-of-prep_compound_tail
+++ a/mm/hugetlb.c
@@ -3168,6 +3168,7 @@ found:
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
+					struct hstate *h,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
@@ -3176,6 +3177,7 @@ static void __init hugetlb_folio_init_ta
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	unsigned int order = huge_page_order(h);
 
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
@@ -3183,7 +3185,7 @@ static void __init hugetlb_folio_init_ta
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+		prep_compound_tail(page, &folio->page, order);
 		set_page_count(page, 0);
 	}
 }
@@ -3203,7 +3205,7 @@ static void __init hugetlb_folio_init_vm
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
+	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
@@ -3260,7 +3262,7 @@ static void __init prep_and_add_bootmem_
 			 * time as this is early in boot and there should
 			 * be no contention.
 			 */
-			hugetlb_folio_init_tail_vmemmap(folio,
+			hugetlb_folio_init_tail_vmemmap(folio, h,
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
--- a/mm/internal.h~mm-change-the-interface-of-prep_compound_tail
+++ a/mm/internal.h
@@ -897,13 +897,12 @@ static inline void prep_compound_head(st
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
-static inline void prep_compound_tail(struct page *head, int tail_idx)
+static inline void prep_compound_tail(struct page *tail,
+		const struct page *head, unsigned int order)
 {
-	struct page *p = head + tail_idx;
-
-	p->mapping = TAIL_MAPPING;
-	set_compound_head(p, head);
-	set_page_private(p, 0);
+	tail->mapping = TAIL_MAPPING;
+	set_compound_head(tail, head, order);
+	set_page_private(tail, 0);
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
--- a/mm/mm_init.c~mm-change-the-interface-of-prep_compound_tail
+++ a/mm/mm_init.c
@@ -1110,7 +1110,7 @@ static void __ref memmap_init_compound(s
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(head, pfn - head_pfn);
+		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
 	prep_compound_head(head, order);
--- a/mm/page_alloc.c~mm-change-the-interface-of-prep_compound_tail
+++ a/mm/page_alloc.c
@@ -744,7 +744,7 @@ void prep_compound_page(struct page *pag
 
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
-		prep_compound_tail(page, i);
+		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
_

Patches currently in -mm which might be from kas@kernel.org are


