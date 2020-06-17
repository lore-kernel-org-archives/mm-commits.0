From: akpm@linux-foundation.org
Subject: + mm-slub-remove-runtime-allocation-order-changes.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 09:57:06 -0700
Message-ID: <20200617165706.wD88H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgFQQ5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: remove runtime allocation order changes
has been added to the -mm tree.  Its filename is
     mm-slub-remove-runtime-allocation-order-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-remove-runtime-allocation-order-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-remove-runtime-allocation-order-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: remove runtime allocation order changes

SLUB allows runtime changing of page allocation order by writing into the
/sys/kernel/slab/<cache>/order file.  Jann has reported [1] that this
interface allows the order to be set too small, leading to crashes.

While it's possible to fix the immediate issue, closer inspection reveals
potential races.  Storing the new order calls calculate_sizes() which
non-atomically updates a lot of kmem_cache fields while the cache is still
in use.  Unexpected behavior might occur even if the fields are set to the
same value as they were.

This could be fixed by splitting out the part of calculate_sizes() that
depends on forced_order, so that we only update kmem_cache.oo field.  This
could still race with init_cache_random_seq(), shuffle_freelist(),
allocate_slab().  Perhaps it's possible to audit and e.g.  add some
READ_ONCE/WRITE_ONCE accesses, it might be easier just to remove the
runtime order changes, which is what this patch does.  If there are valid
usecases for per-cache order setting, we could e.g.  extend the boot
parameters to do that.

[1] https://lore.kernel.org/r/CAG48ez31PP--h6_FzVyfJ4H86QYczAFPdxtJHUEEan+7VJETAQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200610163135.17364-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/mm/slub.c~mm-slub-remove-runtime-allocation-order-changes
+++ a/mm/slub.c
@@ -5111,28 +5111,11 @@ static ssize_t objs_per_slab_show(struct
 }
 SLAB_ATTR_RO(objs_per_slab);
 
-static ssize_t order_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	unsigned int order;
-	int err;
-
-	err = kstrtouint(buf, 10, &order);
-	if (err)
-		return err;
-
-	if (order > slub_max_order || order < slub_min_order)
-		return -EINVAL;
-
-	calculate_sizes(s, order);
-	return length;
-}
