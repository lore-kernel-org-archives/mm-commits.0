Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45750C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0641B64F2A
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCQWfF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhCQWe7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 18:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB37664EFD;
        Wed, 17 Mar 2021 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616020499;
        bh=j68621DGMdXrBTuswXnBKy9296jR+7yLl2PME39PDAQ=;
        h=Date:From:To:Subject:From;
        b=SWaQZ3Ejso8+RuUpFXHHEtaYDO5JkdkW4Aa86WCMcRVOytlNhvpRd73wrwSu8bQyG
         h/m6e90fOQEzeI/60QRIrAecwsd8l4P7tS20TIYqHiqh4SVxjdjvNaR60MTbPzUS1n
         BIAlFOTCzebKyL0EET/geseI+yjI8gKgxlF87O8E=
Date:   Wed, 17 Mar 2021 15:34:58 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, glider@google.com, jannh@google.com,
        lhenriques@suse.de, mm-commits@vger.kernel.org
Subject:  + kfence-make-compatible-with-kmemleak.patch added to -mm
 tree
Message-ID: <20210317223458.-JlP-ZvpH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: make compatible with kmemleak
has been added to the -mm tree.  Its filename is
     kfence-make-compatible-with-kmemleak.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-make-compatible-with-kmemleak.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-make-compatible-with-kmemleak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are

kfence-make-compatible-with-kmemleak.patch
kfence-zero-guard-page-after-out-of-bounds-access.patch

