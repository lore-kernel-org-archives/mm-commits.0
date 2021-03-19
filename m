Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D2DC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01C9161988
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhCSWUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhCSWUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 18:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D21A6197D;
        Fri, 19 Mar 2021 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616192443;
        bh=U+qFZcExtXkV5OIcLjLOylO5jmvitUzv0WH0jBEuTlk=;
        h=Date:From:To:Subject:From;
        b=Odq7mONkk0M4RLSPGePyy9dSD27Vv6S8VVgpbhuiZOp5BM3ZMkNS69jVJLUnZoYOU
         m46OlZc0mMjl3z4Wqz4blEIfT2O/VeoB3iwzGd9qllMONm3XLq5JqOnVbmlCC8cssi
         TiB8d0FMXpUYWkhppucrlfWebYDQR11U11BXT/qw=
Date:   Fri, 19 Mar 2021 15:20:42 -0700
From:   akpm@linux-foundation.org
To:     cgoldswo@codeaurora.org, david@redhat.com, joaodias@google.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, surenb@google.com, vbabka@suse.cz,
        willy@infradead.org
Subject:  + mm-fs-invalidate-bh-lru-during-page-migration.patch
 added to -mm tree
Message-ID: <20210319222042.nypo7QUWC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fs: invalidate BH LRU during page migration
has been added to the -mm tree.  Its filename is
     mm-fs-invalidate-bh-lru-during-page-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fs-invalidate-bh-lru-during-page-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-invalidate-bh-lru-during-page-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
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

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-disable-lru-pagevec-during-the-migration-temporarily.patch
mm-replace-migrate_-with-lru_cache_.patch
mm-fs-invalidate-bh-lru-during-page-migration.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch

