Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8667C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CE622D37
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbhAXBd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbhAXBdt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:33:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E9A22D37;
        Sun, 24 Jan 2021 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451989;
        bh=rNwQBFC0rhgcIO/XFarxHoIeN607XmE7MAxUosNXatc=;
        h=Date:From:To:Subject:From;
        b=viLOTytGgLMLwA8XOfcc5PTgvsY8AKk2ed7ynv/mo4kGHcF0CNkewOi/Ge2F35uym
         G8JKPQggldR4s/AlrdD5UQY0hol7YItP6+feFx40F73yJUr7uv2xLChJmVH7d6xlwC
         3y2jVr31swR6fY/5rzK272YuaDt/KOdH4MAXuAcI=
Date:   Sat, 23 Jan 2021 17:33:06 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  + hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
 added to -mm tree
Message-ID: <20210124013306.-MRpW2tvE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: convert PageHugeFreed to HPageFreed flag
has been added to the -mm tree.  Its filename is
     hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: convert PageHugeFreed to HPageFreed flag

Use new hugetlb specific HPageFreed flag to replace the PageHugeFreed
interfaces.

Link: https://lkml.kernel.org/r/20210122195231.324857-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   23 ++++-------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-convert-pagehugefreed-to-hpagefreed-flag
+++ a/include/linux/hugetlb.h
@@ -487,11 +487,13 @@ unsigned long hugetlb_get_unmapped_area(
  *	allocator.  Typically used for migration target pages when no pages
  *	are available in the pool.  The hugetlb free page path will
  *	immediately free pages with this flag set to the buddy allocator.
+ * HPG_freed - Set when page is on the free lists.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve = 0,
 	HPG_migratable,
 	HPG_temporary,
+	HPG_freed,
 	__NR_HPAGEFLAGS,
 };
 
@@ -536,6 +538,7 @@ static inline void ClearHPage##uname(str
 HPAGEFLAG(RestoreReserve, restore_reserve)
 HPAGEFLAG(Migratable, migratable)
 HPAGEFLAG(Temporary, temporary)
+HPAGEFLAG(Freed, freed)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
--- a/mm/hugetlb.c~hugetlb-convert-pagehugefreed-to-hpagefreed-flag
+++ a/mm/hugetlb.c
@@ -79,21 +79,6 @@ DEFINE_SPINLOCK(hugetlb_lock);
 static int num_fault_mutexes;
 struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
-static inline bool PageHugeFreed(struct page *head)
-{
-	return page_private(head + 4) == -1UL;
-}
-
-static inline void SetPageHugeFreed(struct page *head)
-{
-	set_page_private(head + 4, -1UL);
-}
-
-static inline void ClearPageHugeFreed(struct page *head)
-{
-	set_page_private(head + 4, 0);
-}
-
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
@@ -1043,7 +1028,7 @@ static void enqueue_huge_page(struct hst
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
-	SetPageHugeFreed(page);
+	SetHPageFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1060,7 +1045,7 @@ static struct page *dequeue_huge_page_no
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
-		ClearPageHugeFreed(page);
+		ClearHPageFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		return page;
@@ -1474,7 +1459,7 @@ static void prep_new_huge_page(struct hs
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
-	ClearPageHugeFreed(page);
+	ClearHPageFreed(page);
 	spin_unlock(&hugetlb_lock);
 }
 
@@ -1747,7 +1732,7 @@ retry:
 		 * We should make sure that the page is already on the free list
 		 * when it is dissolved.
 		 */
-		if (unlikely(!PageHugeFreed(head))) {
+		if (unlikely(!HPageFreed(head))) {
 			spin_unlock(&hugetlb_lock);
 			cond_resched();
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-only-set-hpagemigratable-for-migratable-hstates.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

