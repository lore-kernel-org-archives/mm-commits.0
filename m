Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1DDC3527A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0300922CB2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgLOX7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgLOXVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:21:00 -0500
Date:   Tue, 15 Dec 2020 15:19:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074390;
        bh=hjlvF2TxTWTo1hisc+161+pqcccOo4rTlhsM3/RQy0Y=;
        h=From:To:Subject:From;
        b=VJVpnHg9Fq3IOClqkouGP7HPkgNCRfdQDoAG9fMMBi7NcVediss0X7VPfsDql0nGX
         b3lrJXEQYzHNaNpsLEMoR+jqUkH+1fBpsbiCAkmco5KrrzqKKDb9UnTicuRbFAisxJ
         CKGghn6yC45yH5OhOgDwl6vhXThYo+3fQC2lDa8I=
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
Subject:  [merged]
 mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch removed from -mm
 tree
Message-ID: <20201215231948.hTA1Evljq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track mmu notifiers in fs_reclaim_acquire/release
has been removed from the -mm tree.  Its filename was
     mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm: track mmu notifiers in fs_reclaim_acquire/release

fs_reclaim_acquire/release nicely catch recursion issues when allocating
GFP_KERNEL memory against shrinkers (which gpu drivers tend to use to keep
the excessive caches in check).  For mmu notifier recursions we do have
lockdep annotations since 23b68395c7c7 ("mm/mmu_notifiers: add a lockdep
map for invalidate_range_start/end").

But these only fire if a path actually results in some pte invalidation -
for most small allocations that's very rarely the case.  The other trouble
is that pte invalidation can happen any time when __GFP_RECLAIM is set.=20
Which means only really GFP_ATOMIC is a safe choice, GFP_NOIO isn't good
enough to avoid potential mmu notifier recursion.

I was pondering whether we should just do the general annotation, but
there's always the risk for false positives.  Plus I'm assuming that the
core fs and io code is a lot better reviewed and tested than random mmu
notifier code in drivers.  Hence why I decide to only annotate for that
specific case.

Furthermore even if we'd create a lockdep map for direct reclaim, we'd
still need to explicit pull in the mmu notifier map - there's a lot more
places that do pte invalidation than just direct reclaim, these two
contexts arent the same.

Note that the mmu notifiers needing their own independent lockdep map is
also the reason we can't hold them from fs_reclaim_acquire to
fs_reclaim_release - it would nest with the acquistion in the pte
invalidation code, causing a lockdep splat.  And we can't remove the
annotations from pte invalidation and all the other places since they're
called from many other places than page reclaim.  Hence we can only do the
equivalent of might_lock, but on the raw lockdep map.

With this we can also remove the lockdep priming added in 66204f1d2d1b
("mm/mmu_notifiers: prime lockdep") since the new annotations are strictly
more powerful.

Link: https://lkml.kernel.org/r/20201125162532.1299794-2-daniel.vetter@ffwl=
l.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    7 -------
 mm/page_alloc.c   |   31 ++++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 18 deletions(-)

--- a/mm/mmu_notifier.c~mm-track-mmu-notifiers-in-fs_reclaim_acquire-release
+++ a/mm/mmu_notifier.c
@@ -612,13 +612,6 @@ int __mmu_notifier_register(struct mmu_n
 	mmap_assert_write_locked(mm);
 	BUG_ON(atomic_read(&mm->mm_users) <=3D 0);
=20
-	if (IS_ENABLED(CONFIG_LOCKDEP)) {
-		fs_reclaim_acquire(GFP_KERNEL);
-		lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
-		lock_map_release(&__mmu_notifier_invalidate_range_start_map);
-		fs_reclaim_release(GFP_KERNEL);
-	}
-
 	if (!mm->notifier_subscriptions) {
 		/*
 		 * kmalloc cannot be called under mm_take_all_locks(), but we
--- a/mm/page_alloc.c~mm-track-mmu-notifiers-in-fs_reclaim_acquire-release
+++ a/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
@@ -4264,10 +4265,8 @@ should_compact_retry(struct alloc_contex
 static struct lockdep_map __fs_reclaim_map =3D
 	STATIC_LOCKDEP_MAP_INIT("fs_reclaim", &__fs_reclaim_map);
=20
-static bool __need_fs_reclaim(gfp_t gfp_mask)
+static bool __need_reclaim(gfp_t gfp_mask)
 {
-	gfp_mask =3D current_gfp_context(gfp_mask);
-
 	/* no reclaim without waiting on it */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
@@ -4276,10 +4275,6 @@ static bool __need_fs_reclaim(gfp_t gfp_
 	if (current->flags & PF_MEMALLOC)
 		return false;
=20
-	/* We're only interested __GFP_FS allocations for now */
-	if (!(gfp_mask & __GFP_FS))
-		return false;
-
 	if (gfp_mask & __GFP_NOLOCKDEP)
 		return false;
=20
@@ -4298,15 +4293,29 @@ void __fs_reclaim_release(void)
=20
 void fs_reclaim_acquire(gfp_t gfp_mask)
 {
-	if (__need_fs_reclaim(gfp_mask))
-		__fs_reclaim_acquire();
+	gfp_mask =3D current_gfp_context(gfp_mask);
+
+	if (__need_reclaim(gfp_mask)) {
+		if (gfp_mask & __GFP_FS)
+			__fs_reclaim_acquire();
+
+#ifdef CONFIG_MMU_NOTIFIER
+		lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
+		lock_map_release(&__mmu_notifier_invalidate_range_start_map);
+#endif
+
+	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_acquire);
=20
 void fs_reclaim_release(gfp_t gfp_mask)
 {
-	if (__need_fs_reclaim(gfp_mask))
-		__fs_reclaim_release();
+	gfp_mask =3D current_gfp_context(gfp_mask);
+
+	if (__need_reclaim(gfp_mask)) {
+		if (gfp_mask & __GFP_FS)
+			__fs_reclaim_release();
+	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


