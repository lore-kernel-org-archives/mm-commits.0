Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527A4C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B31861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhEHWsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E10613E8;
        Sat,  8 May 2021 22:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514054;
        bh=Bc1ASf11bK16s9fdEohwsQgeUlqRjawwPAOLV0NVMVk=;
        h=Date:From:To:Subject:From;
        b=DqGEgxHB1GQ/nDAs8EA8Ts+Mw1HZYJsGM+hj2z/+VlS9bFU/bA/w2gGQvInls/Xu1
         rKGxseTBmASP2APZR3RHH6Lkv+jRSzmc3Gm/PxTiMNC3z0NYSVg3VEhksNCUEAjHGX
         moVhe2gsE1Nslf8sPcLnP3KV1J4UnahO4deSKGBg=
Date:   Sat, 08 May 2021 15:47:33 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.ibm.com,
        david@redhat.com, guro@fb.com, hdanton@sina.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, longman@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, peterz@infradead.org,
        rientjes@google.com, shakeelb@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        will@kernel.org, willy@infradead.org
Subject:  [merged]
 hugetlb-create-remove_hugetlb_page-to-separate-functionality.patch removed
 from -mm tree
Message-ID: <20210508224733.2L8q8P151%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: create remove_hugetlb_page() to separate functionality
has been removed from the -mm tree.  Its filename was
     hugetlb-create-remove_hugetlb_page-to-separate-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: create remove_hugetlb_page() to separate functionality

The new remove_hugetlb_page() routine is designed to remove a hugetlb page
from hugetlbfs processing.  It will remove the page from the active or
free list, update global counters and set the compound page destructor to
NULL so that PageHuge() will return false for the 'page'.  After this
call, the 'page' can be treated as a normal compound page or a collection
of base size pages.

update_and_free_page no longer decrements h->nr_huge_pages{_node} as this
is performed in remove_hugetlb_page.  The only functionality performed by
update_and_free_page is to free the base pages to the lower level
allocators.

update_and_free_page is typically called after remove_hugetlb_page.

remove_hugetlb_page is to be called with the hugetlb_lock held.

Creating this routine and separating functionality is in preparation for
restructuring code to reduce lock hold times.  This commit should not
introduce any changes to functionality.

Link: https://lkml.kernel.org/r/20210409205254.242291-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   65 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

--- a/mm/hugetlb.c~hugetlb-create-remove_hugetlb_page-to-separate-functionality
+++ a/mm/hugetlb.c
@@ -1333,6 +1333,41 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
+/*
+ * Remove hugetlb page from lists, and update dtor so that page appears
+ * as just a compound page.  A reference is held on the page.
+ *
+ * Must be called with hugetlb lock held.
+ */
+static void remove_hugetlb_page(struct hstate *h, struct page *page,
+							bool adjust_surplus)
+{
+	int nid = page_to_nid(page);
+
+	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
+	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
+
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+		return;
+
+	list_del(&page->lru);
+
+	if (HPageFreed(page)) {
+		h->free_huge_pages--;
+		h->free_huge_pages_node[nid]--;
+	}
+	if (adjust_surplus) {
+		h->surplus_huge_pages--;
+		h->surplus_huge_pages_node[nid]--;
+	}
+
+	set_page_refcounted(page);
+	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
+
+	h->nr_huge_pages--;
+	h->nr_huge_pages_node[nid]--;
+}
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
@@ -1341,8 +1376,6 @@ static void update_and_free_page(struct
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
-	h->nr_huge_pages--;
-	h->nr_huge_pages_node[page_to_nid(page)]--;
 	for (i = 0; i < pages_per_huge_page(h);
 	     i++, subpage = mem_map_next(subpage, page, i)) {
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
@@ -1350,10 +1383,6 @@ static void update_and_free_page(struct
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);
 	}
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
-	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
-	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
@@ -1421,15 +1450,12 @@ static void __free_huge_page(struct page
 		h->resv_huge_pages++;
 
 	if (HPageTemporary(page)) {
-		list_del(&page->lru);
-		ClearHPageTemporary(page);
+		remove_hugetlb_page(h, page, false);
 		update_and_free_page(h, page);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
-		list_del(&page->lru);
+		remove_hugetlb_page(h, page, true);
 		update_and_free_page(h, page);
-		h->surplus_huge_pages--;
-		h->surplus_huge_pages_node[nid]--;
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
@@ -1714,13 +1740,7 @@ static int free_pool_huge_page(struct hs
 			struct page *page =
 				list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
-			list_del(&page->lru);
-			h->free_huge_pages--;
-			h->free_huge_pages_node[node]--;
-			if (acct_surplus) {
-				h->surplus_huge_pages--;
-				h->surplus_huge_pages_node[node]--;
-			}
+			remove_hugetlb_page(h, page, acct_surplus);
 			update_and_free_page(h, page);
 			ret = 1;
 			break;
@@ -1758,7 +1778,6 @@ retry:
 	if (!page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
-		int nid = page_to_nid(head);
 		if (h->free_huge_pages - h->resv_huge_pages == 0)
 			goto out;
 
@@ -1789,9 +1808,7 @@ retry:
 			SetPageHWPoison(page);
 			ClearPageHWPoison(head);
 		}
-		list_del(&head->lru);
-		h->free_huge_pages--;
-		h->free_huge_pages_node[nid]--;
+		remove_hugetlb_page(h, page, false);
 		h->max_huge_pages--;
 		update_and_free_page(h, head);
 		rc = 0;
@@ -2558,10 +2575,8 @@ static void try_to_free_low(struct hstat
 				return;
 			if (PageHighMem(page))
 				continue;
-			list_del(&page->lru);
+			remove_hugetlb_page(h, page, false);
 			update_and_free_page(h, page);
-			h->free_huge_pages--;
-			h->free_huge_pages_node[page_to_nid(page)]--;
 		}
 	}
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


