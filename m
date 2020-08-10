Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4BBC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 718722076C
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026888;
	bh=bFJagmgB1/xJcqa56LcP2MTOLD1S1TgZWXE4EXiROvA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2BskTdA52qvD6RXw9vNV8JtFm39S5N7fbu8EHQWaRfLKcEO+2i8eCB0rqImSrTr/o
	 qUrDxF9Qy/RpRrO+o71JRvvhwCRI7N67uqum6gFwhUdAbWwv3V1r6IJY/OXYmvbyau
	 d8tFs4UEU4JQO67Ayj/M3Qx4SW9RgCfW1trVh+4A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCes (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D3D52073E;
        Mon, 10 Aug 2020 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026886;
        bh=bFJagmgB1/xJcqa56LcP2MTOLD1S1TgZWXE4EXiROvA=;
        h=Date:From:To:Subject:From;
        b=R3v4w1cYzrVZhR/06bgmJc3w7zjwlWU6hxDttpZ4hnxYlpF6g4GacaBXK2dqFuupm
         7iiXVueUFQGiOX+qEGmkM2LBtY1miEm+G8QW94h/i9bYtPZnueMTnquaTA1H/pzaln
         fzPh8631q1/BFq5N2Gi1rtTKQyZ2sepCIELE4+2U=
Date:   Sun, 09 Aug 2020 19:34:46 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, lonuxli.64@gmail.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  [merged]
 mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch
 removed from -mm tree
Message-ID: <20200810023446.b6eGUKIu0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: check GFP_SLAB_BUG_MASK before alloc_pages in kmalloc_order
has been removed from the -mm tree.  Its filename was
     mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Long Li <lonuxli.64@gmail.com>
Subject: mm, slab: check GFP_SLAB_BUG_MASK before alloc_pages in kmalloc_order

kmalloc cannot allocate memory from HIGHMEM.  Allocating large amounts of
memory currently bypasses the check and will simply leak the memory when
page_address() returns NULL.  To fix this, factor the GFP_SLAB_BUG_MASK
check out of slab & slub, and call it from kmalloc_order() as well.  In
order to make the code clear, the warning message is put in one place.

Link: http://lkml.kernel.org/r/20200704035027.GA62481@lilong
Signed-off-by: Long Li <lonuxli.64@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   10 +++-------
 mm/slab.h        |    1 +
 mm/slab_common.c |   17 +++++++++++++++++
 mm/slub.c        |    9 ++-------
 4 files changed, 23 insertions(+), 14 deletions(-)

--- a/mm/slab.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab.c
@@ -2589,13 +2589,9 @@ static struct page *cache_grow_begin(str
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		flags &= ~GFP_SLAB_BUG_MASK;
-		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-				invalid_mask, &invalid_mask, flags, &flags);
-		dump_stack();
-	}
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
+
 	WARN_ON_ONCE(cachep->ctor && (flags & __GFP_ZERO));
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
--- a/mm/slab_common.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab_common.c
@@ -26,6 +26,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
+#include "internal.h"
+
 #include "slab.h"
 
 enum slab_state slab_state;
@@ -1332,6 +1334,18 @@ void __init create_kmalloc_caches(slab_f
 }
 #endif /* !CONFIG_SLOB */
 
+gfp_t kmalloc_fix_flags(gfp_t flags)
+{
+	gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+
+	flags &= ~GFP_SLAB_BUG_MASK;
+	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+			invalid_mask, &invalid_mask, flags, &flags);
+	dump_stack();
+
+	return flags;
+}
+
 /*
  * To avoid unnecessary overhead, we pass through large allocation requests
  * directly to the page allocator. We use __GFP_COMP, because we will need to
@@ -1342,6 +1356,9 @@ void *kmalloc_order(size_t size, gfp_t f
 	void *ret = NULL;
 	struct page *page;
 
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
+
 	flags |= __GFP_COMP;
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
--- a/mm/slab.h~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slab.h
@@ -152,6 +152,7 @@ void create_kmalloc_caches(slab_flags_t)
 struct kmem_cache *kmalloc_slab(size_t, gfp_t);
 #endif
 
+gfp_t kmalloc_fix_flags(gfp_t flags);
 
 /* Functions provided by the slab allocators */
 int __kmem_cache_create(struct kmem_cache *, slab_flags_t flags);
--- a/mm/slub.c~mm-slab-check-gfp_slab_bug_mask-before-alloc_pages-in-kmalloc_order
+++ a/mm/slub.c
@@ -1745,13 +1745,8 @@ out:
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
-	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
-		flags &= ~GFP_SLAB_BUG_MASK;
-		pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-				invalid_mask, &invalid_mask, flags, &flags);
-		dump_stack();
-	}
+	if (unlikely(flags & GFP_SLAB_BUG_MASK))
+		flags = kmalloc_fix_flags(flags);
 
 	return allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
_

Patches currently in -mm which might be from lonuxli.64@gmail.com are


