Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BA1C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C69B61AF0
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhJAX2Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhJAX2P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFEA361A7B;
        Fri,  1 Oct 2021 23:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130790;
        bh=WH7GhJyfGH0o/4EjLNYguFdesbKlDkf5Ey76nTycrjg=;
        h=Date:From:To:Subject:From;
        b=AY12UVuLbQdBSNhR/c3pTFziqmafYRmi2ZqiNLAE+F0I5Oa+wCmKiLMPyC0IHsTib
         vJpEEbFKlYHkkun0yWAB/9KPBOQgwtbsHhJbVKQSfxeX4HmFPUwfCd/6xHiNtQ0COo
         X4HE7f57x7QELFRhCqd9V7mw2P/WCVvbujCNNQmk=
Date:   Fri, 01 Oct 2021 16:26:29 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de, rientjes@google.com,
        songmuchun@bytedance.com, ziy@nvidia.com
Subject:  + hugetlb-add-hugetlb-demote-page-support.patch added to
 -mm tree
Message-ID: <20211001232629.uX70Gt_B7%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20211001175210.45968-6-mike.kravetz@oracle.com
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

 mm/hugetlb.c |   82 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-hugetlb-demote-page-support
+++ a/mm/hugetlb.c
@@ -1270,7 +1270,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+/* used to demote non-gigantic_huge pages as well */
 static void __destroy_compound_gigantic_page(struct page *page,
 					unsigned int order, bool demote)
 {
@@ -1293,6 +1293,13 @@ static void __destroy_compound_gigantic_
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
@@ -1438,6 +1445,12 @@ static void remove_hugetlb_page(struct h
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
@@ -1779,6 +1792,12 @@ static bool prep_compound_gigantic_page(
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
@@ -3302,9 +3321,54 @@ out:
 	return 0;
 }
 
+static int demote_free_huge_page(struct hstate *h, struct page *page)
+{
+	int i, nid = page_to_nid(page);
+	struct hstate *target_hstate;
+	int rc = 0;
+
+	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
+
+	remove_hugetlb_page_for_demote(h, page, false);
+	spin_unlock_irq(&hugetlb_lock);
+
+	rc = alloc_huge_page_vmemmap(h, page);
+	if (rc) {
+		/* Allocation of vmemmmap failed, we can not demote page */
+		spin_lock_irq(&hugetlb_lock);
+		set_page_refcounted(page);
+		add_hugetlb_page(h, page, false);
+		return rc;
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
+		put_page(page + i);
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+	return rc;
+}
+
 static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 	__must_hold(&hugetlb_lock)
 {
+	int nr_nodes, node;
+	struct page *page;
 	int rc = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
@@ -3313,9 +3377,15 @@ static int demote_pool_huge_page(struct
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
 
@@ -3550,10 +3620,6 @@ static ssize_t demote_store(struct kobje
 		/*
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
-		 *
-		 * NOTE: demote_pool_huge_page does not yet drop hugetlb_lock
-		 * but will when full demote functionality is added in a later
-		 * patch.
 		 */
 		if (nid != NUMA_NO_NODE)
 			nr_available = h->free_huge_pages_node[nid];
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

