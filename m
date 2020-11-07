Return-Path: <SRS0=9IPz=EN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A03C388F7
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 05:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B1E20888
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 05:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604726266;
	bh=2kg6O41H5vRQubITzir/LDMusMsxfDgGjnRaQvjunHo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pKmAj79AMrRYGB326iPognFz4vgz3DpZq9PIDFIJc6ntM3Xhzz0dBeEWaBeo/smhf
	 xwCLkEpk9cP495E9JjybrLToIwHuOxcY1uL3akmZI1sUAUMyyMbG9asaJcbpl7zca5
	 KPBVCMo1tvuZZz2ZvZUmTkwr2w0PctQBC5OXfv30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgKGFRq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 00:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgKGFRq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 00:17:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 263C720872;
        Sat,  7 Nov 2020 05:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604726265;
        bh=2kg6O41H5vRQubITzir/LDMusMsxfDgGjnRaQvjunHo=;
        h=Date:From:To:Subject:From;
        b=xqLWahuh+1ixRuYHjVaBXTs7tWk5ujGDza6lD4S1O6KeynQmPiRcOW1LPs+I+Butc
         3NXzY3orlj5LG1JH2WXv/eOVSj4yIACTSO2TxjG04ZQ+E/35t+YhoH5XFznyF3Do1Z
         CJ6HV1l9BEyEvq+M+sU84JB/qhAwFlSvwhMzNe0I=
Date:   Fri, 06 Nov 2020 21:17:44 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  + mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch added
 to -mm tree
Message-ID: <20201107051744.qATV_ohoR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,shmem: limit shmem THP alloc gfp_mask
has been added to the -mm tree.  Its filename is
     mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -744,7 +744,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 			pte_free(vma->vm_mm, pgtable);
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

mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch
mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch

