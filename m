Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409E9C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09747207CF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgL2THu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 14:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgL2THu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 14:07:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A337E207BD;
        Tue, 29 Dec 2020 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609268829;
        bh=v7Gc/UmU7vUJIP95GCQQvPvzOeS9dxcqAStGSAQSVBY=;
        h=Date:From:To:Subject:From;
        b=hgGA1TxngqFW9I3F1ROP5BrQES/owl3FxihIvZBx9E5m5nAP2xr2JjriFmbkBfcyc
         By8by6jCxRkqF1yN3VtzZoRLCGm7/ann0XNvDtZYtS+NC6smaf405+RfjRE0QhKcgR
         3Vr8fvm/eHbVeMI2zYmRJ+K1RdC4DiIA/Vn6VrgU=
Date:   Tue, 29 Dec 2020 11:07:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jiasheng.shi@iluvatar.ai,
        sjhuang@iluvatar.ai
Subject:  + lib-genalloc-fix-the-overflow-when-size-is-too-big.patch
 added to -mm tree
Message-ID: <20201229190709.pU8hf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc: fix the overflow when size is too big
has been added to the -mm tree.  Its filename is
     lib-genalloc-fix-the-overflow-when-size-is-too-big.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-genalloc-fix-the-overflow-when-size-is-too-big.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-genalloc-fix-the-overflow-when-size-is-too-big.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <sjhuang@iluvatar.ai>
Subject: lib/genalloc: fix the overflow when size is too big

Some graphic card has very big memory on chip, such as 32G bytes.

In the following case, it will cause overflow:
  --------------------------------------------
  pool = gen_pool_create(PAGE_SHIFT, NUMA_NO_NODE);
  ret = gen_pool_add(pool, 0x1000000, SZ_32G, NUMA_NO_NODE);

  va = gen_pool_alloc(pool, SZ_4G);
  --------------------------------------------

The overflow occurs in gen_pool_alloc_algo_owner():

  --------------------------------------------
		....
		size = nbits << order;
		....
  --------------------------------------------

The @nbits is "int" type, so it will overflow.
Then the gen_pool_avail() will return the wrong value.

This patch converts some "int" to "unsigned long", and
changes the compare code in while.

Link: https://lkml.kernel.org/r/20201229060657.3389-1-sjhuang@iluvatar.ai
Reported-by: Shi Jiasheng <jiasheng.shi@iluvatar.ai>
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/lib/genalloc.c~lib-genalloc-fix-the-overflow-when-size-is-too-big
+++ a/lib/genalloc.c
@@ -81,14 +81,14 @@ static int clear_bits_ll(unsigned long *
  * users set the same bit, one user will return remain bits, otherwise
  * return 0.
  */
-static int bitmap_set_ll(unsigned long *map, int start, int nr)
+static int bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned long size = start + nr;
 	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_set >= 0) {
+	while (nr >= bits_to_set) {
 		if (set_bits_ll(p, mask_to_set))
 			return nr;
 		nr -= bits_to_set;
@@ -116,14 +116,15 @@ static int bitmap_set_ll(unsigned long *
  * users clear the same bit, one user will return remain bits,
  * otherwise return 0.
  */
-static int bitmap_clear_ll(unsigned long *map, int start, int nr)
+static unsigned long
+bitmap_clear_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned long size = start + nr;
 	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_clear >= 0) {
+	while (nr >= bits_to_clear) {
 		if (clear_bits_ll(p, mask_to_clear))
 			return nr;
 		nr -= bits_to_clear;
@@ -183,8 +184,8 @@ int gen_pool_add_owner(struct gen_pool *
 		 size_t size, int nid, void *owner)
 {
 	struct gen_pool_chunk *chunk;
-	int nbits = size >> pool->min_alloc_order;
-	int nbytes = sizeof(struct gen_pool_chunk) +
+	unsigned long nbits = size >> pool->min_alloc_order;
+	unsigned long nbytes = sizeof(struct gen_pool_chunk) +
 				BITS_TO_LONGS(nbits) * sizeof(long);
 
 	chunk = vzalloc_node(nbytes, nid);
@@ -242,7 +243,7 @@ void gen_pool_destroy(struct gen_pool *p
 	struct list_head *_chunk, *_next_chunk;
 	struct gen_pool_chunk *chunk;
 	int order = pool->min_alloc_order;
-	int bit, end_bit;
+	unsigned long bit, end_bit;
 
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
@@ -278,7 +279,7 @@ unsigned long gen_pool_alloc_algo_owner(
 	struct gen_pool_chunk *chunk;
 	unsigned long addr = 0;
 	int order = pool->min_alloc_order;
-	int nbits, start_bit, end_bit, remain;
+	unsigned long nbits, start_bit, end_bit, remain;
 
 #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	BUG_ON(in_nmi());
@@ -487,7 +488,7 @@ void gen_pool_free_owner(struct gen_pool
 {
 	struct gen_pool_chunk *chunk;
 	int order = pool->min_alloc_order;
-	int start_bit, nbits, remain;
+	unsigned long start_bit, nbits, remain;
 
 #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	BUG_ON(in_nmi());
@@ -755,7 +756,7 @@ unsigned long gen_pool_best_fit(unsigned
 	index = bitmap_find_next_zero_area(map, size, start, nr, 0);
 
 	while (index < size) {
-		int next_bit = find_next_bit(map, size, index + nr);
+		unsigned long next_bit = find_next_bit(map, size, index + nr);
 		if ((next_bit - index) < len) {
 			len = next_bit - index;
 			start_bit = index;
_

Patches currently in -mm which might be from sjhuang@iluvatar.ai are

sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch
lib-genalloc-fix-the-overflow-when-size-is-too-big.patch

