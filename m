Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472E3C64E7A
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46D322206
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eH+e7v+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733310AbgKYWSX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733214AbgKYWSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:18:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6726421741;
        Wed, 25 Nov 2020 22:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606342702;
        bh=bETsrkH3Y/6OGCd/d+qjT6rzTfwacOeg0xtjjGcVpN4=;
        h=Date:From:To:Subject:From;
        b=eH+e7v+ggMIH2/PueQo9N9+kh028RNmdDLTkw+Uws/WXjeN9I3b0KY4mmTRVE4MuK
         ephGU+JTNSJk6F0iXPv9iwJWUPVLMYZlylAMHxdTwSTFfJV2ac2Qmq4wtGiDn3D/Qm
         6Il6Irk4ds2PgXtlKNLJW3MkToXcAUsXuQs5Ax1M=
Date:   Wed, 25 Nov 2020 14:18:20 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, cai@lca.pw, christian.koenig@amd.com,
        cl@linux.com, daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        david@fromorbit.com, iamjoonsoo.kim@lge.com, jgg@mellanox.com,
        jgg@nvidia.com, longman@redhat.com,
        maarten.lankhorst@linux.intel.com, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, penberg@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com, tglx@linutronix.de,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        will@kernel.org, willy@infradead.org
Subject:  + mm-extract-might_alloc-debug-check.patch added to -mm
 tree
Message-ID: <20201125221820.Y9PWO5Zll%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: extract might_alloc() debug check
has been added to the -mm tree.  Its filename is
     mm-extract-might_alloc-debug-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-extract-might_alloc-debug-=
check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-extract-might_alloc-debug-=
check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm: extract might_alloc() debug check

Extracted from slab.h, which seems to have the most complete version
including the correct might_sleep() check.  Roll it out to slob.c.

Motivated by a discussion with Paul about possibly changing call_rcu
behaviour to allocate memory, but only roughly every 500th call.

There are a lot fewer places in the kernel that care about whether
allocating memory is allowed or not (due to deadlocks with reclaim code)
than places that care whether sleeping is allowed.  But debugging these
also tends to be a lot harder, so nice descriptive checks could come in
handy.  I might have some use eventually for annotations in drivers/gpu.

Note that unlike fs_reclaim_acquire/release gfpflags_allow_blocking does
not consult the PF_MEMALLOC flags.  But there is no flag equivalent for
GFP_NOWAIT, hence this check can't go wrong due to
memalloc_no*_save/restore contexts.  Willy is working on a patch series
which might change this:

https://lore.kernel.org/linux-mm/20200625113122.7540-7-willy@infradead.org/

I think best would be if that updates gfpflags_allow_blocking(), since
there's a ton of callers all over the place for that already.

Link: https://lkml.kernel.org/r/20201125162532.1299794-3-daniel.vetter@ffwl=
l.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc. Randy Dunlap <rdunlap@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   16 ++++++++++++++++
 mm/slab.h                |    5 +----
 mm/slob.c                |    6 ++----
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/sched/mm.h~mm-extract-might_alloc-debug-check
+++ a/include/linux/sched/mm.h
@@ -181,6 +181,22 @@ static inline void fs_reclaim_release(gf
 #endif
=20
 /**
+ * might_alloc - Mark possible allocation sites
+ * @gfp_mask: gfp_t flags that would be used to allocate
+ *
+ * Similar to might_sleep() and other annotations, this can be used in fun=
ctions
+ * that might allocate, but often don't. Compiles to nothing without
+ * CONFIG_LOCKDEP. Includes a conditional might_sleep() if @gfp allows blo=
cking.
+ */
+static inline void might_alloc(gfp_t gfp_mask)
+{
+	fs_reclaim_acquire(gfp_mask);
+	fs_reclaim_release(gfp_mask);
+
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+}
+
+/**
  * memalloc_noio_save - Marks implicit GFP_NOIO allocation scope.
  *
  * This functions marks the beginning of the GFP_NOIO allocation scope.
--- a/mm/slab.h~mm-extract-might_alloc-debug-check
+++ a/mm/slab.h
@@ -500,10 +500,7 @@ static inline struct kmem_cache *slab_pr
 {
 	flags &=3D gfp_allowed_mask;
=20
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
-
-	might_sleep_if(gfpflags_allow_blocking(flags));
+	might_alloc(flags);
=20
 	if (should_failslab(s, flags))
 		return NULL;
--- a/mm/slob.c~mm-extract-might_alloc-debug-check
+++ a/mm/slob.c
@@ -474,8 +474,7 @@ __do_kmalloc_node(size_t size, gfp_t gfp
=20
 	gfp &=3D gfp_allowed_mask;
=20
-	fs_reclaim_acquire(gfp);
-	fs_reclaim_release(gfp);
+	might_alloc(gfp);
=20
 	if (size < PAGE_SIZE - minalign) {
 		int align =3D minalign;
@@ -597,8 +596,7 @@ static void *slob_alloc_node(struct kmem
=20
 	flags &=3D gfp_allowed_mask;
=20
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
+	might_alloc(flags);
=20
 	if (c->size < PAGE_SIZE) {
 		b =3D slob_alloc(c->size, flags, c->align, node, 0);
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch
mm-extract-might_alloc-debug-check.patch
locking-selftests-add-testcases-for-fs_reclaim.patch

