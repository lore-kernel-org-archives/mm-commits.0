Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514B9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 23 Nov 2021 22:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhKWWs7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237945AbhKWWst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 17:48:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B494960E0B;
        Tue, 23 Nov 2021 22:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707541;
        bh=EFfOA9LJCKQXalmmI9WOwPKYCGDhfTQQoK2xzpa7Lbk=;
        h=Date:From:To:Subject:From;
        b=N2SvYpVBn07QIAaTXpnCbz8J4gTQJ1oS7SiIqC7RsR+CfaeEC3OzvbZKfS3EihRfS
         EjFeh7NBU/t9PiZgkht0T6FthF2tmqX1kmUjKQ+iUj8/Yr+SDoqQl70/+bVSMyK2sw
         sZ/AnOUop5I1lSRtZZt7QDtgpJuIQ4RxayQaxC8A=
Date:   Tue, 23 Nov 2021 14:45:40 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, yeyunfeng@huawei.com
Subject:  [merged]
 =?US-ASCII?Q?mm-emit-the-free-trace-report-before-freeing-memory-in-k?=
 =?US-ASCII?Q?mem=5Fcache=5Ffree.patch?= removed from -mm tree
Message-ID: <20211123224540.RMFc4DS8Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: emit the "free" trace report before freeing memory in kmem_cache_free()
has been removed from the -mm tree.  Its filename was
     mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yeyunfeng@huawei.com are


