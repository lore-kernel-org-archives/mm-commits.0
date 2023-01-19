Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED3BC6379F
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 23:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjASXAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjASW7O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:59:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2AF5143C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11CAF61D78
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3A7C433D2;
        Thu, 19 Jan 2023 22:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168467;
        bh=MDlMckS9ChYQ+Z9vjRxMEtP6vy9jF51YEEbfP1BuvyY=;
        h=Date:To:From:Subject:From;
        b=BQgtMRAbtIZak+eU5m6tFw1B3gjnsg2JNF6/uwnkgOYSko1CmYk0aZHnKD73H/7yd
         +YpU9mDbHLV8DnnbQC/4p7d1RwQ8Sbd7aQSjJHSo1EkBtsP2K1kbs7Q7OYzgANkTyf
         akVXazqPE64+nLD0VfZjPJBDDkVoqevNecwQnV7c=
Date:   Thu, 19 Jan 2023 14:47:46 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-section-for-bloom-filters.patch added to mm-unstable branch
Message-Id: <20230119224747.5E3A7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: section for Bloom filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-section-for-bloom-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-section-for-bloom-filters.patch

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

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch

