Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D39C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5594E610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347568AbhIBVvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhIBVvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 553BD610A0;
        Thu,  2 Sep 2021 21:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619450;
        bh=KWrm3Sy8ghXnF8XMot/QoeNe0iKIN4iUJiMu1qrl+fE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iJ3QWv6zmLOYRjiVSpyR1KRelbJD1rAF+PCvdYNAeyGmJsizy3jQEgSXG88phMK41
         RUNjBG56+NVCxPEmYdfRLNwCPUPtvRYWCjn70salk4FaxJi4ARqzmiQTr4GoEFl+QY
         bwGoaphkJcF/Dl+j5migOIgnkYQFsL32650FqqLE=
Date:   Thu, 02 Sep 2021 14:50:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 017/212] mm, slub: return slab page from
 get_partial() and set c->page afterwards
Message-ID: <20210902215049.JvQwETkZs%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: return slab page from get_partial() and set c->page afterwards

The function get_partial() finds a suitable page on a partial list,
acquires and returns its freelist and assigns the page pointer to
kmem_cache_cpu.  In later patch we will need more control over the
kmem_cache_cpu.page assignment, so instead of passing a kmem_cache_cpu
pointer, pass a pointer to a pointer to a page that get_partial() can fill
and the caller can assign the kmem_cache_cpu.page pointer.  No functional
change as all of this still happens with disabled IRQs.

Link: https://lkml.kernel.org/r/20210805152000.12817-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/slub.c~mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards
+++ a/mm/slub.c
@@ -2003,7 +2003,7 @@ static inline bool pfmemalloc_match(stru
  * Try to allocate a partial slab from a specific node.
  */
 static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
-				struct kmem_cache_cpu *c, gfp_t flags)
+			      struct page **ret_page, gfp_t flags)
 {
 	struct page *page, *page2;
 	void *object = NULL;
@@ -2032,7 +2032,7 @@ static void *get_partial_node(struct kme
 
 		available += objects;
 		if (!object) {
-			c->page = page;
+			*ret_page = page;
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 		} else {
@@ -2052,7 +2052,7 @@ static void *get_partial_node(struct kme
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
 static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
-		struct kmem_cache_cpu *c)
+			     struct page **ret_page)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
@@ -2094,7 +2094,7 @@ static void *get_any_partial(struct kmem
 
 			if (n && cpuset_zone_allowed(zone, flags) &&
 					n->nr_partial > s->min_partial) {
-				object = get_partial_node(s, n, c, flags);
+				object = get_partial_node(s, n, ret_page, flags);
 				if (object) {
 					/*
 					 * Don't check read_mems_allowed_retry()
@@ -2116,7 +2116,7 @@ static void *get_any_partial(struct kmem
  * Get a partial page, lock it and return it.
  */
 static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
-		struct kmem_cache_cpu *c)
+			 struct page **ret_page)
 {
 	void *object;
 	int searchnode = node;
@@ -2124,11 +2124,11 @@ static void *get_partial(struct kmem_cac
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
 
-	object = get_partial_node(s, get_node(s, searchnode), c, flags);
+	object = get_partial_node(s, get_node(s, searchnode), ret_page, flags);
 	if (object || node != NUMA_NO_NODE)
 		return object;
 
-	return get_any_partial(s, flags, c);
+	return get_any_partial(s, flags, ret_page);
 }
 
 #ifdef CONFIG_PREEMPTION
@@ -2740,9 +2740,11 @@ new_slab:
 		goto redo;
 	}
 
-	freelist = get_partial(s, gfpflags, node, c);
-	if (freelist)
+	freelist = get_partial(s, gfpflags, node, &page);
+	if (freelist) {
+		c->page = page;
 		goto check_new_page;
+	}
 
 	page = new_slab(s, gfpflags, node);
 
@@ -2766,7 +2768,6 @@ new_slab:
 	c->page = page;
 
 check_new_page:
-	page = c->page;
 	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
 		goto load_freelist;
 
_
