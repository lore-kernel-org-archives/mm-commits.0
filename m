Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07843C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 19:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE32361186
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 19:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhIUTJS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 15:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhIUTJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 15:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B372461184;
        Tue, 21 Sep 2021 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632251269;
        bh=VUAVh5aXLfTnbdvMFoSKskDVdWLijQsNCCb0APaPIlk=;
        h=Date:From:To:Subject:From;
        b=y29H4dLN2wzWhMH1JvfWRa+J/MZJ9TMc+MxXvWd6Kap5ZpejJ9czie+ggXeFH6O0U
         liWhEVbGIZmlLRqSIu7urcWilQ0sBRtISkSgOLWixNEdIlCepBPWInIt97LuQ0as5i
         /NILR2stD5Sk2/UNiqOtI1DvRtULJBZBlWaiy5z4=
Date:   Tue, 21 Sep 2021 12:07:49 -0700
From:   akpm@linux-foundation.org
To:     cgoldswo@codeaurora.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        zhengjun.xing@intel.com
Subject:  + mm-fs-invalidate-bh_lrus-for-only-cold-path.patch added
 to -mm tree
Message-ID: <20210921190749.ozpW0AaS_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fs: invalidate bh_lrus for only cold path
has been added to the -mm tree.  Its filename is
     mm-fs-invalidate-bh_lrus-for-only-cold-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fs-invalidate-bh_lrus-for-only-cold-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-invalidate-bh_lrus-for-only-cold-path.patch

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
Subject: mm: fs: invalidate bh_lrus for only cold path

kernel test robot reported the regression of fio.write_iops[1] with [2].

Since lru_add_drain is called frequently, invalidate bh_lrus there could
increase bh_lrus cache miss ratio, which needs more IO in the end.

This patch moves the bh_lrus invalidation from the hot path( e.g.,
zap_page_range, pagevec_release) to cold path(i.e., lru_add_drain_all,
lru_cache_disable).

"Xing, Zhengjun" confirmed 

: I test the patch, the regression reduced to -2.9%.

[1] https://lore.kernel.org/lkml/20210520083144.GD14190@xsang-OptiPlex-9020/
[2] 8cc621d2f45d, mm: fs: invalidate BH LRU during page migration

Link: https://lkml.kernel.org/r/20210907212347.1977686-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
Tested-by: "Xing, Zhengjun" <zhengjun.xing@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    8 ++++++--
 include/linux/buffer_head.h |    4 ++--
 mm/swap.c                   |   19 ++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~mm-fs-invalidate-bh_lrus-for-only-cold-path
+++ a/fs/buffer.c
@@ -1425,12 +1425,16 @@ void invalidate_bh_lrus(void)
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
-void invalidate_bh_lrus_cpu(int cpu)
+/*
+ * It's called from workqueue context so we need a bh_lru_lock to close
+ * the race with preemption/irq.
+ */
+void invalidate_bh_lrus_cpu(void)
 {
 	struct bh_lru *b;
 
 	bh_lru_lock();
-	b = per_cpu_ptr(&bh_lrus, cpu);
+	b = this_cpu_ptr(&bh_lrus);
 	__invalidate_bh_lrus(b);
 	bh_lru_unlock();
 }
--- a/include/linux/buffer_head.h~mm-fs-invalidate-bh_lrus-for-only-cold-path
+++ a/include/linux/buffer_head.h
@@ -194,7 +194,7 @@ void __breadahead_gfp(struct block_devic
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
-void invalidate_bh_lrus_cpu(int cpu);
+void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
@@ -408,7 +408,7 @@ static inline int inode_has_buffers(stru
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
-static inline void invalidate_bh_lrus_cpu(int cpu) {}
+static inline void invalidate_bh_lrus_cpu(void) {}
 static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
 #define buffer_heads_over_limit 0
 
--- a/mm/swap.c~mm-fs-invalidate-bh_lrus-for-only-cold-path
+++ a/mm/swap.c
@@ -620,7 +620,6 @@ void lru_add_drain_cpu(int cpu)
 		pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 
 	activate_page_drain(cpu);
-	invalidate_bh_lrus_cpu(cpu);
 }
 
 /**
@@ -703,6 +702,20 @@ void lru_add_drain(void)
 	local_unlock(&lru_pvecs.lock);
 }
 
+/*
+ * It's called from per-cpu workqueue context in SMP case so
+ * lru_add_drain_cpu and invalidate_bh_lrus_cpu should run on
+ * the same cpu. It shouldn't be a problem in !SMP case since
+ * the core is only one and the locks will disable preemption.
+ */
+static void lru_add_and_bh_lrus_drain(void)
+{
+	local_lock(&lru_pvecs.lock);
+	lru_add_drain_cpu(smp_processor_id());
+	local_unlock(&lru_pvecs.lock);
+	invalidate_bh_lrus_cpu();
+}
+
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
 	local_lock(&lru_pvecs.lock);
@@ -717,7 +730,7 @@ static DEFINE_PER_CPU(struct work_struct
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
-	lru_add_drain();
+	lru_add_and_bh_lrus_drain();
 }
 
 /*
@@ -858,7 +871,7 @@ void lru_cache_disable(void)
 	 */
 	__lru_add_drain_all(true);
 #else
-	lru_add_drain();
+	lru_add_and_bh_lrus_drain();
 #endif
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fs-invalidate-bh_lrus-for-only-cold-path.patch

