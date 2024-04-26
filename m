Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034387E112
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103997; cv=none; b=V3vlLF68ATGb5VYf9aYMnbO4WQE4JcvOoleGdLcVm+j9xA0JLTHytcsSUPyDkPpkP6UhuFn/Q4cpEFAMmERnjhDef8pwS6eusQNIBTYWDAouzU7kEeXp8Now5wjibzolGbZvazgP577Lh/KDgYVjETGgLaIkc4xFeVhbLUx0Tko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103997; c=relaxed/simple;
	bh=feeK0WY5ppLD8VynqK6LJWlmSl7heYrm/m+AmSqCbc0=;
	h=Date:To:From:Subject:Message-Id; b=RZOurT5KPOz+kOqpdK8AlIFcWEW0vM0DHH8a6J1ivW2htgyBmt4pJCR8tXAiZTaUcO+rHimj5KOCR037/i3Wll8ZM/SuTbSUbs5V0oVAmXbN5fDfVhqAazcr9oVr+7sV9IfQ0R9hxFTB0ItFBPZ7DzFC3ks20tTFljcQo4/wz/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kUhxaY1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kUhxaY1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C62C113CD;
	Fri, 26 Apr 2024 03:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103996;
	bh=feeK0WY5ppLD8VynqK6LJWlmSl7heYrm/m+AmSqCbc0=;
	h=Date:To:From:Subject:From;
	b=kUhxaY1yBXpk+Q7hSFEJAnOFifU3A1H4fSI1LHg52DnX7mctbFDgScXkbUqNsgTBO
	 SgRAz8640L0j0LvlqTxBnNi7gZ/+cqyYA9qDPnSAmTVA0WdSK0o0iaS32hoMgCKGDk
	 E3gwUTy64b5vH/aIisfR+7Z8TYe7olOSZdl/Bs1M=
Date: Thu, 25 Apr 2024 20:59:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-the-useless-dma_reserve.patch removed from -mm tree
Message-Id: <20240426035956.C2C62C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove the useless dma_reserve
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-the-useless-dma_reserve.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove the useless dma_reserve
Date: Mon, 25 Mar 2024 22:56:42 +0800

Now nobody calls set_dma_reserve() to set value for dma_reserve, remove
set_dma_reserve(), global variable dma_reserve and the codes using it.

Link: https://lkml.kernel.org/r/20240325145646.1044760-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/mm_init.c       |   23 -----------------------
 2 files changed, 24 deletions(-)

--- a/include/linux/mm.h~mm-mm_initc-remove-the-useless-dma_reserve
+++ a/include/linux/mm.h
@@ -3250,7 +3250,6 @@ static inline int early_pfn_to_nid(unsig
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

