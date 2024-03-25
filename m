Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E207492
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390273; cv=none; b=a3Wh1Zrgr60K6HonArepMqETRuXsGfgKTqCLY7Onx77ckuuc4S2kq5tICih3o5d7E7g+ft84fEz0Bym1vDXsh2B9geuYjygXNsXrVgOP/Zi9KRCRKSSApkfIeASoyLaRSXFXnzFfP1ytIq65PI0eqhoTia5WuU6sKxi14n4x4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390273; c=relaxed/simple;
	bh=mBs4FNiL2PLvLCV17VgjU6mfVeL4XyJTDtmP7w03360=;
	h=Date:To:From:Subject:Message-Id; b=PIf7xp6Sod7luft8uzO/ox7dMAMfDRc8uDDbJH4uxp2As0RQWnyL+rJs695XKAeeGH8x0prZl+gYpI+wBRA60kAtgsb9caZvj7qIWLOea317UNQmlPeSY3x8D2Mb6Ag5YHkaD0YMauXXvmDmOWvaiUgThLs6Xmez+kEEf5VIZ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T+uE+qjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T+uE+qjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC594C433F1;
	Mon, 25 Mar 2024 18:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390272;
	bh=mBs4FNiL2PLvLCV17VgjU6mfVeL4XyJTDtmP7w03360=;
	h=Date:To:From:Subject:From;
	b=T+uE+qjx6pgDHuSS8PGoO3h7RgVu3y1Z6xIjrpJ28as3/6Pq/4ub91GEkuW+Rcgwn
	 QAWHAsT1Cxf+l6DBeEWZXPlmMavSZxV0cLgcCB9VZFzKvTzUO691hT0pacgQG+gCc8
	 AzM7939kolGtlYlWjlbEuIoxDm2btbhuKmLrWD4A=
Date: Mon, 25 Mar 2024 11:11:12 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-the-useless-dma_reserve.patch added to mm-unstable branch
Message-Id: <20240325181112.BC594C433F1@smtp.kernel.org>
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
Date: Mon, 25 Mar 2024 22:56:42 +0800

Now nobody calls set_dma_reserve() to set value for dma_reserve, remove
set_dma_reserve(), global variable dma_reserve and the codes using it.

Link: https://lkml.kernel.org/r/20240325145646.1044760-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/mm_init.c       |   23 -----------------------
 2 files changed, 24 deletions(-)

--- a/include/linux/mm.h~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/include/linux/mm.h
@@ -3247,7 +3247,6 @@ static inline int early_pfn_to_nid(unsig
 extern int __meminit early_pfn_to_nid(unsigned long pfn);
 #endif
 
-extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
--- a/mm/mm_init.c~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/mm/mm_init.c
@@ -227,7 +227,6 @@ static unsigned long required_movablecor
 
 static unsigned long nr_kernel_pages __initdata;
 static unsigned long nr_all_pages __initdata;
-static unsigned long dma_reserve __initdata;
 
 static bool deferred_struct_pages __meminitdata;
 
@@ -1584,12 +1583,6 @@ static void __init free_area_init_core(s
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
@@ -2548,22 +2541,6 @@ void *__init alloc_large_system_hash(con
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

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

