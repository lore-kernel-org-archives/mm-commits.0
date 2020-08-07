Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E91C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9165822C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781127;
	bh=gO2FE7FeoupRREpR0ndTnvKOHLpWsYeQ0jFwu6mPS00=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=E+K6cd48TdZAP4KHrQncEbKvVXCUTcAtFaQExcIaJZBhH6pSqPc6ukTHQh0a0ibUU
	 0S8wl8sQ/pBU6H2bJeGjAl3w6y59iHbdSllj/SqBNONm/971swyZPYQgRzTSHx5xDr
	 S0MYS/8/VbEYzdcRIg2cgwhiWMShHx590gZGwNIU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B4622CAF;
        Fri,  7 Aug 2020 06:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781126;
        bh=gO2FE7FeoupRREpR0ndTnvKOHLpWsYeQ0jFwu6mPS00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mYw5yV9R0NQ0V0lGvfnxnwolXGHhzWPtL+iFyQebwLOVxXENMCzqqFdfWLOwk1p68
         lrqSmbwUZ/udr1Aq3W5pXscjEBRFL1eRZxUKcX3fcJo+Ay0xFqwQChY99+qrl540h+
         gp95h2tmz0p9Z9tF19aYGzMMhhs7QY7wHZeCYYMg=
Date:   Thu, 06 Aug 2020 23:18:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [patch 031/163] mm, slub: make remaining slub_debug
 related attributes read-only
Message-ID: <20200807061845.TEH4F98qc%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
