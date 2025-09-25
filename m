Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28651F0E3E;
	Thu, 25 Sep 2025 20:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758833526; cv=none; b=PzCLZeks+sdqZbiTD+y4PHPln+nB+f9zaDt4Csb+fuGwfW0Z0Ws/FZCQZH+83qwgs9EykYvEASFDGu03UKyBtLBQLK3XQNImuUiztlNkK3ibWcVe0n5tvNwoxI82C7xSDfPtm5sVtv1gjmoBCmokEuqF5nM+k9JjeaimP2anlB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758833526; c=relaxed/simple;
	bh=p2L5+UJT0YdCTTP/pmB9NywK79AGoX6XhBkerDxdT+Q=;
	h=Date:To:From:Subject:Message-Id; b=sVigK7U0/rLaRKtP/yW9ISDnYJswUbNeDPcwZD2DQpHxjAlsMYQUIDxzOMeFpVanaKZ9NZofMNN/WebZGpVTiNQdm23dCrLDJZdwUeJcFL8EQRbYaFmA0TmQc+WFfNQbnCbKMSauvYhN2c4DIVmH1vU2fVf2m51TsJGVZJgAD7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSh7/4b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSh7/4b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3036BC4CEF0;
	Thu, 25 Sep 2025 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758833526;
	bh=p2L5+UJT0YdCTTP/pmB9NywK79AGoX6XhBkerDxdT+Q=;
	h=Date:To:From:Subject:From;
	b=FSh7/4b4eSLbophn/swiMtaVtxjJ3OdQ0t5c0M3bQ0lxKCbz7Q2BHtwkObwHB08gk
	 ESpJJnY7WbHtHexQkjKesHXI1kgLonWtZIq6RguazXxgcDZYjXRdhEzmXvaJ7YVU+B
	 N6ANtnXlwMOEOScPo0yCzF1g1P0ezHtKdp6xFu5M=
Date: Thu, 25 Sep 2025 13:52:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,nogikh@google.com,Markus.Elfring@web.de,elver@google.com,dvyukov@google.com,david@redhat.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memblock-correct-totalram_pages-accounting-with-kmsan.patch removed from -mm tree
Message-Id: <20250925205206.3036BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memblock: correct totalram_pages accounting with KMSAN
has been removed from the -mm tree.  Its filename was
     mm-memblock-correct-totalram_pages-accounting-with-kmsan.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm/memblock: correct totalram_pages accounting with KMSAN
Date: Wed, 24 Sep 2025 12:03:01 +0200

When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
for metadata instead of returning them to the early allocator.  The
callers, however, would unconditionally increment `totalram_pages`,
assuming the pages were always freed.  This resulted in an incorrect
calculation of the total available RAM, causing the kernel to believe it
had more memory than it actually did.

This patch refactors `memblock_free_pages()` to return the number of pages
it successfully frees.  If KMSAN stashes the pages, the function now
returns 0; otherwise, it returns the number of pages in the block.

The callers in `memblock.c` have been updated to use this return value,
ensuring that `totalram_pages` is incremented only by the number of pages
actually returned to the allocator.  This corrects the total RAM
accounting when KMSAN is active.

Link: https://lkml.kernel.org/r/20250924100301.1558645-1-glider@google.com
Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 mm/memblock.c |   21 +++++++++++----------
 mm/mm_init.c  |    9 +++++----
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/mm/internal.h~mm-memblock-correct-totalram_pages-accounting-with-kmsan
+++ a/mm/internal.h
@@ -742,8 +742,8 @@ static inline void clear_zone_contiguous
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(struct page *page, unsigned long pfn,
-					unsigned int order);
+unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
+				  unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
 
--- a/mm/memblock.c~mm-memblock-correct-totalram_pages-accounting-with-kmsan
+++ a/mm/memblock.c
@@ -1826,6 +1826,7 @@ void *__init __memblock_alloc_or_panic(p
 void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t cursor, end;
+	unsigned long freed_pages = 0;
 
 	end = base + size - 1;
 	memblock_dbg("%s: [%pa-%pa] %pS\n",
@@ -1834,10 +1835,9 @@ void __init memblock_free_late(phys_addr
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
+	for (; cursor < end; cursor++)
+		freed_pages += memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+	totalram_pages_add(freed_pages);
 }
 
 /*
@@ -2259,9 +2259,11 @@ static void __init free_unused_memmap(vo
 #endif
 }
 
-static void __init __free_pages_memory(unsigned long start, unsigned long end)
+static unsigned long __init __free_pages_memory(unsigned long start,
+						unsigned long end)
 {
 	int order;
+	unsigned long freed = 0;
 
 	while (start < end) {
 		/*
@@ -2279,14 +2281,15 @@ static void __init __free_pages_memory(u
 		while (start + (1UL << order) > end)
 			order--;
 
-		memblock_free_pages(pfn_to_page(start), start, order);
+		freed += memblock_free_pages(pfn_to_page(start), start, order);
 
 		start += (1UL << order);
 	}
+	return freed;
 }
 
 static unsigned long __init __free_memory_core(phys_addr_t start,
-				 phys_addr_t end)
+					       phys_addr_t end)
 {
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = PFN_DOWN(end);
@@ -2297,9 +2300,7 @@ static unsigned long __init __free_memor
 	if (start_pfn >= end_pfn)
 		return 0;
 
-	__free_pages_memory(start_pfn, end_pfn);
-
-	return end_pfn - start_pfn;
+	return __free_pages_memory(start_pfn, end_pfn);
 }
 
 static void __init memmap_init_reserved_pages(void)
--- a/mm/mm_init.c~mm-memblock-correct-totalram_pages-accounting-with-kmsan
+++ a/mm/mm_init.c
@@ -2547,24 +2547,25 @@ void *__init alloc_large_system_hash(con
 	return table;
 }
 
-void __init memblock_free_pages(struct page *page, unsigned long pfn,
-							unsigned int order)
+unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
+					 unsigned int order)
 {
 	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
 		int nid = early_pfn_to_nid(pfn);
 
 		if (!early_page_initialised(pfn, nid))
-			return;
+			return 0;
 	}
 
 	if (!kmsan_memblock_free_pages(page, order)) {
 		/* KMSAN will take care of these pages. */
-		return;
+		return 0;
 	}
 
 	/* pages were reserved and not allocated */
 	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
+	return 1UL << order;
 }
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
_

Patches currently in -mm which might be from glider@google.com are


