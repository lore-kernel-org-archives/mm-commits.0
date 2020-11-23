Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57493C63798
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 20:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1283020657
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 20:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifGQWgxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgKWUM4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgKWUMz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 15:12:55 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62B3020715;
        Mon, 23 Nov 2020 20:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606162374;
        bh=xxjEnMPhVyU/XvSBhwTLwNANrDpmYhuSzTMGvPvS9CI=;
        h=Date:From:To:Subject:From;
        b=ifGQWgxQRG6eL7DGK5e3VJOU7d02Sn4C0AIxo+N55dyWjQ4dHdYVhKlLWjPdiiptV
         CbYoS2Xyv9RxSz6xOteLvaS7CnQGAglmbWLU5tzyHhN0yy5le7hqjuqG3BxmvSVxi/
         HHZOfAcpGm7bZVm6R42NRzho/dhaj1UlkgjVlUww=
Date:   Mon, 23 Nov 2020 12:12:53 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  [to-be-updated]
 mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch removed from -mm tree
Message-ID: <20201123201253.mVa0UoZA6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,shmem: limit shmem THP alloc gfp_mask
has been removed from the -mm tree.  Its filename was
     mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,thp,shmem: limit shmem THP alloc gfp_mask

Patch series "mm,thp,shm: limit shmem THP alloc gfp_mask".

The allocation flags of anonymous transparent huge pages can be controlled
through the files in /sys/kernel/mm/transparent_hugepage/defrag, which can
help the system from getting bogged down in the page reclaim and
compaction code when many THPs are getting allocated simultaneously.

However, the gfp_mask for shmem THP allocations were not limited by those
configuration settings, and some workloads ended up with all CPUs stuck on
the LRU lock in the page reclaim code, trying to allocate dozens of THPs
simultaneously.

This patch applies the same configurated limitation of THPs to shmem
hugepage allocations, to prevent that from happening.

This way a THP defrag setting of "never" or "defer+madvise" will result in
quick allocation failures without direct reclaim when no 2MB free pages
are available.

With this patch applied, THP allocations for tmpfs will be a little more
aggressive than today for files mmapped with MADV_HUGEPAGE, and a little
less aggressive for files that are not mmapped or mapped without that
flag.


This patch (of 2):

The allocation flags of anonymous transparent huge pages can be controlled
through the files in /sys/kernel/mm/transparent_hugepage/defrag, which can
help the system from getting bogged down in the page reclaim and
compaction code when many THPs are getting allocated simultaneously.

However, the gfp_mask for shmem THP allocations were not limited by those
configuration settings, and some workloads ended up with all CPUs stuck on
the LRU lock in the page reclaim code, trying to allocate dozens of THPs
simultaneously.

This patch applies the same configurated limitation of THPs to shmem
hugepage allocations, to prevent that from happening.

This way a THP defrag setting of "never" or "defer+madvise" will result in
quick allocation failures without direct reclaim when no 2MB free pages
are available.

With this patch applied, THP allocations for tmpfs will be a little more
aggressive than today for files mmapped with MADV_HUGEPAGE, and a little
less aggressive for files that are not mmapped or mapped without that
flag.

Link: https://lkml.kernel.org/r/20201105191508.1961686-1-riel@surriel.com
Link: https://lkml.kernel.org/r/20201105191508.1961686-2-riel@surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 mm/huge_memory.c    |    6 +++---
 mm/shmem.c          |    8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/gfp.h~mmthpshmem-limit-shmem-thp-alloc-gfp_mask
+++ a/include/linux/gfp.h
@@ -614,6 +614,8 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 extern void pm_restrict_gfp_mask(void);
 extern void pm_restore_gfp_mask(void);
 
+extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
+
 #ifdef CONFIG_PM_SLEEP
 extern bool pm_suspended_storage(void);
 #else
--- a/mm/huge_memory.c~mmthpshmem-limit-shmem-thp-alloc-gfp_mask
+++ a/mm/huge_memory.c
@@ -649,9 +649,9 @@ release:
  *	    available
  * never: never stall for any thp allocation
  */
-static inline gfp_t alloc_hugepage_direct_gfpmask(struct vm_area_struct *vma)
+gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma)
 {
-	const bool vma_madvised = !!(vma->vm_flags & VM_HUGEPAGE);
+	const bool vma_madvised = vma && (vma->vm_flags & VM_HUGEPAGE);
 
 	/* Always do synchronous compaction */
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
@@ -743,7 +743,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		}
 		return ret;
 	}
-	gfp = alloc_hugepage_direct_gfpmask(vma);
+	gfp = vma_thp_gfp_mask(vma);
 	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
 	if (unlikely(!page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
--- a/mm/shmem.c~mmthpshmem-limit-shmem-thp-alloc-gfp_mask
+++ a/mm/shmem.c
@@ -1545,8 +1545,8 @@ static struct page *shmem_alloc_hugepage
 		return NULL;
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
-	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-			HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(), true);
+	page = alloc_pages_vma(gfp, HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(),
+			       true);
 	shmem_pseudo_vma_destroy(&pvma);
 	if (page)
 		prep_transhuge_page(page);
@@ -1802,6 +1802,7 @@ static int shmem_getpage_gfp(struct inod
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
 	pgoff_t hindex = index;
+	gfp_t huge_gfp;
 	int error;
 	int once = 0;
 	int alloced = 0;
@@ -1887,7 +1888,8 @@ repeat:
 	}
 
 alloc_huge:
-	page = shmem_alloc_and_acct_page(gfp, inode, index, true);
+	huge_gfp = vma_thp_gfp_mask(vma);
+	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
 	if (IS_ERR(page)) {
 alloc_nohuge:
 		page = shmem_alloc_and_acct_page(gfp, inode,
_

Patches currently in -mm which might be from riel@surriel.com are

mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch

