Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC2AC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7468F20658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196248;
	bh=FOnY5D0VCXfs3n4jfhi4ZikXuc2DJghat+INY23HlSo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0AuscK0xZw3vi48dIaNGRHT/bi8tyOeUqdbLTKL7MRVWqGHF9mKk07Lex6SagbpFC
	 d5vVnnJsEQheLopZcr0nEr/wPmQB8umcEPH877Ij7b9k/d2dlNUP+g3Va7Som2uQ3m
	 /foJ7oqd0QD8Ar6ONvmFRpmatobCIMnQ5QVwjS6A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A558820855;
        Wed, 12 Aug 2020 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196246;
        bh=FOnY5D0VCXfs3n4jfhi4ZikXuc2DJghat+INY23HlSo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nhxDz2F9wKahI6qINUFKe+LJbMFA+W+p1mQFNOLFnGoK3O8xigk44pKXk2H3hyHop
         +HBVns1z4qCGeY62vg+Km/0Eh1hfXi3X5N9kF62ZwAFPpbGwIel6uYN0SfykiVZGoB
         7reuatht0H1O9439bEvCm4zBG68R6ICdaPdPrZIs=
Date:   Tue, 11 Aug 2020 18:37:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 135/165] mm/migrate: introduce a standard
 migration target allocation function
Message-ID: <20200812013725.o3w9EnjQt%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
[akpm@linux-foundation.org: fix typo in comment]
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
@@ -703,6 +703,16 @@ static inline gfp_t htlb_alloc_mask(stru
 		return GFP_HIGHUSER;
 }
 
+static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
+{
+	gfp_t modified_mask = htlb_alloc_mask(h);
+
+	/* Some callers might want to enforce node */
+	modified_mask |= (gfp_mask & __GFP_THISNODE);
+
+	return modified_mask;
+}
+
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
@@ -889,6 +899,11 @@ static inline gfp_t htlb_alloc_mask(stru
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
@@ -1648,9 +1648,12 @@ EXPORT_SYMBOL(unpoison_memory);
 
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
@@ -1276,19 +1276,23 @@ found:
 
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
@@ -1538,19 +1538,26 @@ out:
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
@@ -1562,12 +1569,11 @@ struct page *new_page_nodemask(struct pa
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
