Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5610AC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF5364F27
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhBXUDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235276AbhBXUCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C946D64F27;
        Wed, 24 Feb 2021 20:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196880;
        bh=jJmBw70Q4ZmcE00zu4Pf1un0MifT4w1jTt1CpNzF+Ew=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xWu6QaUQY9OnoibF1/q20w8jpMApfD41tmLHFMUR2+tfLAJIxlHa8jJw4ZnJ3jCME
         CGty2LpA4YB9OBM4O5aDJHQWJaORuj2c1cMHTQs0fEYgJxT7dqb0iZvVsyvhr/vOrs
         AOxaCYd7qFCmVpj9a7DqhWtWhF4MqTRL/eskSULg=
Date:   Wed, 24 Feb 2021 12:01:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 021/173] mm, slub: splice cpu and page freelists
 in deactivate_slab()
Message-ID: <20210224200119.Ytx7rYOAU%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: splice cpu and page freelists in deactivate_slab()

In deactivate_slab() we currently move all but one objects on the cpu
freelist to the page freelist one by one using the costly cmpxchg_double()
operation.  Then we unfreeze the page while moving the last object on page
freelist, with a final cmpxchg_double().

This can be optimized to avoid the cmpxchg_double() per object.  Just
count the objects on cpu freelist (to adjust page->inuse properly) and
also remember the last object in the chain.  Then splice page->freelist to
the last object and effectively add the whole cpu freelist to
page->freelist while unfreezing the page, with a single cmpxchg_double().

Link: https://lkml.kernel.org/r/20210115183543.15097-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   59 +++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

--- a/mm/slub.c~mm-slub-splice-cpu-and-page-freelists-in-deactivate_slab
+++ a/mm/slub.c
@@ -2167,9 +2167,9 @@ static void deactivate_slab(struct kmem_
 {
 	enum slab_modes { M_NONE, M_PARTIAL, M_FULL, M_FREE };
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-	int lock = 0;
+	int lock = 0, free_delta = 0;
 	enum slab_modes l = M_NONE, m = M_NONE;
-	void *nextfree;
+	void *nextfree, *freelist_iter, *freelist_tail;
 	int tail = DEACTIVATE_TO_HEAD;
 	struct page new;
 	struct page old;
@@ -2180,45 +2180,34 @@ static void deactivate_slab(struct kmem_
 	}
 
 	/*
-	 * Stage one: Free all available per cpu objects back
-	 * to the page freelist while it is still frozen. Leave the
-	 * last one.
-	 *
-	 * There is no need to take the list->lock because the page
-	 * is still frozen.
+	 * Stage one: Count the objects on cpu's freelist as free_delta and
+	 * remember the last object in freelist_tail for later splicing.
 	 */
-	while (freelist && (nextfree = get_freepointer(s, freelist))) {
-		void *prior;
-		unsigned long counters;
+	freelist_tail = NULL;
+	freelist_iter = freelist;
+	while (freelist_iter) {
+		nextfree = get_freepointer(s, freelist_iter);
 
 		/*
 		 * If 'nextfree' is invalid, it is possible that the object at
-		 * 'freelist' is already corrupted.  So isolate all objects
-		 * starting at 'freelist'.
+		 * 'freelist_iter' is already corrupted.  So isolate all objects
+		 * starting at 'freelist_iter' by skipping them.
 		 */
-		if (freelist_corrupted(s, page, &freelist, nextfree))
+		if (freelist_corrupted(s, page, &freelist_iter, nextfree))
 			break;
 
-		do {
-			prior = page->freelist;
-			counters = page->counters;
-			set_freepointer(s, freelist, prior);
-			new.counters = counters;
-			new.inuse--;
-			VM_BUG_ON(!new.frozen);
-
-		} while (!__cmpxchg_double_slab(s, page,
-			prior, counters,
-			freelist, new.counters,
-			"drain percpu freelist"));
+		freelist_tail = freelist_iter;
+		free_delta++;
 
-		freelist = nextfree;
+		freelist_iter = nextfree;
 	}
 
 	/*
-	 * Stage two: Ensure that the page is unfrozen while the
-	 * list presence reflects the actual number of objects
-	 * during unfreeze.
+	 * Stage two: Unfreeze the page while splicing the per-cpu
+	 * freelist to the head of page's freelist.
+	 *
+	 * Ensure that the page is unfrozen while the list presence
+	 * reflects the actual number of objects during unfreeze.
 	 *
 	 * We setup the list membership and then perform a cmpxchg
 	 * with the count. If there is a mismatch then the page
@@ -2231,15 +2220,15 @@ static void deactivate_slab(struct kmem_
 	 */
 redo:
 
-	old.freelist = page->freelist;
-	old.counters = page->counters;
+	old.freelist = READ_ONCE(page->freelist);
+	old.counters = READ_ONCE(page->counters);
 	VM_BUG_ON(!old.frozen);
 
 	/* Determine target state of the slab */
 	new.counters = old.counters;
-	if (freelist) {
-		new.inuse--;
-		set_freepointer(s, freelist, old.freelist);
+	if (freelist_tail) {
+		new.inuse -= free_delta;
+		set_freepointer(s, freelist_tail, old.freelist);
 		new.freelist = freelist;
 	} else
 		new.freelist = old.freelist;
_
