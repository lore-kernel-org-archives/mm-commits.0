Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A17C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D0461260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhKKCn2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCn2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D1E610F7;
        Thu, 11 Nov 2021 02:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598439;
        bh=+4M6hlg5SC/d62kuPoccSzy/E1ucO8UtIc4YS/71kLQ=;
        h=Date:From:To:Subject:From;
        b=XwC2nWvIB2SF9z2xkVrDvIt+WzEsM/hLqKEHjAhSnJ6I04aoxIAof/+SwiIRIknOx
         X9CmaWnKWYVJmczsYLjQfB5MPxMpbor7ReRTkELAo9TC6TWSSozI3K+DM8dxp/eQ25
         M7VelY2ZS0S+Mc2+dYH+lBdhGr3PataotNCxAioI=
Date:   Wed, 10 Nov 2021 18:40:39 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-smaps-simplify-shmem-handling-of-pte-holes.patch removed from -mm tree
Message-ID: <20211111024039.BSuj1X9o8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: simplify shmem handling of pte holes
has been removed from the -mm tree.  Its filename was
     mm-smaps-simplify-shmem-handling-of-pte-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: simplify shmem handling of pte holes

Firstly, check_shmem_swap variable is actually not necessary, because it's
always set with pte_hole hook; checking each would work.

Meanwhile, the check within smaps_pte_entry is not easy to follow.  E.g.,
pte_none() check is not needed as "!pte_present && !is_swap_pte" is the
same.  Since at it, use the pte_hole() helper rather than dup the page
cache lookup.

Still keep the CONFIG_SHMEM part so the code can be optimized to nop for !SHMEM.

There will be a very slight functional change in smaps_pte_entry(), that
for !SHMEM we'll return early for pte_none (before checking page==NULL),
but that's even nicer.

Link: https://lkml.kernel.org/r/20210917164756.8586-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/proc/task_mmu.c~mm-smaps-simplify-shmem-handling-of-pte-holes
+++ a/fs/proc/task_mmu.c
@@ -397,7 +397,6 @@ struct mem_size_stats {
 	u64 pss_shmem;
 	u64 pss_locked;
 	u64 swap_pss;
-	bool check_shmem_swap;
 };
 
 static void smaps_page_accumulate(struct mem_size_stats *mss,
@@ -490,6 +489,16 @@ static int smaps_pte_hole(unsigned long
 #define smaps_pte_hole		NULL
 #endif /* CONFIG_SHMEM */
 
+static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
+{
+#ifdef CONFIG_SHMEM
+	if (walk->ops->pte_hole) {
+		/* depth is not used */
+		smaps_pte_hole(addr, addr + PAGE_SIZE, 0, walk);
+	}
+#endif
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -518,12 +527,8 @@ static void smaps_pte_entry(pte_t *pte,
 			}
 		} else if (is_pfn_swap_entry(swpent))
 			page = pfn_swap_entry_to_page(swpent);
-	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
-							&& pte_none(*pte))) {
-		page = xa_load(&vma->vm_file->f_mapping->i_pages,
-						linear_page_index(vma, addr));
-		if (xa_is_value(page))
-			mss->swap += PAGE_SIZE;
+	} else {
+		smaps_pte_hole_lookup(addr, walk);
 		return;
 	}
 
@@ -737,8 +742,6 @@ static void smap_gather_stats(struct vm_
 		return;
 
 #ifdef CONFIG_SHMEM
-	/* In case of smaps_rollup, reset the value from previous vma */
-	mss->check_shmem_swap = false;
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
 		 * For shared or readonly shmem mappings we know that all
@@ -756,7 +759,6 @@ static void smap_gather_stats(struct vm_
 					!(vma->vm_flags & VM_WRITE))) {
 			mss->swap += shmem_swapped;
 		} else {
-			mss->check_shmem_swap = true;
 			ops = &smaps_shmem_walk_ops;
 		}
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are


