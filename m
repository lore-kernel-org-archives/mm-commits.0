Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A840DC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhKTAq2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:46:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235621AbhKTAq2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B2061AF0;
        Sat, 20 Nov 2021 00:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369005;
        bh=GL74/S4haXPlH+wyDOeXx8kOaAMCi5FrhWBhq1KdbW0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kFytvkne3bvoFWqbejtFGKrs8GlThh9czttXj9wwiV7plmQFPn6bV00k6Fery6Cqx
         opUcrczuuLOCpqgYO2zxD2blpxO+k4goMzXvmwRLdNskc42lJXP09+aH6YDShwxbnC
         nW3/1DA5dWvb7ziuaeIwrDbv+rDM5XtTHhFGEzWM=
Date:   Fri, 19 Nov 2021 16:43:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        yeyunfeng@huawei.com
Subject:  [patch 04/15] mm: emit the "free" trace report before
 freeing memory in kmem_cache_free()
Message-ID: <20211120004325.Y4vOrn1WT%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>
Subject: mm: emit the "free" trace report before freeing memory in kmem_cache_free()

After the memory is freed, it can be immediately allocated by other CPUs,
before the "free" trace report has been emitted.  This causes inaccurate
traces.

For example, if the following sequence of events occurs:

    CPU 0                 CPU 1

  (1) alloc xxxxxx
  (2) free  xxxxxx
                         (3) alloc xxxxxx
                         (4) free  xxxxxx

Then they will be inaccurately reported via tracing, so that they appear
to have happened in this order:

    CPU 0                 CPU 1

  (1) alloc xxxxxx
                         (2) alloc xxxxxx
  (3) free  xxxxxx
                         (4) free  xxxxxx

This makes it look like CPU 1 somehow managed to allocate memory that CPU
0 still had allocated for itself.

In order to avoid this, emit the "free xxxxxx" tracing report just before
the actual call to free the memory, instead of just after it.

Link: https://lkml.kernel.org/r/374eb75d-7404-8721-4e1e-65b0e5b17279@huawei.com
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 +--
 mm/slob.c |    3 +--
 mm/slub.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/mm/slab.c~mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free
+++ a/mm/slab.c
@@ -3733,14 +3733,13 @@ void kmem_cache_free(struct kmem_cache *
 	if (!cachep)
 		return;
 
+	trace_kmem_cache_free(_RET_IP_, objp, cachep->name);
 	local_irq_save(flags);
 	debug_check_no_locks_freed(objp, cachep->object_size);
 	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(objp, cachep->object_size);
 	__cache_free(cachep, objp, _RET_IP_);
 	local_irq_restore(flags);
-
-	trace_kmem_cache_free(_RET_IP_, objp, cachep->name);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
--- a/mm/slob.c~mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free
+++ a/mm/slob.c
@@ -666,6 +666,7 @@ static void kmem_rcu_free(struct rcu_hea
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	kmemleak_free_recursive(b, c->flags);
+	trace_kmem_cache_free(_RET_IP_, b, c->name);
 	if (unlikely(c->flags & SLAB_TYPESAFE_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
@@ -674,8 +675,6 @@ void kmem_cache_free(struct kmem_cache *
 	} else {
 		__kmem_cache_free(b, c->size);
 	}
-
-	trace_kmem_cache_free(_RET_IP_, b, c->name);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
--- a/mm/slub.c~mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free
+++ a/mm/slub.c
@@ -3526,8 +3526,8 @@ void kmem_cache_free(struct kmem_cache *
 	s = cache_from_obj(s, x);
 	if (!s)
 		return;
-	slab_free(s, virt_to_head_page(x), x, NULL, 1, _RET_IP_);
 	trace_kmem_cache_free(_RET_IP_, x, s->name);
+	slab_free(s, virt_to_head_page(x), x, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
_
