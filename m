Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABA7C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D21D6101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhEHWsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E275B6100C;
        Sat,  8 May 2021 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514048;
        bh=9/PBY7VaVqQz1vb8P1HbSYo+3JQj3PneOjahXgj29WE=;
        h=Date:From:To:Subject:From;
        b=jWYzV+w680qQUNG9anBoT90G0VKbi+WEmbqfUdZn1VvaLSl5qGGM8cpzkz0y8TFaO
         jYLHNFtbklvjKSZ2rTYIClxBECxh25NaRIow81xXAlfFviufCBdPvWtE4gyQSXxJJi
         ZQccPV2HsWDU6aQqeECk40s5brOpzrLfdq4H3xlo=
Date:   Sat, 08 May 2021 15:47:27 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, aneesh.kumar@linux.ibm.com,
        david@redhat.com, guro@fb.com, hdanton@sina.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, longman@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, peterz@infradead.org,
        rientjes@google.com, shakeelb@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        will@kernel.org, willy@infradead.org
Subject:  [merged]
 mm-cma-change-cma-mutex-to-irq-safe-spinlock.patch removed from -mm tree
Message-ID: <20210508224727.o-ntx5P7l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: change cma mutex to irq safe spinlock
has been removed from the -mm tree.  Its filename was
     mm-cma-change-cma-mutex-to-irq-safe-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/cma: change cma mutex to irq safe spinlock

Patch series "make hugetlb put_page safe for all calling contexts", v5.

This effort is the result a recent bug report [1].  Syzbot found a
potential deadlock in the hugetlb put_page/free_huge_page_path.  WARNING:
SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected Since the
free_huge_page_path already has code to 'hand off' page free requests to a
workqueue, a suggestion was proposed to make the in_irq() detection
accurate by always enabling PREEMPT_COUNT [2].  The outcome of that
discussion was that the hugetlb put_page path (free_huge_page) path should
be properly fixed and safe for all calling contexts.


This patch (of 8):

cma_release is currently a sleepable operatation because the bitmap
manipulation is protected by cma->lock mutex.  Hugetlb code which relies
on cma_release for CMA backed (giga) hugetlb pages, however, needs to be
irq safe.

The lock doesn't protect any sleepable operation so it can be changed to a
(irq aware) spin lock.  The bitmap processing should be quite fast in
typical case but if cma sizes grow to TB then we will likely need to
replace the lock by a more optimized bitmap implementation.

Link: https://lkml.kernel.org/r/20210409205254.242291-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210409205254.242291-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c       |   18 +++++++++---------
 mm/cma.h       |    2 +-
 mm/cma_debug.c |    8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/cma.c~mm-cma-change-cma-mutex-to-irq-safe-spinlock
+++ a/mm/cma.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-#include <linux/mutex.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
@@ -83,13 +82,14 @@ static void cma_clear_bitmap(struct cma
 			     unsigned int count)
 {
 	unsigned long bitmap_no, bitmap_count;
+	unsigned long flags;
 
 	bitmap_no = (pfn - cma->base_pfn) >> cma->order_per_bit;
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
-	mutex_lock(&cma->lock);
+	spin_lock_irqsave(&cma->lock, flags);
 	bitmap_clear(cma->bitmap, bitmap_no, bitmap_count);
-	mutex_unlock(&cma->lock);
+	spin_unlock_irqrestore(&cma->lock, flags);
 }
 
 static void __init cma_activate_area(struct cma *cma)
@@ -118,7 +118,7 @@ static void __init cma_activate_area(str
 	     pfn += pageblock_nr_pages)
 		init_cma_reserved_pageblock(pfn_to_page(pfn));
 
-	mutex_init(&cma->lock);
+	spin_lock_init(&cma->lock);
 
 #ifdef CONFIG_CMA_DEBUGFS
 	INIT_HLIST_HEAD(&cma->mem_head);
@@ -392,7 +392,7 @@ static void cma_debug_show_areas(struct
 	unsigned long nr_part, nr_total = 0;
 	unsigned long nbits = cma_bitmap_maxno(cma);
 
-	mutex_lock(&cma->lock);
+	spin_lock_irq(&cma->lock);
 	pr_info("number of available pages: ");
 	for (;;) {
 		next_zero_bit = find_next_zero_bit(cma->bitmap, nbits, start);
@@ -407,7 +407,7 @@ static void cma_debug_show_areas(struct
 		start = next_zero_bit + nr_zero;
 	}
 	pr_cont("=> %lu free of %lu total pages\n", nr_total, cma->count);
-	mutex_unlock(&cma->lock);
+	spin_unlock_irq(&cma->lock);
 }
 #else
 static inline void cma_debug_show_areas(struct cma *cma) { }
@@ -452,12 +452,12 @@ struct page *cma_alloc(struct cma *cma,
 		return NULL;
 
 	for (;;) {
-		mutex_lock(&cma->lock);
+		spin_lock_irq(&cma->lock);
 		bitmap_no = bitmap_find_next_zero_area_off(cma->bitmap,
 				bitmap_maxno, start, bitmap_count, mask,
 				offset);
 		if (bitmap_no >= bitmap_maxno) {
-			mutex_unlock(&cma->lock);
+			spin_unlock_irq(&cma->lock);
 			break;
 		}
 		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
@@ -466,7 +466,7 @@ struct page *cma_alloc(struct cma *cma,
 		 * our exclusive use. If the migration fails we will take the
 		 * lock again and unmark it.
 		 */
-		mutex_unlock(&cma->lock);
+		spin_unlock_irq(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
--- a/mm/cma_debug.c~mm-cma-change-cma-mutex-to-irq-safe-spinlock
+++ a/mm/cma_debug.c
@@ -36,10 +36,10 @@ static int cma_used_get(void *data, u64
 	struct cma *cma = data;
 	unsigned long used;
 
-	mutex_lock(&cma->lock);
+	spin_lock_irq(&cma->lock);
 	/* pages counter is smaller than sizeof(int) */
 	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
-	mutex_unlock(&cma->lock);
+	spin_unlock_irq(&cma->lock);
 	*val = (u64)used << cma->order_per_bit;
 
 	return 0;
@@ -53,7 +53,7 @@ static int cma_maxchunk_get(void *data,
 	unsigned long start, end = 0;
 	unsigned long bitmap_maxno = cma_bitmap_maxno(cma);
 
-	mutex_lock(&cma->lock);
+	spin_lock_irq(&cma->lock);
 	for (;;) {
 		start = find_next_zero_bit(cma->bitmap, bitmap_maxno, end);
 		if (start >= bitmap_maxno)
@@ -61,7 +61,7 @@ static int cma_maxchunk_get(void *data,
 		end = find_next_bit(cma->bitmap, bitmap_maxno, start);
 		maxchunk = max(end - start, maxchunk);
 	}
-	mutex_unlock(&cma->lock);
+	spin_unlock_irq(&cma->lock);
 	*val = (u64)maxchunk << cma->order_per_bit;
 
 	return 0;
--- a/mm/cma.h~mm-cma-change-cma-mutex-to-irq-safe-spinlock
+++ a/mm/cma.h
@@ -9,7 +9,7 @@ struct cma {
 	unsigned long   count;
 	unsigned long   *bitmap;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	struct mutex    lock;
+	spinlock_t	lock;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
 	spinlock_t mem_head_lock;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


