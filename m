Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5460C43333
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD3F64F6A
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhBDA6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhBDA6R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E4864F6A;
        Thu,  4 Feb 2021 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612400245;
        bh=tk3rlsETM1LNKvntCw4C/R1CqOqxyUe0FxJt0hzLBwc=;
        h=Date:From:To:Subject:From;
        b=gFxzFp/oqDrK2r4lEwX1cvkbXDp8secisRjx/9WquMr8dqixQIddF3Xhmn97OOtgl
         Yo+P4vkXE6Y3lH0/YJd/qoC8nhFcY9+R9Cf3CsH8cs4dsKK2WMFwykp/ZVVaCQsVkZ
         dtRBJUD5rFDgPjsFakLtwUFyVXbwMmraPF/CwPOg=
Date:   Wed, 03 Feb 2021 16:57:23 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  [to-be-updated]
 mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch removed from -mm
 tree
Message-ID: <20210204005723.7j5nF0Vxe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm cma: rename PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN
has been removed from the -mm tree.  Its filename was
     mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm cma: rename PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN

PF_MEMALLOC_NOCMA is used ot guarantee that the allocator will not return
pages that might belong to CMA region.  This is currently used for long
term gup to make sure that such pins are not going to be done on any CMA
pages.

When PF_MEMALLOC_NOCMA has been introduced we haven't realized that it is
focusing on CMA pages too much and that there is larger class of pages
that need the same treatment.  MOVABLE zone cannot contain any long term
pins as well so it makes sense to reuse and redefine this flag for that
usecase as well.  Rename the flag to PF_MEMALLOC_PIN which defines an
allocation context which can only get pages suitable for long-term pins.

Also re-name:
memalloc_nocma_save()/memalloc_nocma_restore
to
memalloc_pin_save()/memalloc_pin_restore()
and make the new functions common.

Link: https://lkml.kernel.org/r/20210201153827.444374-6-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |    2 +-
 include/linux/sched/mm.h |   21 +++++----------------
 mm/gup.c                 |    4 ++--
 mm/hugetlb.c             |    4 ++--
 mm/page_alloc.c          |    4 ++--
 5 files changed, 12 insertions(+), 23 deletions(-)

--- a/include/linux/sched.h~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin
+++ a/include/linux/sched.h
@@ -1568,7 +1568,7 @@ extern struct pid *cad_pid;
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
-#define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
+#define PF_MEMALLOC_PIN		0x10000000	/* Allocation context constrained to zones which allow long term pinning. */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
--- a/include/linux/sched/mm.h~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin
+++ a/include/linux/sched/mm.h
@@ -270,29 +270,18 @@ static inline void memalloc_noreclaim_re
 	current->flags = (current->flags & ~PF_MEMALLOC) | flags;
 }
 
-#ifdef CONFIG_CMA
-static inline unsigned int memalloc_nocma_save(void)
+static inline unsigned int memalloc_pin_save(void)
 {
-	unsigned int flags = current->flags & PF_MEMALLOC_NOCMA;
+	unsigned int flags = current->flags & PF_MEMALLOC_PIN;
 
-	current->flags |= PF_MEMALLOC_NOCMA;
+	current->flags |= PF_MEMALLOC_PIN;
 	return flags;
 }
 
-static inline void memalloc_nocma_restore(unsigned int flags)
+static inline void memalloc_pin_restore(unsigned int flags)
 {
-	current->flags = (current->flags & ~PF_MEMALLOC_NOCMA) | flags;
+	current->flags = (current->flags & ~PF_MEMALLOC_PIN) | flags;
 }
-#else
-static inline unsigned int memalloc_nocma_save(void)
-{
-	return 0;
-}
-
-static inline void memalloc_nocma_restore(unsigned int flags)
-{
-}
-#endif
 
 #ifdef CONFIG_MEMCG
 DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
--- a/mm/gup.c~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin
+++ a/mm/gup.c
@@ -1662,7 +1662,7 @@ static long __gup_longterm_locked(struct
 	long rc;
 
 	if (gup_flags & FOLL_LONGTERM)
-		flags = memalloc_nocma_save();
+		flags = memalloc_pin_save();
 
 	rc = __get_user_pages_locked(mm, start, nr_pages, pages, vmas, NULL,
 				     gup_flags);
@@ -1671,7 +1671,7 @@ static long __gup_longterm_locked(struct
 		if (rc > 0)
 			rc = check_and_migrate_cma_pages(mm, start, rc, pages,
 							 vmas, gup_flags);
-		memalloc_nocma_restore(flags);
+		memalloc_pin_restore(flags);
 	}
 	return rc;
 }
--- a/mm/hugetlb.c~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin
+++ a/mm/hugetlb.c
@@ -1049,10 +1049,10 @@ static void enqueue_huge_page(struct hst
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 {
 	struct page *page;
-	bool nocma = !!(current->flags & PF_MEMALLOC_NOCMA);
+	bool pin = !!(current->flags & PF_MEMALLOC_PIN);
 
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
-		if (nocma && is_migrate_cma_page(page))
+		if (pin && is_migrate_cma_page(page))
 			continue;
 
 		if (PageHWPoison(page))
--- a/mm/page_alloc.c~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin
+++ a/mm/page_alloc.c
@@ -3813,8 +3813,8 @@ static inline unsigned int current_alloc
 #ifdef CONFIG_CMA
 	unsigned int pflags = current->flags;
 
-	if (!(pflags & PF_MEMALLOC_NOCMA) &&
-			gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (!(pflags & PF_MEMALLOC_PIN) &&
+	    gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 
 #endif
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-do-not-migrate-zero-page-fix.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

