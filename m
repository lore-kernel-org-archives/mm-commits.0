Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0363AC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBCGnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjBCGlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97BB759
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B5CB61DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B13C433D2;
        Fri,  3 Feb 2023 06:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406291;
        bh=I+hYZtAlsYYH3f7L6xIH8VAWI3lYwqHo+FyDdgXU/zw=;
        h=Date:To:From:Subject:From;
        b=Z2Wdou6JQS6WZqkOA34FAJLCIqstVuVBlw66/zCnFEWCQM2iyGxKJKGBlTQy0erTJ
         UgzjysRf5hiYxXBEC9IfUx20js7lWPeYxMuP5NFt7uPQmm/Fv5OoDbU6r58DZlS1nt
         CLHcACJwuCTEOyMBydSzBoVwo3c2CbNUsHm6+5tE=
Date:   Thu, 02 Feb 2023 22:38:10 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-section-for-bloom-filters.patch removed from -mm tree
Message-Id: <20230203063811.72B13C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: section for Bloom filters
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-section-for-bloom-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: section for Bloom filters
Date: Wed, 18 Jan 2023 00:18:23 +0000

Move Bloom filters code into a dedicated section.  Improve the design doc
to explain Bloom filter usage and connection between aging and eviction in
their use.

Link: https://lkml.kernel.org/r/20230118001827.1040870-4-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/multigen_lru.rst~mm-multi-gen-lru-section-for-bloom-filters
+++ a/Documentation/mm/multigen_lru.rst
@@ -170,6 +170,22 @@ promotes hot pages. If the scan was done
 adds the PMD entry pointing to the PTE table to the Bloom filter. This
 forms a feedback loop between the eviction and the aging.
 
+Bloom Filters
+-------------
+Bloom filters are a space and memory efficient data structure for set
+membership test, i.e., test if an element is not in the set or may be
+in the set.
+
+In the eviction path, specifically, in ``lru_gen_look_around()``, if a
+PMD has a sufficient number of hot pages, its address is placed in the
+filter. In the aging path, set membership means that the PTE range
+will be scanned for young pages.
+
+Note that Bloom filters are probabilistic on set membership. If a test
+is false positive, the cost is an additional scan of a range of PTEs,
+which may yield hot pages anyway. Parameters of the filter itself can
+control the false positive rate in the limit.
+
 Summary
 -------
 The multi-gen LRU can be disassembled into the following parts:
--- a/mm/vmscan.c~mm-multi-gen-lru-section-for-bloom-filters
+++ a/mm/vmscan.c
@@ -3234,6 +3234,98 @@ static bool __maybe_unused seq_is_valid(
 }
 
 /******************************************************************************
+ *                          Bloom filters
+ ******************************************************************************/
+
+/*
+ * Bloom filters with m=1<<15, k=2 and the false positive rates of ~1/5 when
+ * n=10,000 and ~1/2 when n=20,000, where, conventionally, m is the number of
+ * bits in a bitmap, k is the number of hash functions and n is the number of
+ * inserted items.
+ *
+ * Page table walkers use one of the two filters to reduce their search space.
+ * To get rid of non-leaf entries that no longer have enough leaf entries, the
+ * aging uses the double-buffering technique to flip to the other filter each
+ * time it produces a new generation. For non-leaf entries that have enough
+ * leaf entries, the aging carries them over to the next generation in
+ * walk_pmd_range(); the eviction also report them when walking the rmap
+ * in lru_gen_look_around().
+ *
+ * For future optimizations:
+ * 1. It's not necessary to keep both filters all the time. The spare one can be
+ *    freed after the RCU grace period and reallocated if needed again.
+ * 2. And when reallocating, it's worth scaling its size according to the number
+ *    of inserted entries in the other filter, to reduce the memory overhead on
+ *    small systems and false positives on large systems.
+ * 3. Jenkins' hash function is an alternative to Knuth's.
+ */
+#define BLOOM_FILTER_SHIFT	15
+
+static inline int filter_gen_from_seq(unsigned long seq)
+{
+	return seq % NR_BLOOM_FILTERS;
+}
+
+static void get_item_key(void *item, int *key)
+{
+	u32 hash = hash_ptr(item, BLOOM_FILTER_SHIFT * 2);
+
+	BUILD_BUG_ON(BLOOM_FILTER_SHIFT * 2 > BITS_PER_TYPE(u32));
+
+	key[0] = hash & (BIT(BLOOM_FILTER_SHIFT) - 1);
+	key[1] = hash >> BLOOM_FILTER_SHIFT;
+}
+
+static bool test_bloom_filter(struct lruvec *lruvec, unsigned long seq, void *item)
+{
+	int key[2];
+	unsigned long *filter;
+	int gen = filter_gen_from_seq(seq);
+
+	filter = READ_ONCE(lruvec->mm_state.filters[gen]);
+	if (!filter)
+		return true;
+
+	get_item_key(item, key);
+
+	return test_bit(key[0], filter) && test_bit(key[1], filter);
+}
+
+static void update_bloom_filter(struct lruvec *lruvec, unsigned long seq, void *item)
+{
+	int key[2];
+	unsigned long *filter;
+	int gen = filter_gen_from_seq(seq);
+
+	filter = READ_ONCE(lruvec->mm_state.filters[gen]);
+	if (!filter)
+		return;
+
+	get_item_key(item, key);
+
+	if (!test_bit(key[0], filter))
+		set_bit(key[0], filter);
+	if (!test_bit(key[1], filter))
+		set_bit(key[1], filter);
+}
+
+static void reset_bloom_filter(struct lruvec *lruvec, unsigned long seq)
+{
+	unsigned long *filter;
+	int gen = filter_gen_from_seq(seq);
+
+	filter = lruvec->mm_state.filters[gen];
+	if (filter) {
+		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
+		return;
+	}
+
+	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
+			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	WRITE_ONCE(lruvec->mm_state.filters[gen], filter);
+}
+
+/******************************************************************************
  *                          mm_struct list
  ******************************************************************************/
 
@@ -3352,94 +3444,6 @@ void lru_gen_migrate_mm(struct mm_struct
 }
 #endif
 
-/*
- * Bloom filters with m=1<<15, k=2 and the false positive rates of ~1/5 when
- * n=10,000 and ~1/2 when n=20,000, where, conventionally, m is the number of
- * bits in a bitmap, k is the number of hash functions and n is the number of
- * inserted items.
- *
- * Page table walkers use one of the two filters to reduce their search space.
- * To get rid of non-leaf entries that no longer have enough leaf entries, the
- * aging uses the double-buffering technique to flip to the other filter each
- * time it produces a new generation. For non-leaf entries that have enough
- * leaf entries, the aging carries them over to the next generation in
- * walk_pmd_range(); the eviction also report them when walking the rmap
- * in lru_gen_look_around().
- *
- * For future optimizations:
- * 1. It's not necessary to keep both filters all the time. The spare one can be
- *    freed after the RCU grace period and reallocated if needed again.
- * 2. And when reallocating, it's worth scaling its size according to the number
- *    of inserted entries in the other filter, to reduce the memory overhead on
- *    small systems and false positives on large systems.
- * 3. Jenkins' hash function is an alternative to Knuth's.
- */
-#define BLOOM_FILTER_SHIFT	15
-
-static inline int filter_gen_from_seq(unsigned long seq)
-{
-	return seq % NR_BLOOM_FILTERS;
-}
-
-static void get_item_key(void *item, int *key)
-{
-	u32 hash = hash_ptr(item, BLOOM_FILTER_SHIFT * 2);
-
-	BUILD_BUG_ON(BLOOM_FILTER_SHIFT * 2 > BITS_PER_TYPE(u32));
-
-	key[0] = hash & (BIT(BLOOM_FILTER_SHIFT) - 1);
-	key[1] = hash >> BLOOM_FILTER_SHIFT;
-}
-
-static void reset_bloom_filter(struct lruvec *lruvec, unsigned long seq)
-{
-	unsigned long *filter;
-	int gen = filter_gen_from_seq(seq);
-
-	filter = lruvec->mm_state.filters[gen];
-	if (filter) {
-		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
-		return;
-	}
-
-	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
-			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(lruvec->mm_state.filters[gen], filter);
-}
-
-static void update_bloom_filter(struct lruvec *lruvec, unsigned long seq, void *item)
-{
-	int key[2];
-	unsigned long *filter;
-	int gen = filter_gen_from_seq(seq);
-
-	filter = READ_ONCE(lruvec->mm_state.filters[gen]);
-	if (!filter)
-		return;
-
-	get_item_key(item, key);
-
-	if (!test_bit(key[0], filter))
-		set_bit(key[0], filter);
-	if (!test_bit(key[1], filter))
-		set_bit(key[1], filter);
-}
-
-static bool test_bloom_filter(struct lruvec *lruvec, unsigned long seq, void *item)
-{
-	int key[2];
-	unsigned long *filter;
-	int gen = filter_gen_from_seq(seq);
-
-	filter = READ_ONCE(lruvec->mm_state.filters[gen]);
-	if (!filter)
-		return true;
-
-	get_item_key(item, key);
-
-	return test_bit(key[0], filter) && test_bit(key[1], filter);
-}
-
 static void reset_mm_stats(struct lruvec *lruvec, struct lru_gen_mm_walk *walk, bool last)
 {
 	int i;
_

Patches currently in -mm which might be from talumbau@google.com are


