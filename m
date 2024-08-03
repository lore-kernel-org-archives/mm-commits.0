Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F07413B7BC
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722662609; cv=none; b=JqSrp4M+NmIF8Kizxgn9XWSMXrc25UEfQmYSfSkGsQuQBnE8PrFYmv5MaZzGfXWPX/7xcu5gbJ66JQL3ihKW+nXFjW1RXFFxuh+qcuTx/kyxsddZnkR4rJG/AFT9sDvV422oLNr+FJ3nZk63/+MviwSA+I/6rRU8B2hquOBU0zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722662609; c=relaxed/simple;
	bh=J9dioB538myhkTPOPFG9O4l3kxLtLsg4qchR43t8qdk=;
	h=Date:To:From:Subject:Message-Id; b=L0OjJzn88LhUJS4AO1xVnvxU9kJRmM0RRqAmNpZbYb7QIdHQq9Z5CcO3WxOCYQIsgw2N2jjpVEtmWwHWdZneMGveb67/3vkrE+wY9nCMf2bfVyR2dUTqagjAd7+1KdXmOA7dEUjsnJmBFi0spRSk+0x2o0BF5+75D8B9B9/fCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kP/uIJ6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kP/uIJ6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674EFC116B1;
	Sat,  3 Aug 2024 05:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722662608;
	bh=J9dioB538myhkTPOPFG9O4l3kxLtLsg4qchR43t8qdk=;
	h=Date:To:From:Subject:From;
	b=kP/uIJ6bkARAG8nTrA9IGJSMlFSQwUmpXDrzRIs52mvUxFQd/zxZs3NX1pOs7mSye
	 MQrgtuISLXpT4Oi2NUWlj9vz2zha8whgZiIkjR3lB9Tgtp2rhEAWt462YzYgbNxFLc
	 cHu+6ru1DtRo0AayTrkGf4rcimbmJo90yBE2/q+I=
Date: Fri, 02 Aug 2024 22:23:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-increase-totalram_pages-on-freeing-to-buddy-system.patch removed from -mm tree
Message-Id: <20240803052328.674EFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: increase totalram_pages on freeing to buddy system
has been removed from the -mm tree.  Its filename was
     mm-increase-totalram_pages-on-freeing-to-buddy-system.patch

This patch was dropped because it had testing failures

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

