Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4A4C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670A2610FD
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbhIBVw1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347583AbhIBVwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4058260724;
        Thu,  2 Sep 2021 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619483;
        bh=LNhzqt8dYHvjn/OcbQ9Vm1PsVifuwKqEOVj1Pyu301c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CLiDHSpteTs5w7gspOK9gmPw679CqehXEXyIelRgBocnjv8mlTer1QcS2fnRemBxB
         M65uRjkdZJNJzvVqO5Pt8X+wXN8SQ2OYlwxVZQwA46zysaa2JgBBGRgvZcBc0huwpT
         sIiShpzoytfRv1gfptzDfnKMGznAJG2cFmr0N2NM=
Date:   Thu, 02 Sep 2021 14:51:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 027/212] mm, slub: move reset of c->page and
 freelist out of deactivate_slab()
Message-ID: <20210902215122.9-o5lK_Kg%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: move reset of c->page and freelist out of deactivate_slab()

deactivate_slab() removes the cpu slab by merging the cpu freelist with
slab's freelist and putting the slab on the proper node's list.  It also
sets the respective kmem_cache_cpu pointers to NULL.

By extracting the kmem_cache_cpu operations from the function, we can make
it not dependent on disabled irqs.

Also if we return a single free pointer from ___slab_alloc, we no longer
have to assign kmem_cache_cpu.page before deactivation or care if somebody
preempted us and assigned a different page to our kmem_cache_cpu in the
process.

Link: https://lkml.kernel.org/r/20210805152000.12817-20-vbabka@suse.cz
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

 mm/slub.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/mm/slub.c~mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab
+++ a/mm/slub.c
@@ -2195,10 +2195,13 @@ static void init_kmem_cache_cpus(struct
 }
 
 /*
- * Remove the cpu slab
+ * Finishes removing the cpu slab. Merges cpu's freelist with page's freelist,
+ * unfreezes the slabs and puts it on the proper list.
+ * Assumes the slab has been already safely taken away from kmem_cache_cpu
+ * by the caller.
  */
 static void deactivate_slab(struct kmem_cache *s, struct page *page,
-				void *freelist, struct kmem_cache_cpu *c)
+			    void *freelist)
 {
 	enum slab_modes { M_NONE, M_PARTIAL, M_FULL, M_FREE };
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
@@ -2327,9 +2330,6 @@ redo:
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
-
-	c->page = NULL;
-	c->freelist = NULL;
 }
 
 /*
@@ -2454,10 +2454,16 @@ static void put_cpu_partial(struct kmem_
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
-	stat(s, CPUSLAB_FLUSH);
-	deactivate_slab(s, c->page, c->freelist, c);
+	void *freelist = c->freelist;
+	struct page *page = c->page;
 
+	c->page = NULL;
+	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
+
+	deactivate_slab(s, page, freelist);
+
+	stat(s, CPUSLAB_FLUSH);
 }
 
 /*
@@ -2755,7 +2761,10 @@ deactivate_slab:
 		local_irq_restore(flags);
 		goto reread_page;
 	}
-	deactivate_slab(s, page, c->freelist, c);
+	freelist = c->freelist;
+	c->page = NULL;
+	c->freelist = NULL;
+	deactivate_slab(s, page, freelist);
 	local_irq_restore(flags);
 
 new_slab:
@@ -2834,11 +2843,7 @@ check_new_page:
 return_single:
 
 	local_irq_save(flags);
-	if (unlikely(c->page))
-		flush_slab(s, c);
-	c->page = page;
-
-	deactivate_slab(s, page, get_freepointer(s, freelist), c);
+	deactivate_slab(s, page, get_freepointer(s, freelist));
 	local_irq_restore(flags);
 	return freelist;
 }
_
