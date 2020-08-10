Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C173C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF3020723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026994;
	bh=OGEtlcZQRiKaSm3TU5HVSBN/e5SnWK2eeMiRuH4wJMM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EglrknGcNKm9ndkyq+ynceFenYnat/oWP08qRK6ic7BE4c+pqatI/rjZtgsv04xwk
	 Y0YQjlksFA7PRI11anxMlK1q1DAFpnj6hYOhautelxT0dxMIGGpcNg7T/cqsqskrAA
	 IS+zylobU/D9stsrSFug43slSJQWAsRP2NE3VLmU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJCgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B32C2065D;
        Mon, 10 Aug 2020 02:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026991;
        bh=OGEtlcZQRiKaSm3TU5HVSBN/e5SnWK2eeMiRuH4wJMM=;
        h=Date:From:To:Subject:From;
        b=SjnNJaDhm4XqxgO60ILNECcwSGIsqPHqyw7AEuy/1TNxveWk5tDvhunXrH3IQoA0b
         djmzqOqMaBXaWpARy3qE8lY0DViibJkxCxnC62MY/a+j6mUas+0uSKa6FJXfmXWlx2
         u6NdB3cszh9sL0YD17B4fS26l3DWx6HIcFaFnCqA=
Date:   Sun, 09 Aug 2020 19:36:31 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-slub-implement-slub-version-of-obj_to_index.patch removed from -mm tree
Message-ID: <20200810023631.k_33Mhlv5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: implement SLUB version of obj_to_index()
has been removed from the -mm tree.  Its filename was
     mm-slub-implement-slub-version-of-obj_to_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: slub: implement SLUB version of obj_to_index()

This commit implements SLUB version of the obj_to_index() function, which
will be required to calculate the offset of obj_cgroup in the obj_cgroups
vector to store/obtain the objcg ownership data.

To make it faster, let's repeat the SLAB's trick introduced by commit
6a2d7a955d8d ("SLAB: use a multiply instead of a divide in
obj_to_index()") and avoid an expensive division.

Vlastimil Babka noticed, that SLUB does have already a similar function
called slab_index(), which is defined only if SLUB_DEBUG is enabled.  The
function does a similar math, but with a division, and it also takes a
page address instead of a page pointer.

Let's remove slab_index() and replace it with the new helper
__obj_to_index(), which takes a page address.  obj_to_index() will be a
simple wrapper taking a page pointer and passing page_address(page) into
__obj_to_index().

Link: http://lkml.kernel.org/r/20200623174037.3951353-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   16 ++++++++++++++++
 mm/slub.c                |   15 +++++----------
 2 files changed, 21 insertions(+), 10 deletions(-)

--- a/include/linux/slub_def.h~mm-slub-implement-slub-version-of-obj_to_index
+++ a/include/linux/slub_def.h
@@ -8,6 +8,7 @@
  * (C) 2007 SGI, Christoph Lameter
  */
 #include <linux/kobject.h>
+#include <linux/reciprocal_div.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -86,6 +87,7 @@ struct kmem_cache {
 	unsigned long min_partial;
 	unsigned int size;	/* The size of an object including metadata */
 	unsigned int object_size;/* The size of an object without metadata */
+	struct reciprocal_value reciprocal_size;
 	unsigned int offset;	/* Free pointer offset */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	/* Number of per cpu partial objects to keep around */
@@ -182,4 +184,18 @@ static inline void *nearest_obj(struct k
 	return result;
 }
 
+/* Determine object index from a given position */
+static inline unsigned int __obj_to_index(const struct kmem_cache *cache,
+					  void *addr, void *obj)
+{
+	return reciprocal_divide(kasan_reset_tag(obj) - addr,
+				 cache->reciprocal_size);
+}
+
+static inline unsigned int obj_to_index(const struct kmem_cache *cache,
+					const struct page *page, void *obj)
+{
+	return __obj_to_index(cache, page_address(page), obj);
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
--- a/mm/slub.c~mm-slub-implement-slub-version-of-obj_to_index
+++ a/mm/slub.c
@@ -317,12 +317,6 @@ static inline void set_freepointer(struc
 		__p < (__addr) + (__objects) * (__s)->size; \
 		__p += (__s)->size)
 
-/* Determine object index from a given position */
-static inline unsigned int slab_index(void *p, struct kmem_cache *s, void *addr)
-{
-	return (kasan_reset_tag(p) - addr) / s->size;
-}
-
 static inline unsigned int order_objects(unsigned int order, unsigned int size)
 {
 	return ((unsigned int)PAGE_SIZE << order) / size;
@@ -465,7 +459,7 @@ static unsigned long *get_map(struct kme
 	bitmap_zero(object_map, page->objects);
 
 	for (p = page->freelist; p; p = get_freepointer(s, p))
-		set_bit(slab_index(p, s, addr), object_map);
+		set_bit(__obj_to_index(s, addr, p), object_map);
 
 	return object_map;
 }
@@ -3754,6 +3748,7 @@ static int calculate_sizes(struct kmem_c
 	 */
 	size = ALIGN(size, s->align);
 	s->size = size;
+	s->reciprocal_size = reciprocal_value(size);
 	if (forced_order >= 0)
 		order = forced_order;
 	else
@@ -3858,7 +3853,7 @@ static void list_slab_objects(struct kme
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
 
-		if (!test_bit(slab_index(p, s, addr), map)) {
+		if (!test_bit(__obj_to_index(s, addr, p), map)) {
 			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);
 			print_tracking(s, p);
 		}
@@ -4574,7 +4569,7 @@ static void validate_slab(struct kmem_ca
 	/* Now we know that a valid freelist exists */
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
-		u8 val = test_bit(slab_index(p, s, addr), map) ?
+		u8 val = test_bit(__obj_to_index(s, addr, p), map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
 		if (!check_object(s, page, p, val))
@@ -4765,7 +4760,7 @@ static void process_slab(struct loc_trac
 
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects)
-		if (!test_bit(slab_index(p, s, addr), map))
+		if (!test_bit(__obj_to_index(s, addr, p), map))
 			add_location(t, s, get_track(s, p, alloc));
 	put_map(map);
 }
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

