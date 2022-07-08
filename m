Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8EBC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbiGHVEp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbiGHVEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A07E2B196
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159A5628E1
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604D9C341C0;
        Fri,  8 Jul 2022 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314278;
        bh=2IN2i50CtUQPyigvB0EDjDCAFe8dpio0gas/I1tQAAY=;
        h=Date:To:From:Subject:From;
        b=qF02uVOM77T19sszrLqYrNJU8jD4N6gonSHMQh1Mt7PCouUGPFppBsgbKktzKuzMd
         CxjFwJCjRb3F1UQwA8lyn0+ABHcD7s2iHa7J5vMzXgjUP3e8hz6pmTeQNrJgTVrW7n
         I+1EpIx7Dyfgaq8w9zn3FtY5Ff8nofnpjakkeOdk=
Date:   Fri, 08 Jul 2022 14:04:37 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, ziy@nvidia.com,
        willy@infradead.org, vbabka@suse.cz, tsbogend@alpha.franken.de,
        songliubraving@fb.com, sj@kernel.org,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        mhocko@suse.com, mattst88@gmail.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        ckennelly@google.com, chris@zankel.net, axelrasmussen@google.com,
        axboe@kernel.dk, asml.silence@gmail.com, arnd@arndb.de,
        alex.shi@linux.alibaba.com, aarcange@redhat.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch added to mm-unstable branch
Message-Id: <20220708210438.604D9C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA
Date: Wed, 6 Jul 2022 16:59:20 -0700

The khugepaged has optimization to reduce huge page allocation calls for
!CONFIG_NUMA by carrying the allocated but failed to collapse huge page to
the next loop.  CONFIG_NUMA doesn't do so since the next loop may try to
collapse huge page from a different node, so it doesn't make too much
sense to carry it.

But when NUMA=n, the huge page is allocated by khugepaged_prealloc_page()
before scanning the address space, so it means huge page may be allocated
even though there is no suitable range for collapsing.  Then the page
would be just freed if khugepaged already made enough progress.  This
could make NUMA=n run have 5 times as much thp_collapse_alloc as NUMA=y
run.  This problem actually makes things worse due to the way more
pointless THP allocations and makes the optimization pointless.

This could be fixed by carrying the huge page across scans, but it will
complicate the code further and the huge page may be carried indefinitely.
But if we take one step back, the optimization itself seems not worth
keeping nowadays since:

  * Not too many users build NUMA=n kernel nowadays even though the kernel is
    actually running on a non-NUMA machine. Some small devices may run NUMA=n
    kernel, but I don't think they actually use THP.
  * Since commit 44042b449872 ("mm/page_alloc: allow high-order pages to be
    stored on the per-cpu lists"), THP could be cached by pcp.  This actually
    somehow does the job done by the optimization.

Link: https://lkml.kernel.org/r/20220706235936.2197195-3-zokeefe@google.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Co-developed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  120 +++++++++-------------------------------------
 1 file changed, 26 insertions(+), 94 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa
+++ a/mm/khugepaged.c
@@ -796,29 +796,16 @@ static int khugepaged_find_target_node(v
 	last_khugepaged_target_node = target_node;
 	return target_node;
 }
-
-static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
+#else
+static int khugepaged_find_target_node(void)
 {
-	if (IS_ERR(*hpage)) {
-		if (!*wait)
-			return false;
-
-		*wait = false;
-		*hpage = NULL;
-		khugepaged_alloc_sleep();
-	} else if (*hpage) {
-		put_page(*hpage);
-		*hpage = NULL;
-	}
-
-	return true;
+	return 0;
 }
+#endif
 
 static struct page *
 khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
-	VM_BUG_ON_PAGE(*hpage, *hpage);
-
 	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
@@ -830,74 +817,6 @@ khugepaged_alloc_page(struct page **hpag
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return *hpage;
 }
-#else
-static int khugepaged_find_target_node(void)
-{
-	return 0;
-}
-
-static inline struct page *alloc_khugepaged_hugepage(void)
-{
-	struct page *page;
-
-	page = alloc_pages(alloc_hugepage_khugepaged_gfpmask(),
-			   HPAGE_PMD_ORDER);
-	if (page)
-		prep_transhuge_page(page);
-	return page;
-}
-
-static struct page *khugepaged_alloc_hugepage(bool *wait)
-{
-	struct page *hpage;
-
-	do {
-		hpage = alloc_khugepaged_hugepage();
-		if (!hpage) {
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-			if (!*wait)
-				return NULL;
-
-			*wait = false;
-			khugepaged_alloc_sleep();
-		} else
-			count_vm_event(THP_COLLAPSE_ALLOC);
-	} while (unlikely(!hpage) && likely(hugepage_flags_enabled()));
-
-	return hpage;
-}
-
-static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
-{
-	/*
-	 * If the hpage allocated earlier was briefly exposed in page cache
-	 * before collapse_file() failed, it is possible that racing lookups
-	 * have not yet completed, and would then be unpleasantly surprised by
-	 * finding the hpage reused for the same mapping at a different offset.
-	 * Just release the previous allocation if there is any danger of that.
-	 */
-	if (*hpage && page_count(*hpage) > 1) {
-		put_page(*hpage);
-		*hpage = NULL;
-	}
-
-	if (!*hpage)
-		*hpage = khugepaged_alloc_hugepage(wait);
-
-	if (unlikely(!*hpage))
-		return false;
-
-	return true;
-}
-
-static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
-{
-	VM_BUG_ON(!*hpage);
-
-	return  *hpage;
-}
-#endif
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
@@ -1148,8 +1067,10 @@ static void collapse_huge_page(struct mm
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
-	if (!IS_ERR_OR_NULL(*hpage))
+	if (!IS_ERR_OR_NULL(*hpage)) {
 		mem_cgroup_uncharge(page_folio(*hpage));
+		put_page(*hpage);
+	}
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
 }
@@ -1951,8 +1872,10 @@ xa_unlocked:
 	unlock_page(new_page);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (!IS_ERR_OR_NULL(*hpage))
+	if (!IS_ERR_OR_NULL(*hpage)) {
 		mem_cgroup_uncharge(page_folio(*hpage));
+		put_page(*hpage);
+	}
 	/* TODO: tracepoints */
 }
 
@@ -2197,10 +2120,7 @@ static void khugepaged_do_scan(void)
 
 	lru_add_drain_all();
 
-	while (progress < pages) {
-		if (!khugepaged_prealloc_page(&hpage, &wait))
-			break;
-
+	while (true) {
 		cond_resched();
 
 		if (unlikely(kthread_should_stop() || try_to_freeze()))
@@ -2216,10 +2136,22 @@ static void khugepaged_do_scan(void)
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
-	}
 
-	if (!IS_ERR_OR_NULL(hpage))
-		put_page(hpage);
+		if (progress >= pages)
+			break;
+
+		if (IS_ERR(hpage)) {
+			/*
+			 * If fail to allocate the first time, try to sleep for
+			 * a while.  When hit again, cancel the scan.
+			 */
+			if (!wait)
+				break;
+			wait = false;
+			hpage = NULL;
+			khugepaged_alloc_sleep();
+		}
+	}
 }
 
 static bool khugepaged_should_wakeup(void)
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch
mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

