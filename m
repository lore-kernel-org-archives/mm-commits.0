Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41F1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D40F64F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBZBRY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhBZBRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC1864F1A;
        Fri, 26 Feb 2021 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302179;
        bh=7Q7zXOjBLagrAkppOwnPAk7H29oboLMVLZy8Bs9EnhQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tSHLU3YpKHTdR6qDeBZCHo4tC6qopiNZLhEFlHSZtoiG9UAUv13LdvTj3HjCbX7aV
         o0bPYUnTFbK3QAims7IMwFwBa2Kaq2s5v9xOKC5qi7DUcD9xbnbNjMyKNFaxWGwERp
         gR7W8z6AJ+pbzHgrFHNL1SiEluCuI3v9PccZ5bCg=
Date:   Thu, 25 Feb 2021 17:16:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  [patch 015/118] mm,thp,shmem: limit shmem THP alloc
 gfp_mask
Message-ID: <20210226011618.Zp8Iu_dhE%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rik van Riel <riel@surriel.com>
Subject: mm,thp,shmem: limit shmem THP alloc gfp_mask

Patch series "mm,thp,shm: limit shmem THP alloc gfp_mask", v6.

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


This patch (of 4):

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

Controlling the gfp_mask of THP allocations through the knobs in sysfs
allows users to determine the balance between how aggressively the system
tries to allocate THPs at fault time, and how much the application may end
up stalling attempting those allocations.

This way a THP defrag setting of "never" or "defer+madvise" will result in
quick allocation failures without direct reclaim when no 2MB free pages
are available.

With this patch applied, THP allocations for tmpfs will be a little more
aggressive than today for files mmapped with MADV_HUGEPAGE, and a little
less aggressive for files that are not mmapped or mapped without that
flag.

Link: https://lkml.kernel.org/r/20201124194925.623931-1-riel@surriel.com
Link: https://lkml.kernel.org/r/20201124194925.623931-2-riel@surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 mm/huge_memory.c    |    6 +++---
 mm/shmem.c          |    8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/gfp.h~mmthpshmem-limit-shmem-thp-alloc-gfp_mask
+++ a/include/linux/gfp.h
@@ -634,6 +634,8 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 extern void pm_restrict_gfp_mask(void);
 extern void pm_restore_gfp_mask(void);
 
+extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
+
 #ifdef CONFIG_PM_SLEEP
 extern bool pm_suspended_storage(void);
 #else
--- a/mm/huge_memory.c~mmthpshmem-limit-shmem-thp-alloc-gfp_mask
+++ a/mm/huge_memory.c
@@ -668,9 +668,9 @@ release:
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
@@ -762,7 +762,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
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
@@ -1519,8 +1519,8 @@ static struct page *shmem_alloc_hugepage
 		return NULL;
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
-	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-			HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(), true);
+	page = alloc_pages_vma(gfp, HPAGE_PMD_ORDER, &pvma, 0, numa_node_id(),
+			       true);
 	shmem_pseudo_vma_destroy(&pvma);
 	if (page)
 		prep_transhuge_page(page);
@@ -1776,6 +1776,7 @@ static int shmem_getpage_gfp(struct inod
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
 	pgoff_t hindex = index;
+	gfp_t huge_gfp;
 	int error;
 	int once = 0;
 	int alloced = 0;
@@ -1862,7 +1863,8 @@ repeat:
 	}
 
 alloc_huge:
-	page = shmem_alloc_and_acct_page(gfp, inode, index, true);
+	huge_gfp = vma_thp_gfp_mask(vma);
+	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
 	if (IS_ERR(page)) {
 alloc_nohuge:
 		page = shmem_alloc_and_acct_page(gfp, inode,
_
