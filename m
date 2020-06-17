From: akpm@linux-foundation.org
Subject: +
 mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 09:57:08 -0700
Message-ID: <20200617165708.4lxS3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQ5L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: make remaining slub_debug related attributes read-only
has been added to the -mm tree.  Its filename is
     mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch

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
Subject: mm, slub: make remaining slub_debug related attributes read-only

SLUB_DEBUG creates several files under /sys/kernel/slab/<cache>/ that can
be read to check if the respective debugging options are enabled for given
cache.  Some options, namely sanity_checks, trace, and failslab can be
also enabled and disabled at runtime by writing into the files.

The runtime toggling is racy.  Some options disable __CMPXCHG_DOUBLE when
enabled, which means that in case of concurrent allocations, some can
still use __CMPXCHG_DOUBLE and some not, leading to potential corruption. 
The s->flags field is also not updated or checked atomically.  The
simplest solution is to remove the runtime toggling.  The extended
slub_debug boot parameter syntax introduced by earlier patch should allow
to fine-tune the debugging configuration during boot with same
granularity.

Link: http://lkml.kernel.org/r/20200610163135.17364-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |    7 +---
 mm/slub.c                 |   62 +-----------------------------------
 2 files changed, 5 insertions(+), 64 deletions(-)

--- a/Documentation/vm/slub.rst~mm-slub-make-remaining-slub_debug-related-attributes-read-only
+++ a/Documentation/vm/slub.rst
@@ -116,11 +116,8 @@ options from the ``slub_debug`` paramete
 	T	trace
 	A	failslab
 
-The sanity_checks, trace and failslab files are writable, so writing 1 or 0
-will enable or disable the option at runtime. The writes to trace and failslab
-may return -EINVAL if the cache is subject to slab merging. Careful with
-tracing: It may spew out lots of information and never stop if used on the
-wrong slab.
+Careful with tracing: It may spew out lots of information and never stop if
+used on the wrong slab.
 
 Slab merging
 ============
--- a/mm/slub.c~mm-slub-make-remaining-slub_debug-related-attributes-read-only
+++ a/mm/slub.c
@@ -5056,20 +5056,6 @@ static ssize_t show_slab_objects(struct
 	return x + sprintf(buf + x, "\n");
 }
 
-#ifdef CONFIG_SLUB_DEBUG
-static int any_slab_objects(struct kmem_cache *s)
-{
-	int node;
-	struct kmem_cache_node *n;
-
-	for_each_kmem_cache_node(s, node, n)
-		if (atomic_long_read(&n->total_objects))
-			return 1;
-
-	return 0;
-}
-#endif
-
 #define to_slab_attr(n) container_of(n, struct slab_attribute, attr)
 #define to_slab(n) container_of(n, struct kmem_cache, kobj)
 
@@ -5291,43 +5277,13 @@ static ssize_t sanity_checks_show(struct
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_CONSISTENCY_CHECKS));
 }
-
-static ssize_t sanity_checks_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	s->flags &= ~SLAB_CONSISTENCY_CHECKS;
-	if (buf[0] == '1') {
-		s->flags &= ~__CMPXCHG_DOUBLE;
-		s->flags |= SLAB_CONSISTENCY_CHECKS;
-	}
-	return length;
-}
-SLAB_ATTR(sanity_checks);
+SLAB_ATTR_RO(sanity_checks);
 
 static ssize_t trace_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_TRACE));
 }
-
-static ssize_t trace_store(struct kmem_cache *s, const char *buf,
-							size_t length)
-{
-	/*
-	 * Tracing a merged cache is going to give confusing results
-	 * as well as cause other issues like converting a mergeable
-	 * cache into an umergeable one.
-	 */
-	if (s->refcount > 1)
-		return -EINVAL;
-
-	s->flags &= ~SLAB_TRACE;
-	if (buf[0] == '1') {
-		s->flags &= ~__CMPXCHG_DOUBLE;
-		s->flags |= SLAB_TRACE;
-	}
-	return length;
-}
-SLAB_ATTR(trace);
+SLAB_ATTR_RO(trace);
 
 static ssize_t red_zone_show(struct kmem_cache *s, char *buf)
 {
@@ -5391,19 +5347,7 @@ static ssize_t failslab_show(struct kmem
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
 }
-
-static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
-							size_t length)
-{
-	if (s->refcount > 1)
-		return -EINVAL;
