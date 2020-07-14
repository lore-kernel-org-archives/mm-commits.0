Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEF5C433E5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA052192A
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689712;
	bh=YvMh+Wdy5r42NilA0buslTX17VmHjJz1r7tdVTaNegI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RqMfpnwSZT1pktM/GwH2/LXYyPs27m+JchYkZMDIUHq8DulvMBUfTzCbHyBDKBgKj
	 y/XHmlB1vbaqb4padfrOKa23btXMwWkDYtAnq+vWFnvKkN9i1W5+7wAR1Qxc6dtxrF
	 7tqkGN3iv8j2746rSHCh3IcSMMYfGt73HBBHNZ1Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgGNBVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1FF72193E;
        Tue, 14 Jul 2020 01:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689710;
        bh=YvMh+Wdy5r42NilA0buslTX17VmHjJz1r7tdVTaNegI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DTsb2qbnpN+zDd6MaPMMbHPhlF43tclZkLFAF0irqMwkY6/e/4gSf36rGsC/og8mO
         Vx9z3vWUBpjWATcG0rQ9q22e/nNY5bGUn1n5pzhZNml8XXsbQ+WHhxruOH5mCt+3eu
         0XCFAfYUR8tkhd2GqslUmuT8MXLvDpTZrSbW/PJc=
Date:   Mon, 13 Jul 2020 18:21:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-migrate-make-a-standard-migration-target-allocation-function.patch added
 to -mm tree
Message-ID: <20200714012149.H4oPFblzK%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: introduce a standard migration target allocation function
has been added to the -mm tree.  Its filename is
     mm-migrate-make-a-standard-migration-target-allocation-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-make-a-standard-migration-target-allocation-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-make-a-standard-migration-target-allocation-function.patch

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
Subject: mm/migrate: introduce a standard migration target allocation function

There are some similar functions for migration target allocation.  Since
there is no fundamental difference, it's better to keep just one rather
than keeping all variants.  This patch implements base migration target
allocation function.  In the following patches, variants will be converted
to use this function.

Changes should be mechanical, but, unfortunately, there are some
differences.  First, some callers' nodemask is assgined to NULL since NULL
nodemask will be considered as all available nodes, that is,
&node_states[N_MEMORY].  Second, for hugetlb page allocation, gfp_mask is
redefined as regular hugetlb allocation gfp_mask plus __GFP_THISNODE if
user provided gfp_mask has it.  This is because future caller of this
function requires to set this node constaint.  Lastly, if provided nodeid
is NUMA_NO_NODE, nodeid is set up to the node where migration source
lives.  It helps to remove simple wrappers for setting up the nodeid.

Note that PageHighmem() call in previous function is changed to open-code
"is_highmem_idx()" since it provides more readability.

[akpm@linux-foundation.org: tweak patch title, per Vlastimil]
Link: http://lkml.kernel.org/r/1594622517-20681-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   15 +++++++++++++++
 include/linux/migrate.h |    9 +++++----
 mm/internal.h           |    7 +++++++
 mm/memory-failure.c     |    7 +++++--
 mm/memory_hotplug.c     |   12 ++++++++----
 mm/migrate.c            |   26 ++++++++++++++++----------
 mm/page_isolation.c     |    7 +++++--
 7 files changed, 61 insertions(+), 22 deletions(-)

--- a/include/linux/hugetlb.h~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/include/linux/hugetlb.h
@@ -701,6 +701,16 @@ static inline gfp_t htlb_alloc_mask(stru
 		return GFP_HIGHUSER;
 }
 
+static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
+{
+	gfp_t modified_mask = htlb_alloc_mask(h);
+
+	/* Some callers might want to enfoce node */
+	modified_mask |= (gfp_mask & __GFP_THISNODE);
+
+	return modified_mask;
+}
+
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
@@ -887,6 +897,11 @@ static inline gfp_t htlb_alloc_mask(stru
 {
 	return 0;
 }
+
+static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
+{
+	return 0;
+}
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
--- a/include/linux/migrate.h~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/include/linux/migrate.h
@@ -10,6 +10,8 @@
 typedef struct page *new_page_t(struct page *page, unsigned long private);
 typedef void free_page_t(struct page *page, unsigned long private);
 
+struct migration_target_control;
+
 /*
  * Return values from addresss_space_operations.migratepage():
  * - negative errno on page migration failure;
@@ -39,8 +41,7 @@ extern int migrate_page(struct address_s
 			enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
-extern struct page *new_page_nodemask(struct page *page,
-		int preferred_nid, nodemask_t *nodemask);
+extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
@@ -59,8 +60,8 @@ static inline int migrate_pages(struct l
 		free_page_t free, unsigned long private, enum migrate_mode mode,
 		int reason)
 	{ return -ENOSYS; }
-static inline struct page *new_page_nodemask(struct page *page,
-		int preferred_nid, nodemask_t *nodemask)
+static inline struct page *alloc_migration_target(struct page *page,
+		unsigned long private)
 	{ return NULL; }
 static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return -EBUSY; }
--- a/mm/internal.h~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/internal.h
@@ -614,4 +614,11 @@ static inline bool is_migrate_highatomic
 
 void setup_zone_pageset(struct zone *zone);
 extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
+
+struct migration_target_control {
+	int nid;		/* preferred node id */
+	nodemask_t *nmask;
+	gfp_t gfp_mask;
+};
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory-failure.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/memory-failure.c
@@ -1679,9 +1679,12 @@ EXPORT_SYMBOL(unpoison_memory);
 
 static struct page *new_page(struct page *p, unsigned long private)
 {
-	int nid = page_to_nid(p);
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(p),
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
-	return new_page_nodemask(p, nid, &node_states[N_MEMORY]);
+	return alloc_migration_target(p, (unsigned long)&mtc);
 }
 
 /*
--- a/mm/memory_hotplug.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/memory_hotplug.c
@@ -1277,19 +1277,23 @@ found:
 
 static struct page *new_node_page(struct page *page, unsigned long private)
 {
-	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(page),
+		.nmask = &nmask,
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	/*
 	 * try to allocate from a different node but reuse this node if there
 	 * are no other online nodes to be used (e.g. we are offlining a part
 	 * of the only existing node)
 	 */
-	node_clear(nid, nmask);
+	node_clear(mtc.nid, nmask);
 	if (nodes_empty(nmask))
-		node_set(nid, nmask);
+		node_set(mtc.nid, nmask);
 
-	return new_page_nodemask(page, nid, &nmask);
+	return alloc_migration_target(page, (unsigned long)&mtc);
 }
 
 static int
--- a/mm/migrate.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/migrate.c
@@ -1534,19 +1534,26 @@ out:
 	return rc;
 }
 
-struct page *new_page_nodemask(struct page *page,
-				int preferred_nid, nodemask_t *nodemask)
+struct page *alloc_migration_target(struct page *page, unsigned long private)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+	struct migration_target_control *mtc;
+	gfp_t gfp_mask;
 	unsigned int order = 0;
 	struct page *new_page = NULL;
+	int nid;
+	int zidx;
+
+	mtc = (struct migration_target_control *)private;
+	gfp_mask = mtc->gfp_mask;
+	nid = mtc->nid;
+	if (nid == NUMA_NO_NODE)
+		nid = page_to_nid(page);
 
 	if (PageHuge(page)) {
 		struct hstate *h = page_hstate(compound_head(page));
 
-		gfp_mask = htlb_alloc_mask(h);
-		return alloc_huge_page_nodemask(h, preferred_nid,
-						nodemask, gfp_mask);
+		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
+		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
 	}
 
 	if (PageTransHuge(page)) {
@@ -1558,12 +1565,11 @@ struct page *new_page_nodemask(struct pa
 		gfp_mask |= GFP_TRANSHUGE;
 		order = HPAGE_PMD_ORDER;
 	}
-
-	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
+	zidx = zone_idx(page_zone(page));
+	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages_nodemask(gfp_mask, order,
-				preferred_nid, nodemask);
+	new_page = __alloc_pages_nodemask(gfp_mask, order, nid, mtc->nmask);
 
 	if (new_page && PageTransHuge(new_page))
 		prep_transhuge_page(new_page);
--- a/mm/page_isolation.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/page_isolation.c
@@ -309,7 +309,10 @@ int test_pages_isolated(unsigned long st
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private)
 {
-	int nid = page_to_nid(page);
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(page),
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
-	return new_page_nodemask(page, nid, &node_states[N_MEMORY]);
+	return alloc_migration_target(page, (unsigned long)&mtc);
 }
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

