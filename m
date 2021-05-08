Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFA4C43462
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A05761426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDCAE61402;
        Sat,  8 May 2021 22:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514056;
        bh=g/4oELSQFOb1I9MSRnzuJprU9oZcoufDPRPsutfTFVE=;
        h=Date:From:To:Subject:From;
        b=tmjnWOydILbX4jATlTG+MhlcHzB1Ol9UFc9nxwQ3e1Q/rCVMcrd3pnF92h/3RZ/lX
         0NIA8Vh1v9BsI9VtSIVcaQ+evqzEQ0KSmPZJ7jvWxAS3p07t6n5eXkxcNwc/m5Bqft
         8igjnZbrE/tKIT6MnjHgVOWbcPoksEwst5sR4zxE=
Date:   Sat, 08 May 2021 15:47:35 -0700
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
 hugetlb-call-update_and_free_page-without-hugetlb_lock.patch removed from
 -mm tree
Message-ID: <20210508224735.J3Ga2XHJo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: call update_and_free_page without hugetlb_lock
has been removed from the -mm tree.  Its filename was
     hugetlb-call-update_and_free_page-without-hugetlb_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: call update_and_free_page without hugetlb_lock

With the introduction of remove_hugetlb_page(), there is no need for
update_and_free_page to hold the hugetlb lock.  Change all callers to drop
the lock before calling.

With additional code modifications, this will allow loops which decrease
the huge page pool to drop the hugetlb_lock with each page to reduce long
hold times.

The ugly unlock/lock cycle in free_pool_huge_page will be removed in a
subsequent patch which restructures free_pool_huge_page.

Link: https://lkml.kernel.org/r/20210409205254.242291-6-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
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

 mm/hugetlb.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-call-update_and_free_page-without-hugetlb_lock
+++ a/mm/hugetlb.c
@@ -1451,16 +1451,18 @@ static void __free_huge_page(struct page
 
 	if (HPageTemporary(page)) {
 		remove_hugetlb_page(h, page, false);
+		spin_unlock(&hugetlb_lock);
 		update_and_free_page(h, page);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		remove_hugetlb_page(h, page, true);
+		spin_unlock(&hugetlb_lock);
 		update_and_free_page(h, page);
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
+		spin_unlock(&hugetlb_lock);
 	}
-	spin_unlock(&hugetlb_lock);
 }
 
 /*
@@ -1741,7 +1743,13 @@ static int free_pool_huge_page(struct hs
 				list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
 			remove_hugetlb_page(h, page, acct_surplus);
+			/*
+			 * unlock/lock around update_and_free_page is temporary
+			 * and will be removed with subsequent patch.
+			 */
+			spin_unlock(&hugetlb_lock);
 			update_and_free_page(h, page);
+			spin_lock(&hugetlb_lock);
 			ret = 1;
 			break;
 		}
@@ -1810,8 +1818,9 @@ retry:
 		}
 		remove_hugetlb_page(h, page, false);
 		h->max_huge_pages--;
+		spin_unlock(&hugetlb_lock);
 		update_and_free_page(h, head);
-		rc = 0;
+		return 0;
 	}
 out:
 	spin_unlock(&hugetlb_lock);
@@ -2563,22 +2572,34 @@ static void try_to_free_low(struct hstat
 						nodemask_t *nodes_allowed)
 {
 	int i;
+	struct page *page, *next;
+	LIST_HEAD(page_list);
 
 	if (hstate_is_gigantic(h))
 		return;
 
+	/*
+	 * Collect pages to be freed on a list, and free after dropping lock
+	 */
 	for_each_node_mask(i, *nodes_allowed) {
-		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(page, next, freel, lru) {
 			if (count >= h->nr_huge_pages)
-				return;
+				goto out;
 			if (PageHighMem(page))
 				continue;
 			remove_hugetlb_page(h, page, false);
-			update_and_free_page(h, page);
+			list_add(&page->lru, &page_list);
 		}
 	}
+
+out:
+	spin_unlock(&hugetlb_lock);
+	list_for_each_entry_safe(page, next, &page_list, lru) {
+		update_and_free_page(h, page);
+		cond_resched();
+	}
+	spin_lock(&hugetlb_lock);
 }
 #else
 static inline void try_to_free_low(struct hstate *h, unsigned long count,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


