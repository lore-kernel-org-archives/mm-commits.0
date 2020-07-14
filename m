Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D89C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AA421927
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689703;
	bh=0vf4K95pMoX/Ro+nPYjm6kx58ckDMEkOj8kF5GcM27Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aewNvNh0DziTeBzoM6FSO+uUZYrlC8CNQZ3cEZOkK71PJ4GIlLBAWF4X9Pvi1jdaa
	 KaXuNrlQ9/ko264yQ8gdNh1boE/bSWhXH6i74ajwL/uA8kYBHhwN5Oktza3CLvcjI6
	 y2iChcJZ/i7H2Ae4RSFjxHyBBfqY7YH2njs8UvgQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGNBVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E801321924;
        Tue, 14 Jul 2020 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689702;
        bh=0vf4K95pMoX/Ro+nPYjm6kx58ckDMEkOj8kF5GcM27Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VHrva4fbWs91trAwtMnxHLSI9vRHYZGbmNNrkpB/9pLO7G+TpyhQsv2AHHf1OWC8K
         fE+rHhCX7zf5Bta/WEi9mZRTdXcT3jP5QBmHQgcQciaHI3wmfw1emUDoQdcMWGgvxK
         wGStQwdY8GJyS6EVxu+I/8FzYbT8Fi6AysgCeF0I=
Date:   Mon, 13 Jul 2020 18:21:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  + mm-hugetlb-unify-migration-callbacks.patch added to -mm
 tree
Message-ID: <20200714012141.yMcYhCj-n%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: unify migration callbacks
has been added to the -mm tree.  Its filename is
     mm-hugetlb-unify-migration-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-unify-migration-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-unify-migration-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb: unify migration callbacks

There is no difference between two migration callback functions,
alloc_huge_page_node() and alloc_huge_page_nodemask(), except
__GFP_THISNODE handling.  It's redundant to have two almost similar
functions in order to handle this flag.  So, this patch tries to remove
one by introducing a new argument, gfp_mask, to
alloc_huge_page_nodemask().

After introducing gfp_mask argument, it's caller's job to provide correct
gfp_mask.  So, every callsites for alloc_huge_page_nodemask() are changed
to provide gfp_mask.

Note that it's safe to remove a node id check in alloc_huge_page_node()
since there is no caller passing NUMA_NO_NODE as a node id.

Link: http://lkml.kernel.org/r/1594622517-20681-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   26 ++++++++++++++++++--------
 mm/hugetlb.c            |   35 ++---------------------------------
 mm/mempolicy.c          |   10 ++++++----
 mm/migrate.c            |   11 +++++++----
 4 files changed, 33 insertions(+), 49 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-unify-migration-callbacks
+++ a/include/linux/hugetlb.h
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/pgtable.h>
+#include <linux/gfp.h>
 
 struct ctl_table;
 struct user_struct;
@@ -504,9 +505,8 @@ struct huge_bootmem_page {
 
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-				nodemask_t *nmask);
+				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
@@ -692,6 +692,15 @@ static inline bool hugepage_movable_supp
 	return true;
 }
 
+/* Movability of hugepages depends on migration support. */
+static inline gfp_t htlb_alloc_mask(struct hstate *h)
+{
+	if (hugepage_movable_supported(h))
+		return GFP_HIGHUSER_MOVABLE;
+	else
+		return GFP_HIGHUSER;
+}
+
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
@@ -759,13 +768,9 @@ static inline struct page *alloc_huge_pa
 	return NULL;
 }
 
-static inline struct page *alloc_huge_page_node(struct hstate *h, int nid)
-{
-	return NULL;
-}
-
 static inline struct page *
-alloc_huge_page_nodemask(struct hstate *h, int preferred_nid, nodemask_t *nmask)
+alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+			nodemask_t *nmask, gfp_t gfp_mask)
 {
 	return NULL;
 }
@@ -878,6 +883,11 @@ static inline bool hugepage_movable_supp
 	return false;
 }
 
+static inline gfp_t htlb_alloc_mask(struct hstate *h)
+{
+	return 0;
+}
+
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
--- a/mm/hugetlb.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/hugetlb.c
@@ -1091,15 +1091,6 @@ retry_cpuset:
 	return NULL;
 }
 
-/* Movability of hugepages depends on migration support. */
-static inline gfp_t htlb_alloc_mask(struct hstate *h)
-{
-	if (hugepage_movable_supported(h))
-		return GFP_HIGHUSER_MOVABLE;
-	else
-		return GFP_HIGHUSER;
-}
-
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve,
@@ -1981,31 +1972,9 @@ struct page *alloc_buddy_huge_page_with_
 }
 
 /* page migration callback function */
-struct page *alloc_huge_page_node(struct hstate *h, int nid)
-{
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-	struct page *page = NULL;
-
-	if (nid != NUMA_NO_NODE)
-		gfp_mask |= __GFP_THISNODE;
-
-	spin_lock(&hugetlb_lock);
-	if (h->free_huge_pages - h->resv_huge_pages > 0)
-		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, NULL);
-	spin_unlock(&hugetlb_lock);
-
-	if (!page)
-		page = alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
-
-	return page;
-}
-
-/* page migration callback function */
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask)
+		nodemask_t *nmask, gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-
 	spin_lock(&hugetlb_lock);
 	if (h->free_huge_pages - h->resv_huge_pages > 0) {
 		struct page *page;
@@ -2033,7 +2002,7 @@ struct page *alloc_huge_page_vma(struct
 
 	gfp_mask = htlb_alloc_mask(h);
 	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = alloc_huge_page_nodemask(h, node, nodemask);
+	page = alloc_huge_page_nodemask(h, node, nodemask, gfp_mask);
 	mpol_cond_put(mpol);
 
 	return page;
--- a/mm/mempolicy.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/mempolicy.c
@@ -1068,10 +1068,12 @@ static int migrate_page_add(struct page
 /* page allocation callback for NUMA node migration */
 struct page *alloc_new_node_page(struct page *page, unsigned long node)
 {
-	if (PageHuge(page))
-		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					node);
-	else if (PageTransHuge(page)) {
+	if (PageHuge(page)) {
+		struct hstate *h = page_hstate(compound_head(page));
+		gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+
+		return alloc_huge_page_nodemask(h, node, NULL, gfp_mask);
+	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
 		thp = alloc_pages_node(node,
--- a/mm/migrate.c~mm-hugetlb-unify-migration-callbacks
+++ a/mm/migrate.c
@@ -1541,10 +1541,13 @@ struct page *new_page_nodemask(struct pa
 	unsigned int order = 0;
 	struct page *new_page = NULL;
 
-	if (PageHuge(page))
-		return alloc_huge_page_nodemask(
-				page_hstate(compound_head(page)),
-				preferred_nid, nodemask);
+	if (PageHuge(page)) {
+		struct hstate *h = page_hstate(compound_head(page));
+
+		gfp_mask = htlb_alloc_mask(h);
+		return alloc_huge_page_nodemask(h, preferred_nid,
+						nodemask, gfp_mask);
+	}
 
 	if (PageTransHuge(page)) {
 		gfp_mask |= GFP_TRANSHUGE;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

