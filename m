Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624DFC433EC
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0C661958
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 16:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhC1Qm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 12:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhC1Qmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B9F61968;
        Sun, 28 Mar 2021 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949750;
        bh=7U069BFSiKD7wy7k7/o4uuXAtU5fOdem2vYnObghMYA=;
        h=Date:From:To:Subject:From;
        b=u7G/nYSntyxiAFqyryEJ9NCecG/KWL5NA+Y1aYaFB80AFKNtUJNDLCtG5nY2KpLCO
         qgSxgNjBFKGR8rMDz11XKqAf6Jq7eYls8XanHuptJOau8AaVM4tVoGWWsJzVou8HeI
         slpJsR/LQAdmmeCLvkuC+NFDfg2XQkDcK1h4CCFI=
Date:   Sun, 28 Mar 2021 09:42:30 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, glider@google.com, jannh@google.com,
        lhenriques@suse.de, mm-commits@vger.kernel.org
Subject:  [merged] kfence-make-compatible-with-kmemleak.patch
 removed from -mm tree
Message-ID: <20210328164230.ypiCBfQGZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: make compatible with kmemleak
has been removed from the -mm tree.  Its filename was
     kfence-make-compatible-with-kmemleak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kfence-zero-guard-page-after-out-of-bounds-access.patch

