Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7D3C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIGWrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIGWra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22595A50EA
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:47:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C21DEB81F53
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFBAC433D7;
        Wed,  7 Sep 2022 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662590845;
        bh=uj4WwGGxGwz7Mze5LJJsHdCDyE2i8AwSWyB9KFIkwFw=;
        h=Date:To:From:Subject:From;
        b=FBVCl1mEthRWLKS7CYbmX7YaxIWcEacejwN3jYxb8VFP6Rm6ks9pK5HXI4PyyBFrb
         fKSh4Mr6qfnRtMryuYteGkOJCsWrktVQS9ZYh5tjE+wZJFpKEGAF46dYLjXLduSgqb
         dgJGGVPcey7NxrLVaASJdEaHvwYKKTCrb4evOerk=
Date:   Wed, 07 Sep 2022 15:47:25 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pageblock_aligned-macro.patch added to mm-unstable branch
Message-Id: <20220907224725.7CFBAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add pageblock_aligned() macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pageblock_aligned-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pageblock_aligned-macro.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add pageblock_aligned() macro
Date: Wed, 7 Sep 2022 14:08:44 +0800

Add pageblock_aligned() and use it to simplify code.

Link: https://lkml.kernel.org/r/20220907060844.126891-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    1 +
 mm/compaction.c                 |    8 ++++----
 mm/memory_hotplug.c             |    6 ++----
 mm/page_alloc.c                 |   17 +++++++----------
 mm/page_isolation.c             |    2 +-
 5 files changed, 15 insertions(+), 19 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-add-pageblock_aligned-macro
+++ a/include/linux/pageblock-flags.h
@@ -54,6 +54,7 @@ extern unsigned int pageblock_order;
 
 #define pageblock_nr_pages	(1UL << pageblock_order)
 #define pageblock_align(pfn)	ALIGN((pfn), pageblock_nr_pages)
+#define pageblock_aligned(pfn)	IS_ALIGNED((pfn), pageblock_nr_pages)
 #define pageblock_start_pfn(pfn)	ALIGN_DOWN((pfn), pageblock_nr_pages)
 #define pageblock_end_pfn(pfn)		ALIGN((pfn) + 1, pageblock_nr_pages)
 
--- a/mm/compaction.c~mm-add-pageblock_aligned-macro
+++ a/mm/compaction.c
@@ -402,7 +402,7 @@ static bool test_and_set_skip(struct com
 	if (cc->ignore_skip_hint)
 		return false;
 
-	if (!IS_ALIGNED(pfn, pageblock_nr_pages))
+	if (!pageblock_aligned(pfn))
 		return false;
 
 	skip = get_pageblock_skip(page);
@@ -884,7 +884,7 @@ isolate_migratepages_block(struct compac
 		 * COMPACT_CLUSTER_MAX at a time so the second call must
 		 * not falsely conclude that the block should be skipped.
 		 */
-		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
+		if (!valid_page && pageblock_aligned(low_pfn)) {
 			if (!isolation_suitable(cc, page)) {
 				low_pfn = end_pfn;
 				page = NULL;
@@ -1936,7 +1936,7 @@ static isolate_migrate_t isolate_migrate
 		 * before making it "skip" so other compaction instances do
 		 * not scan the same block.
 		 */
-		if (IS_ALIGNED(low_pfn, pageblock_nr_pages) &&
+		if (pageblock_aligned(low_pfn) &&
 		    !fast_find_block && !isolation_suitable(cc, page))
 			continue;
 
@@ -2122,7 +2122,7 @@ static enum compact_result __compact_fin
 	 * migration source is unmovable/reclaimable but it's not worth
 	 * special casing.
 	 */
-	if (!IS_ALIGNED(cc->migrate_pfn, pageblock_nr_pages))
+	if (!pageblock_aligned(cc->migrate_pfn))
 		return COMPACT_CONTINUE;
 
 	/* Direct compactor: Is a suitable page free? */
--- a/mm/memory_hotplug.c~mm-add-pageblock_aligned-macro
+++ a/mm/memory_hotplug.c
@@ -1085,8 +1085,7 @@ int __ref online_pages(unsigned long pfn
 	 * of the physical memory space for vmemmaps. That space is pageblock
 	 * aligned.
 	 */
-	if (WARN_ON_ONCE(!nr_pages ||
-			 !IS_ALIGNED(pfn, pageblock_nr_pages) ||
+	if (WARN_ON_ONCE(!nr_pages || !pageblock_aligned(pfn) ||
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
@@ -1806,8 +1805,7 @@ int __ref offline_pages(unsigned long st
 	 * of the physical memory space for vmemmaps. That space is pageblock
 	 * aligned.
 	 */
-	if (WARN_ON_ONCE(!nr_pages ||
-			 !IS_ALIGNED(start_pfn, pageblock_nr_pages) ||
+	if (WARN_ON_ONCE(!nr_pages || !pageblock_aligned(start_pfn) ||
 			 !IS_ALIGNED(start_pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
--- a/mm/page_alloc.c~mm-add-pageblock_aligned-macro
+++ a/mm/page_alloc.c
@@ -1902,15 +1902,14 @@ static void __init deferred_free_range(u
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
-	if (nr_pages == pageblock_nr_pages &&
-	    (pfn & (pageblock_nr_pages - 1)) == 0) {
+	if (nr_pages == pageblock_nr_pages && pageblock_aligned(pfn)) {
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		__free_pages_core(page, pageblock_order);
 		return;
 	}
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if ((pfn & (pageblock_nr_pages - 1)) == 0)
+		if (pageblock_aligned(pfn))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		__free_pages_core(page, 0);
 	}
@@ -1938,7 +1937,7 @@ static inline void __init pgdat_init_rep
  */
 static inline bool __init deferred_pfn_valid(unsigned long pfn)
 {
-	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
+	if (pageblock_aligned(pfn) && !pfn_valid(pfn))
 		return false;
 	return true;
 }
@@ -1950,14 +1949,13 @@ static inline bool __init deferred_pfn_v
 static void __init deferred_free_pages(unsigned long pfn,
 				       unsigned long end_pfn)
 {
-	unsigned long nr_pgmask = pageblock_nr_pages - 1;
 	unsigned long nr_free = 0;
 
 	for (; pfn < end_pfn; pfn++) {
 		if (!deferred_pfn_valid(pfn)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 0;
-		} else if (!(pfn & nr_pgmask)) {
+		} else if (pageblock_aligned(pfn)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
 		} else {
@@ -1977,7 +1975,6 @@ static unsigned long  __init deferred_in
 						 unsigned long pfn,
 						 unsigned long end_pfn)
 {
-	unsigned long nr_pgmask = pageblock_nr_pages - 1;
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
 	int zid = zone_idx(zone);
@@ -1987,7 +1984,7 @@ static unsigned long  __init deferred_in
 		if (!deferred_pfn_valid(pfn)) {
 			page = NULL;
 			continue;
-		} else if (!page || !(pfn & nr_pgmask)) {
+		} else if (!page || pageblock_aligned(pfn)) {
 			page = pfn_to_page(pfn);
 		} else {
 			page++;
@@ -6770,7 +6767,7 @@ void __meminit memmap_init_range(unsigne
 		 * such that unmovable allocations won't be scattered all
 		 * over the place during system boot.
 		 */
-		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
+		if (pageblock_aligned(pfn)) {
 			set_pageblock_migratetype(page, migratetype);
 			cond_resched();
 		}
@@ -6813,7 +6810,7 @@ static void __ref __init_zone_device_pag
 	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 	 * because this is done early in section_activate()
 	 */
-	if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
+	if (pageblock_aligned(pfn)) {
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		cond_resched();
 	}
--- a/mm/page_isolation.c~mm-add-pageblock_aligned-macro
+++ a/mm/page_isolation.c
@@ -311,7 +311,7 @@ static int isolate_single_pageblock(unsi
 	struct zone *zone;
 	int ret;
 
-	VM_BUG_ON(!IS_ALIGNED(boundary_pfn, pageblock_nr_pages));
+	VM_BUG_ON(!pageblock_aligned(boundary_pfn));
 
 	if (isolate_before)
 		isolate_pageblock = boundary_pfn - pageblock_nr_pages;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-memory-failure-kill-__soft_offline_page-v2.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-remove-bug_on-in-__isolate_free_page.patch
mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
kernel-exit-cleanup-release_thread.patch

