Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635C4C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27EAA64E09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhBXUKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhBXUJq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0412964E24;
        Wed, 24 Feb 2021 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197345;
        bh=QC0AIZ6aUxbhZZgviX5mx6Iepg59j3OqAEvMZ48Jxcs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NMYp21prKFxsZPE19g44nbOMSNdYhaxiJAVU+bEtNwp0DCROfZWWw60fFpJVk/s90
         rroG9i5Vc0mpMzu1YT8oxiObU8tlZGMebINdtlOrytwvBPBzn52DW0wIAPWCzmZcak
         qlBrxMa9BI6WGlZTPA6ErlodsB+XCTE11K5SEPko=
Date:   Wed, 24 Feb 2021 12:09:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 149/173] hugetlb: convert PageHugeFreed to
 HPageFreed flag
Message-ID: <20210224200904.e6JwA1acj%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: convert PageHugeFreed to HPageFreed flag

Use new hugetlb specific HPageFreed flag to replace the PageHugeFreed
interfaces.

Link: https://lkml.kernel.org/r/20210122195231.324857-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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
 
@@ -1053,7 +1038,7 @@ static void enqueue_huge_page(struct hst
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
-	SetPageHugeFreed(page);
+	SetHPageFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1070,7 +1055,7 @@ static struct page *dequeue_huge_page_no
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
-		ClearPageHugeFreed(page);
+		ClearHPageFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		return page;
@@ -1485,7 +1470,7 @@ static void prep_new_huge_page(struct hs
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
-	ClearPageHugeFreed(page);
+	ClearHPageFreed(page);
 	spin_unlock(&hugetlb_lock);
 }
 
@@ -1756,7 +1741,7 @@ retry:
 		 * We should make sure that the page is already on the free list
 		 * when it is dissolved.
 		 */
-		if (unlikely(!PageHugeFreed(head))) {
+		if (unlikely(!HPageFreed(head))) {
 			spin_unlock(&hugetlb_lock);
 			cond_resched();
 
_
