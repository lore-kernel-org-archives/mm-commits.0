Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A066DC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5636125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhKEUiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232987AbhKEUiq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60F43611EE;
        Fri,  5 Nov 2021 20:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144566;
        bh=yLA0kwAv/1UTmsV1tgpDpmVs8y0uomeZVun4V7iw8pg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bKOHh8tlmaoCSWaWJs/U3mb1IfFB1367Z2/1LUAgELqzzy5LiPyfFhBj0r9WMRZ/6
         APAphjidByIPQgdnsi2GjFge2Jum3T9vwPfuVeYtuJ8/LMANQO0IJmwS5qVyMmgqPw
         DT4AYgAjQiKbivURVH7o6gMbN+C2zZ80+QBwafGA=
Date:   Fri, 05 Nov 2021 13:36:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 029/262] mm/smaps: simplify shmem handling of pte
 holes
Message-ID: <20211105203605.TfGCVx9PE%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
