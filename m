Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78057C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519CF2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196242;
	bh=6MKQ5OhC4I96+T7wtJmvZUaVXzX1jXJAVYee8aZWd6A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GF4n5C8D1xbnGFqRt2DU8ndKD/51Y4nGIH4pqZ6diAVxeYOcHtusQOxI6TGUHlZuV
	 4AnmtUNvoZhLDTeaQ6ryzwfUbqhmhsIkaMPrdrlFqPUri2JNt12NX7jbHyuC0sGPub
	 n6BB+STX3g4lPKYvNugYfwPhyIM6MS5BLOlHM+Z4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLBhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D3C2076C;
        Wed, 12 Aug 2020 01:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196238;
        bh=6MKQ5OhC4I96+T7wtJmvZUaVXzX1jXJAVYee8aZWd6A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mA5tstLXIAqXR8T0CedTA1lfcDZKqAs6nkoWWPymkbZk+JrWIrzsU5SPk7RRRynyO
         vUtqI29UwnEFTbetgJP3fZhHrwW/jUHXDhluVoai4JHzkM3Vq05yYjHZZVvoyNF2Eg
         dDNBGVAlAka3omCotNJCVnWD9QRpxD3xuAtrMl30=
Date:   Tue, 11 Aug 2020 18:37:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 133/165] mm/hugetlb: unify migration callbacks
Message-ID: <20200812013717.Qy5hnzK_K%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -506,9 +507,8 @@ struct huge_bootmem_page {
 
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
-				nodemask_t *nmask);
+				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
@@ -694,6 +694,15 @@ static inline bool hugepage_movable_supp
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
@@ -761,13 +770,9 @@ static inline struct page *alloc_huge_pa
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
@@ -880,6 +885,11 @@ static inline bool hugepage_movable_supp
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
@@ -1093,15 +1093,6 @@ retry_cpuset:
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
@@ -1986,31 +1977,9 @@ struct page *alloc_buddy_huge_page_with_
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
@@ -2038,7 +2007,7 @@ struct page *alloc_huge_page_vma(struct
 
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
@@ -1545,10 +1545,13 @@ struct page *new_page_nodemask(struct pa
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
