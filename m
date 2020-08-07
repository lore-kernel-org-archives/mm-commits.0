Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12121C433E3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38162177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781110;
	bh=bLXsSO4PYwiWR+nIydy2OM59iaBT655q2XOxHr6Tvhc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=pVM9geHYF9CNoYzdSvDTtdD9Ru2aRJYwqmZLk+chCnbQB8BwRm81A1slFnX/d+Hww
	 BkUmUtVz9IdvBJJcCWWb0RiZSE2rm660pHyxV8X/UEGT83r1uuyi8YHgPq5YUUPswB
	 8n8HEy64d6EgNv1z0MPZUS6CGs6WBU9uXjk2FUeA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHGGSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGS3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40B5221E5;
        Fri,  7 Aug 2020 06:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781109;
        bh=bLXsSO4PYwiWR+nIydy2OM59iaBT655q2XOxHr6Tvhc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TQ43bzDiCoMebEiQWYBbs9j92w3neI36upBlFewSuitT105Z/elXSVK8fTa663D2f
         QxxyydE15+PgjkIpMqTcBYK4pXJOHBlW1l/Kwq124k0F9jX2nMgTJAl9iswQzLNizE
         2ScqvmEWdW+dlCi7JU3upIcdCZAXTa0+aQ/Bl8MY=
Date:   Thu, 06 Aug 2020 23:18:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, lonuxli.64@gmail.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 026/163] mm, slab: check GFP_SLAB_BUG_MASK before
 alloc_pages in kmalloc_order
Message-ID: <20200807061828.uPsWNduYb%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
