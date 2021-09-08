Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9077C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9222261108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347404AbhIHCyz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347442AbhIHCy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E2F60EE6;
        Wed,  8 Sep 2021 02:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069602;
        bh=8zbw5zTrlvM+2+p8e3dG9yATGd/Pj2gzYCpsj9E6DHE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PBQNm9wlP6Vcfl/Y7J24H7R9az/H47FOQt9FawxllT/Yuge1MOIB1ybh50SWwEjrd
         4ETgg4MROUQNkV9gABFpv2MCmsNZ1OXp/TDMQ1ThPft3JFIEug9z7OTqr3CEOaqqms
         4+s9eFRIQt+NXhLGRGGAYzw2bk+IpMM5BHhHgkEM=
Date:   Tue, 07 Sep 2021 19:53:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 008/147] mm, slub: return slab page from
 get_partial() and set c->page afterwards
Message-ID: <20210908025321.U6LqQVlTz%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20210904105003.11688-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/slub.c~mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards
+++ a/mm/slub.c
@@ -2017,7 +2017,7 @@ static inline bool pfmemalloc_match(stru
  * Try to allocate a partial slab from a specific node.
  */
 static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
-				struct kmem_cache_cpu *c, gfp_t flags)
+			      struct page **ret_page, gfp_t flags)
 {
 	struct page *page, *page2;
 	void *object = NULL;
@@ -2046,7 +2046,7 @@ static void *get_partial_node(struct kme
 
 		available += objects;
 		if (!object) {
-			c->page = page;
+			*ret_page = page;
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 		} else {
@@ -2066,7 +2066,7 @@ static void *get_partial_node(struct kme
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
 static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
-		struct kmem_cache_cpu *c)
+			     struct page **ret_page)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
@@ -2108,7 +2108,7 @@ static void *get_any_partial(struct kmem
 
 			if (n && cpuset_zone_allowed(zone, flags) &&
 					n->nr_partial > s->min_partial) {
-				object = get_partial_node(s, n, c, flags);
+				object = get_partial_node(s, n, ret_page, flags);
 				if (object) {
 					/*
 					 * Don't check read_mems_allowed_retry()
@@ -2130,7 +2130,7 @@ static void *get_any_partial(struct kmem
  * Get a partial page, lock it and return it.
  */
 static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
-		struct kmem_cache_cpu *c)
+			 struct page **ret_page)
 {
 	void *object;
 	int searchnode = node;
@@ -2138,11 +2138,11 @@ static void *get_partial(struct kmem_cac
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
@@ -2754,9 +2754,11 @@ new_slab:
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
 
@@ -2780,7 +2782,6 @@ new_slab:
 	c->page = page;
 
 check_new_page:
-	page = c->page;
 	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
 		goto load_freelist;
 
_
