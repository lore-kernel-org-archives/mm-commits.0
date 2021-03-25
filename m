Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB296C433E5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E21619F8
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhCYEiR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCYEhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Mar 2021 00:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9EA060238;
        Thu, 25 Mar 2021 04:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647068;
        bh=56NT/3xKiP3+Sg0MPnn7d0L14XRiijtdBGuH3UaLJwE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wIyPnJP9mCHlIAmHTX4tUWNi6o0ADV9jKP5tgCnbRk64grClTModwiB6HQZa0wpc7
         UiUhO6FA4cTTduLGKu7NB+v/H/5AygPHCgMF3+KhBz7kj/+rpvC4Tb721YMwgJ9nDL
         a4nwq3LR8aUn8EBVwZmrIzdhxWf7pwNzD+zt0xqI=
Date:   Wed, 24 Mar 2021 21:37:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, lhenriques@suse.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 11/14] kfence: make compatible with kmemleak
Message-ID: <20210325043747.P1f2mlmCA%akpm@linux-foundation.org>
In-Reply-To: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: make compatible with kmemleak

Because memblock allocations are registered with kmemleak, the KFENCE pool
was seen by kmemleak as one large object.  Later allocations through
kfence_alloc() that were registered with kmemleak via
slab_post_alloc_hook() would then overlap and trigger a warning. 
Therefore, once the pool is initialized, we can remove (free) it from
kmemleak again, since it should be treated as allocator-internal and be
seen as "free memory".

The second problem is that kmemleak is passed the rounded size, and not
the originally requested size, which is also the size of KFENCE objects. 
To avoid kmemleak scanning past the end of an object and trigger a KFENCE
out-of-bounds error, fix the size if it is a KFENCE object.

For simplicity, to avoid a call to kfence_ksize() in
slab_post_alloc_hook() (and avoid new IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)
guard), just call kfence_ksize() in mm/kmemleak.c:create_object().

Link: https://lkml.kernel.org/r/20210317084740.3099921-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Luis Henriques <lhenriques@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    9 +++++++++
 mm/kmemleak.c    |    3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-make-compatible-with-kmemleak
+++ a/mm/kfence/core.c
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
+#include <linux/kmemleak.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/memblock.h>
@@ -480,6 +481,14 @@ static bool __init kfence_init_pool(void
 		addr += 2 * PAGE_SIZE;
 	}
 
+	/*
+	 * The pool is live and will never be deallocated from this point on.
+	 * Remove the pool object from the kmemleak object tree, as it would
+	 * otherwise overlap with allocations returned by kfence_alloc(), which
+	 * are registered with kmemleak through the slab post-alloc hook.
+	 */
+	kmemleak_free(__kfence_pool);
+
 	return true;
 
 err:
--- a/mm/kmemleak.c~kfence-make-compatible-with-kmemleak
+++ a/mm/kmemleak.c
@@ -97,6 +97,7 @@
 #include <linux/atomic.h>
 
 #include <linux/kasan.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
 
@@ -589,7 +590,7 @@ static struct kmemleak_object *create_ob
 	atomic_set(&object->use_count, 1);
 	object->flags = OBJECT_ALLOCATED;
 	object->pointer = ptr;
-	object->size = size;
+	object->size = kfence_ksize((void *)ptr) ?: size;
 	object->excess_ref = 0;
 	object->min_count = min_count;
 	object->count = 0;			/* white color initially */
_
