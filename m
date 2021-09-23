Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5208CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7CD61242
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbhIWV10 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243304AbhIWV1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 17:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2A5160F6D;
        Thu, 23 Sep 2021 21:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632432349;
        bh=UlAq3JKnsgq6qVkP5RrrxAUT9Ysf8xCWfnTaG9dnfEg=;
        h=Date:From:To:Subject:From;
        b=wHSt0gXSvzV8w2iK94ribsRCw6lYnQkfYyZdpevdrNq4nrXXEA2xU0l1HuCXIVpXc
         t7VsVTqCGJz6Ag8U9ndJuGcL13CemT16gPoytx9sd/zAuMGLhZWPQtRfnD6NzbhBGO
         JNQjc8FdWlD3VSXUYc+zS99TDFyWlBchpIQNMg6o=
Date:   Thu, 23 Sep 2021 14:25:48 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de, rientjes@google.com,
        songmuchun@bytedance.com, ziy@nvidia.com
Subject:  + hugetlb-add-hugetlb-demote-page-support.patch added to
 -mm tree
Message-ID: <20210923212548.9IZAmPWD2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add hugetlb demote page support
has been added to the -mm tree.  Its filename is
     hugetlb-add-hugetlb-demote-page-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hugetlb-demote-page-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hugetlb-demote-page-support.patch

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
Subject: hugetlb: add hugetlb demote page support

Demote page functionality will split a huge page into a number of huge
pages of a smaller size.  For example, on x86 a 1GB huge page can be
demoted into 512 2M huge pages.  Demotion is done 'in place' by simply
splitting the huge page.

Added '*_for_demote' wrappers for remove_hugetlb_page,
destroy_compound_gigantic_page and prep_compound_gigantic_page for use by
demote code.

Link: https://lkml.kernel.org/r/20210923175347.10727-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-hugetlb-demote-page-support
+++ a/mm/hugetlb.c
@@ -1260,7 +1260,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+/* used to demote non-gigantic_huge pages as well */
 static void __destroy_compound_gigantic_page(struct page *page,
 					unsigned int order, bool demote)
 {
@@ -1283,6 +1283,13 @@ static void __destroy_compound_gigantic_
 	__ClearPageHead(page);
 }
 
+static void destroy_compound_gigantic_page_for_demote(struct page *page,
+					unsigned int order)
+{
+	__destroy_compound_gigantic_page(page, order, true);
+}
+
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 static void destroy_compound_gigantic_page(struct page *page,
 					unsigned int order)
 {
@@ -1428,6 +1435,12 @@ static void remove_hugetlb_page(struct h
 	__remove_hugetlb_page(h, page, adjust_surplus, false);
 }
 
+static void remove_hugetlb_page_for_demote(struct hstate *h, struct page *page,
+							bool adjust_surplus)
+{
+	__remove_hugetlb_page(h, page, adjust_surplus, true);
+}
+
 static void add_hugetlb_page(struct hstate *h, struct page *page,
 			     bool adjust_surplus)
 {
@@ -1777,6 +1790,12 @@ static bool prep_compound_gigantic_page(
 	return __prep_compound_gigantic_page(page, order, false);
 }
 
+static bool prep_compound_gigantic_page_for_demote(struct page *page,
+							unsigned int order)
+{
+	return __prep_compound_gigantic_page(page, order, true);
+}
+
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for normal or
  * transparent huge pages.  See the PageTransHuge() documentation for more
@@ -3298,9 +3317,55 @@ out:
 	return 0;
 }
 
+static int demote_free_huge_page(struct hstate *h, struct page *page)
+{
+	int i, nid = page_to_nid(page);
+	struct hstate *target_hstate;
+	bool cma_page = HPageCma(page);
+
+	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
+
+	remove_hugetlb_page_for_demote(h, page, false);
+	spin_unlock_irq(&hugetlb_lock);
+
+	if (alloc_huge_page_vmemmap(h, page)) {
+		/* Allocation of vmemmmap failed, we can not demote page */
+		spin_lock_irq(&hugetlb_lock);
+		set_page_refcounted(page);
+		add_hugetlb_page(h, page, false);
+		return 1;
+	}
+
+	/*
+	 * Use destroy_compound_gigantic_page_for_demote for all huge page
+	 * sizes as it will not ref count pages.
+	 */
+	destroy_compound_gigantic_page_for_demote(page, huge_page_order(h));
+
+	for (i = 0; i < pages_per_huge_page(h);
+				i += pages_per_huge_page(target_hstate)) {
+		if (hstate_is_gigantic(target_hstate))
+			prep_compound_gigantic_page_for_demote(page + i,
+							target_hstate->order);
+		else
+			prep_compound_page(page + i, target_hstate->order);
+		set_page_private(page + i, 0);
+		set_page_refcounted(page + i);
+		prep_new_huge_page(target_hstate, page + i, nid);
+		if (cma_page)
+			SetHPageCma(page + i);
+		put_page(page + i);
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+	return 0;
+}
+
 static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 	__must_hold(&hugetlb_lock)
 {
+	int nr_nodes, node;
+	struct page *page;
 	int rc = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
@@ -3309,9 +3374,15 @@ static int demote_pool_huge_page(struct
 	if (!h->demote_order)
 		return rc;
 
-	/*
-	 * TODO - demote fucntionality will be added in subsequent patch
-	 */
+	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
+		if (!list_empty(&h->hugepage_freelists[node])) {
+			page = list_entry(h->hugepage_freelists[node].next,
+					struct page, lru);
+			rc = !demote_free_huge_page(h, page);
+			break;
+		}
+	}
+
 	return rc;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

