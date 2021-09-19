Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E583BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9F1611F0
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhISXGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhISXGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2961061107;
        Sun, 19 Sep 2021 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632092716;
        bh=KdpBQJQgmktqmZ36Z086cFL+k/0JQ6t9Ec5xZhsEqV4=;
        h=Date:From:To:Subject:From;
        b=vFmHY9ikk++vB4Jynbr0d3wO0HHqaXGe1KbqvdEsgWwNtKiw/4DMwQi6upHkWFz/M
         SD9sp/Tnx70aWd2o235DC0GQGH4QH6eclSkFhpyFHgge+BIvUTZIWcEKEqRj7i41NV
         Nqd46J8Hr0oML2J21vPvwNIsWeb8kfHmxOE3hIsY=
Date:   Sun, 19 Sep 2021 16:05:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        hughd@google.com, aarcange@redhat.com, peterx@redhat.com
Subject:  + mm-smaps-simplify-shmem-handling-of-pte-holes.patch added
 to -mm tree
Message-ID: <20210919230515.-3U3j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: simplify shmem handling of pte holes
has been added to the -mm tree.  Its filename is
     mm-smaps-simplify-shmem-handling-of-pte-holes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-smaps-simplify-shmem-handling-of-pte-holes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-smaps-simplify-shmem-handling-of-pte-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

