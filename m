Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB72C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EEB61422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhEEBh6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBh6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56EF3611AB;
        Wed,  5 May 2021 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178621;
        bh=U+O7R03uRgpKvmSAdH8iLG9SArUhINdxYVTCpT13S9E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pvfL9Lh1Ax9NXTKBKKjke/CXds5/JkMTNvbfapvXe1+uTdjNQpOLWWPk2UXhBUn73
         774C+0O+Brju+l6PA2CO2Kr8NpB8PT9n0fiz/MUcpFt5Qv5g5CQXil7lx244t4dfZ+
         QobSkwhtI9L5ZX4/84YtwHOAOkO8zSMEXtKTWjHw=
Date:   Tue, 04 May 2021 18:37:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cgoldswo@codeaurora.org,
        david@redhat.com, joaodias@google.com, labbott@kernel.org,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        surenb@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 079/143] mm: fs: invalidate BH LRU during page
 migration
Message-ID: <20210505013700.p5ZeZkd69%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: fs: invalidate BH LRU during page migration

Pages containing buffer_heads that are in one of the per-CPU buffer_head
LRU caches will be pinned and thus cannot be migrated.  This can prevent
CMA allocations from succeeding, which are often used on platforms with
co-processors (such as a DSP) that can only use physically contiguous
memory.  It can also prevent memory hot-unplugging from succeeding, which
involves migrating at least MIN_MEMORY_BLOCK_SIZE bytes of memory, which
ranges from 8 MiB to 1 GiB based on the architecture in use.

Correspondingly, invalidate the BH LRU caches before a migration starts
and stop any buffer_head from being cached in the LRU caches, until
migration has finished.

Link: https://lkml.kernel.org/r/20210319175127.886124-3-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
Reported-by: Laura Abbott <labbott@kernel.org>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Dias <joaodias@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   36 ++++++++++++++++++++++++++++------
 include/linux/buffer_head.h |    4 +++
 mm/swap.c                   |    5 +++-
 3 files changed, 38 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~mm-fs-invalidate-bh-lru-during-page-migration
+++ a/fs/buffer.c
@@ -1264,6 +1264,15 @@ static void bh_lru_install(struct buffer
 	int i;
 
 	check_irqs_on();
+	/*
+	 * the refcount of buffer_head in bh_lru prevents dropping the
+	 * attached page(i.e., try_to_free_buffers) so it could cause
+	 * failing page migration.
+	 * Skip putting upcoming bh into bh_lru until migration is done.
+	 */
+	if (lru_cache_disabled())
+		return;
+
 	bh_lru_lock();
 
 	b = this_cpu_ptr(&bh_lrus);
@@ -1404,6 +1413,15 @@ __bread_gfp(struct block_device *bdev, s
 }
 EXPORT_SYMBOL(__bread_gfp);
 
+static void __invalidate_bh_lrus(struct bh_lru *b)
+{
+	int i;
+
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		brelse(b->bhs[i]);
+		b->bhs[i] = NULL;
+	}
+}
 /*
  * invalidate_bh_lrus() is called rarely - but not only at unmount.
  * This doesn't race because it runs in each cpu either in irq
@@ -1412,16 +1430,12 @@ EXPORT_SYMBOL(__bread_gfp);
 static void invalidate_bh_lru(void *arg)
 {
 	struct bh_lru *b = &get_cpu_var(bh_lrus);
-	int i;
 
-	for (i = 0; i < BH_LRU_SIZE; i++) {
-		brelse(b->bhs[i]);
-		b->bhs[i] = NULL;
-	}
+	__invalidate_bh_lrus(b);
 	put_cpu_var(bh_lrus);
 }
 
-static bool has_bh_in_lru(int cpu, void *dummy)
+bool has_bh_in_lru(int cpu, void *dummy)
 {
 	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
 	int i;
@@ -1440,6 +1454,16 @@ void invalidate_bh_lrus(void)
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
+void invalidate_bh_lrus_cpu(int cpu)
+{
+	struct bh_lru *b;
+
+	bh_lru_lock();
+	b = per_cpu_ptr(&bh_lrus, cpu);
+	__invalidate_bh_lrus(b);
+	bh_lru_unlock();
+}
+
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset)
 {
--- a/include/linux/buffer_head.h~mm-fs-invalidate-bh-lru-during-page-migration
+++ a/include/linux/buffer_head.h
@@ -194,6 +194,8 @@ void __breadahead_gfp(struct block_devic
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
+void invalidate_bh_lrus_cpu(int cpu);
+bool has_bh_in_lru(int cpu, void *dummy);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
@@ -406,6 +408,8 @@ static inline int inode_has_buffers(stru
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
+static inline void invalidate_bh_lrus_cpu(int cpu) {}
+static inline bool has_bh_in_lru(int cpu, void *dummy) { return 0; }
 #define buffer_heads_over_limit 0
 
 #endif /* CONFIG_BLOCK */
--- a/mm/swap.c~mm-fs-invalidate-bh-lru-during-page-migration
+++ a/mm/swap.c
@@ -36,6 +36,7 @@
 #include <linux/hugetlb.h>
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
+#include <linux/buffer_head.h>
 
 #include "internal.h"
 
@@ -641,6 +642,7 @@ void lru_add_drain_cpu(int cpu)
 		pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 
 	activate_page_drain(cpu);
+	invalidate_bh_lrus_cpu(cpu);
 }
 
 /**
@@ -828,7 +830,8 @@ inline void __lru_add_drain_all(bool for
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
-		    need_activate_page_drain(cpu)) {
+		    need_activate_page_drain(cpu) ||
+		    has_bh_in_lru(cpu, NULL)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, work);
 			__cpumask_set_cpu(cpu, &has_work);
_
