Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3A0381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788001; cv=none; b=jFl4W9Qkw60hszR7CG6zBqTECgc7awUiyGRplL9Te6AdZQjKo2mMiBN2uCIuQNjFBS9GyHOslaRGPI+Fhz5giwebq4zMc+S8GEmDlzhTEb+WZ0diKMX71GJhLAArBtqlp0C4BkRSpGJPL80pTZk0nKKUpuvUitd1Ht/N0SZwcrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788001; c=relaxed/simple;
	bh=BIVG8vW9jErDzc5Zk6S+2bsJmozAdilrhy3+OqegAPk=;
	h=Date:To:From:Subject:Message-Id; b=DyfQPF2l53y8tdpvgUYK3Ucw/M1svddwqCKu9AEFu6PgFPAc3P4f/FPG43ORZfLi9Q4lQbFL5mY60kWnNdSw6CiokfbYlr0E7/uMijwN5+zDMLTUKNaGnn++zRsayMWeJs4U+J7j3hMKD6I2qdskXs52xLZ3J0owjI5tj0DvsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i3oyTVhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i3oyTVhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333DFC433C7;
	Mon, 18 Mar 2024 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788001;
	bh=BIVG8vW9jErDzc5Zk6S+2bsJmozAdilrhy3+OqegAPk=;
	h=Date:To:From:Subject:From;
	b=i3oyTVhkTE159r9E0qpLiBP+9rRYuKCl7E84Vk8I2Kqv8hIhE+LoWbR2DE0aIqFJ7
	 v8/vWBUtJ+q/PY/I3ChKheo/1/Ha/+P9ktCI227S4vlfc1dxghsqGvVw+4Y/KOCidE
	 aaLN9U9AIpRC1gfjvGgPeNLdG016S3fKF6GygagM=
Date: Mon, 18 Mar 2024 11:53:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-the-useless-dma_reserve.patch added to mm-unstable branch
Message-Id: <20240318185321.333DFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove the useless dma_reserve
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-the-useless-dma_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-the-useless-dma_reserve.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove the useless dma_reserve
Date: Mon, 18 Mar 2024 22:21:33 +0800

Patch series "mm/mm_init.c: refactor free_area_init_core()".

In free_area_init_core(), the code calculating zone->managed_pages and the
subtracting dma_reserve from DMA zone looks very confusing.

From git history, the code calculating zone->managed_pages was for
zone->present_pages originally.  The early rough assignment is for
optimize zone's pcp and water mark setting.  Later, managed_pages was
introduced into zone to represent the number of managed pages by buddy. 
Now, zone->managed_pages is zeroed out and reset in mem_init() when
calling memblock_free_all().  zone's pcp and wmark setting relying on
actual zone->managed_pages are done later than mem_init() invocation.  So
we don't need rush to early calculate and set zone->managed_pages, just
set it as zone->present_pages, will adjust it in mem_init().

And also add a new function calc_nr_kernel_pages() to count up free but
not reserved pages in memblock, then assign it to nr_all_pages and
nr_kernel_pages after memmap pages are allocated.


This patch (of 6):

Variable dma_reserve and its usage was introduced in commit 0e0b864e069c
("[PATCH] Account for memmap and optionally the kernel image as holes"). 
Its original purpose was to accounting for the reserved pages in DMA zone
to make DMA zone's watermarks calculation more accurate on x86.

However, currently there's zone->managed_pages to account for all
available pages for buddy, zone->present_pages to account for all present
physical pages in zone.  What is more important, on x86, calculating and
setting the zone->managed_pages is a temporary move, all zone's
managed_pages will be zeroed out and reset to the actual value according
to how many pages are added to buddy allocator in mem_init().  Before
mem_init(), no buddy alloction is requested.  And zone's pcp and watermark
setting are all done after mem_init().  So, no need to worry about the DMA
zone's setting accuracy during free_area_init().

Hence, remove dma_reserve and its handling in free_area_init_core()
because it's useless and causes confusion.

Link: https://lkml.kernel.org/r/20240318142138.783350-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240318142138.783350-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    2 --
 include/linux/mm.h |    1 -
 mm/mm_init.c       |   23 -----------------------
 3 files changed, 26 deletions(-)

--- a/arch/x86/mm/init.c~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/arch/x86/mm/init.c
@@ -1032,8 +1032,6 @@ void __init memblock_find_dma_reserve(vo
 		if (start_pfn < end_pfn)
 			nr_free_pages += end_pfn - start_pfn;
 	}
-
-	set_dma_reserve(nr_pages - nr_free_pages);
 #endif
 }
 
--- a/include/linux/mm.h~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/include/linux/mm.h
@@ -3210,7 +3210,6 @@ static inline int early_pfn_to_nid(unsig
 extern int __meminit early_pfn_to_nid(unsigned long pfn);
 #endif
 
-extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
--- a/mm/mm_init.c~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/mm/mm_init.c
@@ -226,7 +226,6 @@ static unsigned long required_movablecor
 
 static unsigned long nr_kernel_pages __initdata;
 static unsigned long nr_all_pages __initdata;
-static unsigned long dma_reserve __initdata;
 
 static bool deferred_struct_pages __meminitdata;
 
@@ -1583,12 +1582,6 @@ static void __init free_area_init_core(s
 					zone_names[j], memmap_pages, freesize);
 		}
 
-		/* Account for reserved pages */
-		if (j == 0 && freesize > dma_reserve) {
-			freesize -= dma_reserve;
-			pr_debug("  %s zone: %lu pages reserved\n", zone_names[0], dma_reserve);
-		}
-
 		if (!is_highmem_idx(j))
 			nr_kernel_pages += freesize;
 		/* Charge for highmem memmap if there are enough kernel pages */
@@ -2547,22 +2540,6 @@ void *__init alloc_large_system_hash(con
 	return table;
 }
 
-/**
- * set_dma_reserve - set the specified number of pages reserved in the first zone
- * @new_dma_reserve: The number of pages to mark reserved
- *
- * The per-cpu batchsize and zone watermarks are determined by managed_pages.
- * In the DMA zone, a significant percentage may be consumed by kernel image
- * and other unfreeable allocations which can skew the watermarks badly. This
- * function may optionally be used to account for unfreeable pages in the
- * first zone (e.g., ZONE_DMA). The effect will be lower watermarks and
- * smaller per-cpu batchsize.
- */
-void __init set_dma_reserve(unsigned long new_dma_reserve)
-{
-	dma_reserve = new_dma_reserve;
-}
-
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

