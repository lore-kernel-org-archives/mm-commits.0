Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEDCC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C06611AF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbhIIVCA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B540C61179;
        Thu,  9 Sep 2021 21:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221249;
        bh=9n/XQXbEN/dilJiMRVpy3uj0aS9SYbU52iGF0YW8pTI=;
        h=Date:From:To:Subject:From;
        b=07KOi4HU4GD5WUuV6PIo7nUcRv17oDTlkqLoNdmaSGUg+ODvcahFf47lCpF6uUUDQ
         W7YbLH+FftdOqFE+BVrB/2VdPAUaHboe2w6sFyFcCO3brNJthNaWvPmQWJGgkpPI9z
         NmOxgtShj8brTck1gH9dNomHz4R8XaosnyhfeYjc=
Date:   Thu, 09 Sep 2021 14:00:48 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
 removed from -mm tree
Message-ID: <20210909210048.hG8aJTVdq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: move reset of c->page and freelist out of deactivate_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210904105003.11688-19-vbabka@suse.cz
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

 mm/slub.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/mm/slub.c~mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab
+++ a/mm/slub.c
@@ -2209,10 +2209,13 @@ static void init_kmem_cache_cpus(struct
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
@@ -2341,9 +2344,6 @@ redo:
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
-
-	c->page = NULL;
-	c->freelist = NULL;
 }
 
 /*
@@ -2468,10 +2468,16 @@ static void put_cpu_partial(struct kmem_
 
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
@@ -2769,7 +2775,10 @@ deactivate_slab:
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
@@ -2848,11 +2857,7 @@ check_new_page:
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

Patches currently in -mm which might be from vbabka@suse.cz are


