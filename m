Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF2A4437
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 01:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388851; cv=none; b=Pw5zriUxfBrWH8AwlJJb12G8pkT5l0Rkm1B7VAwp7OJWjZ9SPyrc3qhuk0YIUXB9hNcHt6Sd8XBBbGU8SiWbrBpHMkmFGqaQkucel2gUOVcK/60RtICZdNPVRrbaDoJ4szpNCGYT1AEHBtP2rfAXyLoF6FPewDf5mEloSE0wYjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388851; c=relaxed/simple;
	bh=MZgKIVYolcpETHog7ZuL30aRMABR1RiQE5wLXqeyWlc=;
	h=Date:To:From:Subject:Message-Id; b=KPYzNspe6XLnnS0aN7zPgvi2BF54Cy+8V+zhvN9wdhZtFrvCXVf562f0rKbrL0GvcHHlNBXIrgKYXASxYLJ2Lfay/0HxCYMWq8gGMiRARjtbkvospTBcfI7sMOyx7w7oAcl6Ja94Nc7N86qqfvW6fE6R7u19V+Cskub7THPwV4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vV3AH2na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vV3AH2na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A000C32782;
	Wed, 31 Jul 2024 01:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722388851;
	bh=MZgKIVYolcpETHog7ZuL30aRMABR1RiQE5wLXqeyWlc=;
	h=Date:To:From:Subject:From;
	b=vV3AH2na5o+BVH4kTt6Ddr0y4QbzFp6hLNLgDENZTri4lTIoXl3YwtFoW3b8IJOQ3
	 arkpLc/VPiUkpkfhuR3Qk8gu8yjVvUPMh5xEizV/nSndH3TKXQMkj8UjjmTizcHRXw
	 Eh5qdeyRoVHad/wceIa3pbAN0HukyKPCFxvr6zUc=
Date: Tue, 30 Jul 2024 18:20:50 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-increase-totalram_pages-on-freeing-to-buddy-system.patch added to mm-unstable branch
Message-Id: <20240731012051.5A000C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: increase totalram_pages on freeing to buddy system
has been added to the -mm mm-unstable branch.  Its filename is
     mm-increase-totalram_pages-on-freeing-to-buddy-system.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-increase-totalram_pages-on-freeing-to-buddy-system.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: increase totalram_pages on freeing to buddy system
Date: Fri, 26 Jul 2024 00:36:12 +0000

Total memory represents pages managed by buddy system.  After the
introduction of DEFERRED_STRUCT_PAGE_INIT, it may count the pages before
being managed.

free_low_memory_core_early() returns number of pages for all free pages,
even at this moment only early initialized pages are freed to buddy
system.  This means the total memory at this moment is not correct.

Let's increase it when pages are freed to buddy system.

Link: https://lkml.kernel.org/r/20240726003612.5578-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c   |   22 ++++++----------------
 mm/page_alloc.c |    4 +---
 2 files changed, 7 insertions(+), 19 deletions(-)

--- a/mm/memblock.c~mm-increase-totalram_pages-on-freeing-to-buddy-system
+++ a/mm/memblock.c
@@ -1711,10 +1711,8 @@ void __init memblock_free_late(phys_addr
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
+	for (; cursor < end; cursor++)
 		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
 }
 
 /*
@@ -2123,7 +2121,7 @@ static void __init __free_pages_memory(u
 	}
 }
 
-static unsigned long __init __free_memory_core(phys_addr_t start,
+static void __init __free_memory_core(phys_addr_t start,
 				 phys_addr_t end)
 {
 	unsigned long start_pfn = PFN_UP(start);
@@ -2131,11 +2129,9 @@ static unsigned long __init __free_memor
 				      PFN_DOWN(end), max_low_pfn);
 
 	if (start_pfn >= end_pfn)
-		return 0;
+		return;
 
 	__free_pages_memory(start_pfn, end_pfn);
-
-	return end_pfn - start_pfn;
 }
 
 static void __init memmap_init_reserved_pages(void)
@@ -2177,9 +2173,8 @@ static void __init memmap_init_reserved_
 	}
 }
 
-static unsigned long __init free_low_memory_core_early(void)
+static void __init free_low_memory_core_early(void)
 {
-	unsigned long count = 0;
 	phys_addr_t start, end;
 	u64 i;
 
@@ -2194,9 +2189,7 @@ static unsigned long __init free_low_mem
 	 */
 	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
 				NULL)
-		count += __free_memory_core(start, end);
-
-	return count;
+		__free_memory_core(start, end);
 }
 
 static int reset_managed_pages_done __initdata;
@@ -2227,13 +2220,10 @@ void __init reset_all_zones_managed_page
  */
 void __init memblock_free_all(void)
 {
-	unsigned long pages;
-
 	free_unused_memmap();
 	reset_all_zones_managed_pages();
 
-	pages = free_low_memory_core_early();
-	totalram_pages_add(pages);
+	free_low_memory_core_early();
 }
 
 /* Keep a table to reserve named memory */
--- a/mm/page_alloc.c~mm-increase-totalram_pages-on-freeing-to-buddy-system
+++ a/mm/page_alloc.c
@@ -1248,16 +1248,14 @@ void __meminit __free_pages_core(struct
 		 * map it first.
 		 */
 		debug_pagealloc_map_pages(page, nr_pages);
-		adjust_managed_page_count(page, nr_pages);
 	} else {
 		for (loop = 0; loop < nr_pages; loop++, p++) {
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
 		}
 
-		/* memblock adjusts totalram_pages() manually. */
-		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
+	adjust_managed_page_count(page, nr_pages);
 
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
mm-increase-totalram_pages-on-freeing-to-buddy-system.patch

