Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F14C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA4A206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026901;
	bh=jB/9KzN9LK+t/w/qMYuGcwQMSUmoXu+lwQLTW9L8fv4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rxzI4QsifT3C6v2dne30UGw2pnq9FB9005UEMK3hd9KMsUr1STRRVVbEG6wCqLI+e
	 OsyZiEA3h9zQtHzckk3MuP+aWLg6JD/pG+Oj37qyhb1aMLev3bLpk7KFHKwiD+lS75
	 9Oi/vZJ448dSqehkj1cEYULCQoRqYXLtVce7Xkgg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F1C12075D;
        Mon, 10 Aug 2020 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026900;
        bh=jB/9KzN9LK+t/w/qMYuGcwQMSUmoXu+lwQLTW9L8fv4=;
        h=Date:From:To:Subject:From;
        b=CPWk/bzACT2tb7F25GjlKuoBcDE6zEHSAhRInfvSuKj6pY81g/H97xw59D+M5Amew
         oFpMAx1BOjM1a3HiA5MHbLEoAJ1drDBUQ5Li+NXhVdPF2fndmnBlFCZqA9tXuR8AQ8
         BD+A72ovuRJGLok5VCrFMJteHA+JgKrwkHMjRx18=
Date:   Sun, 09 Aug 2020 19:34:59 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
 removed from -mm tree
Message-ID: <20200810023459.1Pgxp6d_1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: make remaining slub_debug related attributes read-only
has been removed from the -mm tree.  Its filename was
     mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5040,20 +5040,6 @@ static ssize_t show_slab_objects(struct
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
 
@@ -5275,43 +5261,13 @@ static ssize_t sanity_checks_show(struct
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
@@ -5375,19 +5331,7 @@ static ssize_t failslab_show(struct kmem
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
 }
-
-static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
-							size_t length)
-{
-	if (s->refcount > 1)
-		return -EINVAL;
-
-	s->flags &= ~SLAB_FAILSLAB;
-	if (buf[0] == '1')
-		s->flags |= SLAB_FAILSLAB;
-	return length;
-}
-SLAB_ATTR(failslab);
+SLAB_ATTR_RO(failslab);
 #endif
 
 static ssize_t shrink_show(struct kmem_cache *s, char *buf)
_

Patches currently in -mm which might be from vbabka@suse.cz are


