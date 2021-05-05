Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB999C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD05611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhEEBhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AB1E61029;
        Wed,  5 May 2021 01:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178618;
        bh=85dxzFLi8V32DZFrqRjRePVmCgb6OP0yHAzR2CWRjOg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WONFjYksT9yNIHT99WeJ+Ur4M62cAoSVfc/DqVEnvOF1TWhbDMG4HJb+ZKXtWEL0l
         BRBsCjTgOy1+PByO+1wAysy/JWun5UOvPsNATok/E//mFTitP6DxM7GcWqKX1jUh+6
         YuiaqEUGCRCNnKcAA6Pc3WTE+WdTKYyMVP5zNlV4=
Date:   Tue, 04 May 2021 18:36:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cgoldswo@codeaurora.org,
        david@redhat.com, joaodias@google.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, surenb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 078/143] mm: replace migrate_[prep|finish] with
 lru_cache_[disable|enable]
Message-ID: <20210505013657.uv5tKrPa6%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: replace migrate_[prep|finish] with lru_cache_[disable|enable]

Currently, migrate_[prep|finish] is merely a wrapper of
lru_cache_[disable|enable].  There is not much to gain from having
additional abstraction.

Use lru_cache_[disable|enable] instead of migrate_[prep|finish], which
would be more descriptive.

note: migrate_prep_local in compaction.c changed into lru_add_drain to
avoid CPU schedule cost with involving many other CPUs to keep old
behavior.

Link: https://lkml.kernel.org/r/20210319175127.886124-2-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: John Dias <joaodias@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    7 -------
 mm/compaction.c         |    3 ++-
 mm/mempolicy.c          |    8 ++++----
 mm/migrate.c            |   28 ++--------------------------
 mm/page_alloc.c         |    4 ++--
 5 files changed, 10 insertions(+), 40 deletions(-)

--- a/include/linux/migrate.h~mm-replace-migrate_-with-lru_cache_
+++ a/include/linux/migrate.h
@@ -45,9 +45,6 @@ extern struct page *alloc_migration_targ
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
-extern void migrate_prep(void);
-extern void migrate_finish(void);
-extern void migrate_prep_local(void);
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
@@ -67,10 +64,6 @@ static inline struct page *alloc_migrati
 static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return -EBUSY; }
 
-static inline int migrate_prep(void) { return -ENOSYS; }
-static inline int migrate_finish(void) { return -ENOSYS; }
-static inline int migrate_prep_local(void) { return -ENOSYS; }
-
 static inline void migrate_page_states(struct page *newpage, struct page *page)
 {
 }
--- a/mm/compaction.c~mm-replace-migrate_-with-lru_cache_
+++ a/mm/compaction.c
@@ -2354,7 +2354,8 @@ compact_zone(struct compact_control *cc,
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
 				cc->free_pfn, end_pfn, sync);
 
-	migrate_prep_local();
+	/* lru_add_drain_all could be expensive with involving other CPUs */
+	lru_add_drain();
 
 	while ((ret = compact_finished(cc)) == COMPACT_CONTINUE) {
 		int err;
--- a/mm/mempolicy.c~mm-replace-migrate_-with-lru_cache_
+++ a/mm/mempolicy.c
@@ -1124,7 +1124,7 @@ int do_migrate_pages(struct mm_struct *m
 	int err = 0;
 	nodemask_t tmp;
 
-	migrate_prep();
+	lru_cache_disable();
 
 	mmap_read_lock(mm);
 
@@ -1209,7 +1209,7 @@ int do_migrate_pages(struct mm_struct *m
 	}
 	mmap_read_unlock(mm);
 
-	migrate_finish();
+	lru_cache_enable();
 	if (err < 0)
 		return err;
 	return busy;
@@ -1325,7 +1325,7 @@ static long do_mbind(unsigned long start
 
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 
-		migrate_prep();
+		lru_cache_disable();
 	}
 	{
 		NODEMASK_SCRATCH(scratch);
@@ -1374,7 +1374,7 @@ up_out:
 mpol_out:
 	mpol_put(new);
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-		migrate_finish();
+		lru_cache_enable();
 	return err;
 }
 
--- a/mm/migrate.c~mm-replace-migrate_-with-lru_cache_
+++ a/mm/migrate.c
@@ -57,30 +57,6 @@
 
 #include "internal.h"
 
-/*
- * migrate_prep() needs to be called before we start compiling a list of pages
- * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
- * undesirable, use migrate_prep_local()
- */
-void migrate_prep(void)
-{
-	/*
-	 * Clear the LRU lists so pages can be isolated.
-	 */
-	lru_cache_disable();
-}
-
-void migrate_finish(void)
-{
-	lru_cache_enable();
-}
-
-/* Do the necessary work of migrate_prep but not if it involves other CPUs */
-void migrate_prep_local(void)
-{
-	lru_add_drain();
-}
-
 int isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
 	struct address_space *mapping;
@@ -1771,7 +1747,7 @@ static int do_pages_move(struct mm_struc
 	int start, i;
 	int err = 0, err1;
 
-	migrate_prep();
+	lru_cache_disable();
 
 	for (i = start = 0; i < nr_pages; i++) {
 		const void __user *p;
@@ -1840,7 +1816,7 @@ out_flush:
 	if (err >= 0)
 		err = err1;
 out:
-	migrate_finish();
+	lru_cache_enable();
 	return err;
 }
 
--- a/mm/page_alloc.c~mm-replace-migrate_-with-lru_cache_
+++ a/mm/page_alloc.c
@@ -8681,7 +8681,7 @@ static int __alloc_contig_migrate_range(
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	migrate_prep();
+	lru_cache_disable();
 
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
@@ -8716,7 +8716,7 @@ static int __alloc_contig_migrate_range(
 			break;
 	}
 
-	migrate_finish();
+	lru_cache_enable();
 	if (ret < 0) {
 		alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
_
