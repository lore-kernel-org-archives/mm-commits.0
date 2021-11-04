Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B94EC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826A26120E
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhKDBn0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhKDBn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0426360F70;
        Thu,  4 Nov 2021 01:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990049;
        bh=fAOJRfoQg4gIm43GEaLrzDTnpx4T3SfVPJ77N87uQkU=;
        h=Date:From:To:Subject:From;
        b=SbUU417iZ7EYNBzwSTuPamPg+oAQTgb1S9HZJu3jS8qwzYeijMKNeIyJAgvh3YHsl
         7oX4Fy6nxKvsDQirODLRGsMOiAJXhavkd3CHmvf3zN4ZVIEbRZriq2US8GvHwqzSc8
         tyfNrNxgtni61+36MgYZuL8QWJSD3Mw6oraJ/xuY=
Date:   Wed, 03 Nov 2021 18:40:48 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, yeyunfeng@huawei.com
Subject:  +
 =?US-ASCII?Q?mm-emit-the-free-trace-report-before-freeing-memory-in-k?=
 =?US-ASCII?Q?mem=5Fcache=5Ffree.patch?= added to -mm tree
Message-ID: <20211104014048.tmAeHseJ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: emit the "free" trace report before freeing memory in kmem_cache_free()
has been added to the -mm tree.  Its filename is
     mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3505,8 +3505,8 @@ void kmem_cache_free(struct kmem_cache *
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

mm-emit-the-free-trace-report-before-freeing-memory-in-kmem_cache_free.patch

