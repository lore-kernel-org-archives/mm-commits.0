Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89687C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF3C221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781244;
	bh=QEkddzHsPzcFJl6bK129y1bGxKDyUlj86tDV9kStRPo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=C18KfZ8lyOTe8rBAObvwHFGBafHmGlJAhIcKhrRgm84YpAd4ehOVAPXZ0WIWydrbs
	 1kZQSsd4KKjKUeccsW1m7hqq5Ni74rpC1YMr5ZIZzvM3AJhuyz0JYEMogyvHlIL8DZ
	 Cj2xB91n0hGNzvLZ8lMIYYrDtFMpHnm0Ku/8JFEg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgHGGUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgHGGUo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB852177B;
        Fri,  7 Aug 2020 06:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781243;
        bh=QEkddzHsPzcFJl6bK129y1bGxKDyUlj86tDV9kStRPo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cYcxa1svXcaYbEBpeQRFduBoWUh0q0ANE0f4l+8UMZTfvqSdHsLPviRkf2M2iVqWr
         oz+Ul3Ds9SHmWbO6ETgsvwaa0TS7Cpjf6s+LQLVQBG+oPQAKlSgMWApwTzC/WNgWBu
         qtLqUokD4bW3eEnnUtWmNupe5mFk5JHEnB14ZekA=
Date:   Thu, 06 Aug 2020 23:20:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 065/163] mm: slub: implement SLUB version of
 obj_to_index()
Message-ID: <20200807062042.okGJP8Ttd%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
