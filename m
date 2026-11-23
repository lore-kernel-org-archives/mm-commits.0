Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403074;
	b=MVICfuPqv/iMlUEg/bqQir2oXkwjktrWuqRM7OamMvubQacsbvvX6GczlHScRdteVvGh
	 fjwa70Dclvc25plP1wXhxSS3x11AbYs6VRajIONXck5v0XPLUhCdaT3AmwAVTxBvPhNc2
	 M2yJYH509Co1XuljzUESYR4dlV3UaaK30avuQFa7193RBnCBMc+zFfHikGVxVa2qFZ2kA
	 NaWaDwRcPdHYPzIlEZK7ugWB2FvKGW9krX/gfJYQ1gJtxOiWB9BDYv026brRc4qyascZZ
	 AAjn6bCe8b/jmt0ySDYhEDfY8vPAhtpR20P7rqp8MUVGrrsOF2+G91u/8e+Tu4SPcFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403074;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=rcOSuwXrbf+F2uCaa1NfrKKOgZIkAbiNMtFP84mQxGQ=;
	b=UG3XOHiVgBgrWKiOh/I8/SspOyxkeTLUc+nwQlslvxXTgACzdJfdMVRkTL5x0jqoVFN5
	 hfGA/DZXfQMDN2KFOpzQaVQPe09wKawvsJOkOxIg4V12AXSlojAXK2wkEj0t45FvkzmqD
	 Vbp0SKqviePjVZ69i0R0rM/viYVLD3mu+rYSqkiH6KpWBdiwGAb/TUyNCXaD07aMqSAec
	 Rp6t3y+/zOkpY3rn73L38wLvsazbaP7sVqNlYwizF/7Al2+nD5a8o4kGFymRJcRKMD1Fm
	 UX0LrZ9/riO4prVr9SyVQHEKkKmMsI09wPSu4bLkNze3vm4JeeGnqSLtPMZRr2z6e5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tQsewlCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD12606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tQsewlCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC71F000C0;
	Mon, 23 Nov 2026 03:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403073;
	bh=rcOSuwXrbf+F2uCaa1NfrKKOgZIkAbiNMtFP84mQxGQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=tQsewlCgZqCP3DRGAELV57JOlzUZ1y87AV4Hd8BkRBtSMbfSqKHyQM4RW/19zmh4Y
	 t5YT4cGwaehnbfUnURbEHRWFim9WsqAWNidMvVCMbtQ7yhKGRjG3KLgv3vzmTU/Hlz
	 7R40+nEbmy6X1rO07NE7ojNjfPLn890CUsA2dY4Q=
Date: Sun, 22 Nov 2026 19:04:33 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-12-songmuchun@bytedance.com>
References: <20261120100856.16929-12-songmuchun@bytedance.com>
Subject: + mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch added to mm-new branch
Message-Id: <20261123030433.93FC71F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: move pageblock migratetype init to memmap helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: move pageblock migratetype init to memmap helpers
Date: Fri, 20 Nov 2026 18:08:56 +0800

ZONE_DEVICE memmap initialization already initializes pageblock
migratetype after all struct pages have been initialized, while hugetlb
bootmem folios have their own duplicate bootmem-specific initialization.

Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
initialization helpers instead, so the ZONE_DEVICE and hugetlb bootmem
paths can share the same initialization.

The old hugetlb_bootmem_init_migratetype() skipped CMA folios via
folio_test_hugetlb_cma(), but the shared helper always initializes
pageblocks as MIGRATE_MOVABLE. This is safe because cma_activate_area()
later overrides the migratetype for CMA pageblocks.

Link: https://patch.msgid.link/20261120100856.16929-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/hugetlb.c |   25 -------------------------
 mm/mm_init.c |   11 ++++++-----
 2 files changed, 6 insertions(+), 30 deletions(-)

--- a/mm/hugetlb.c~mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers
+++ a/mm/hugetlb.c
@@ -3319,30 +3319,6 @@ static bool __init alloc_bootmem_huge_pa
 	return true;
 }
 
-/*
- * memblock-allocated pageblocks might not have the migrate type set
- * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
- * here, or MIGRATE_CMA if this was a page allocated through an early CMA
- * reservation.
- *
- * In case of vmemmap optimized folios, the tail vmemmap pages are mapped
- * read-only, but that's ok - for sparse vmemmap this does not write to
- * the page structure.
- */
-static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
-							  struct hstate *h)
-{
-	unsigned long nr_pages = pages_per_huge_page(h), i;
-
-	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
-
-	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (!folio_test_hugetlb_cma(folio))
-			init_pageblock_migratetype(folio_page(folio, i),
-					  MIGRATE_MOVABLE, false);
-	}
-}
-
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
 					struct list_head *folio_list)
 {
@@ -3350,7 +3326,6 @@ static void __init prep_and_add_bootmem_
 	struct folio *folio, *tmp_f;
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		account_new_hugetlb_folio(h, folio);
--- a/mm/mm_init.c~mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers
+++ a/mm/mm_init.c
@@ -757,6 +757,9 @@ void __meminit memmap_init_compound_page
 	for (unsigned long i = 1; i < nr_pages; i++)
 		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
 	prep_compound_head(head, order);
+
+	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
@@ -1110,6 +1113,9 @@ static void memmap_init_zone_device_page
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
+
+	pageblock_migratetype_init_range(start, end - start, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1147,13 +1153,8 @@ void __ref memmap_init_zone_device(struc
 
 		memmap_init_compound_page(head, pfn, zone, pgmap->vmemmap_shift);
 		memmap_init_zone_device_folio(page_folio(head), pgmap);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
-			cond_resched();
 	}
 out:
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
-					 /* isolate */ false, /* atomic */ false);
-
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

