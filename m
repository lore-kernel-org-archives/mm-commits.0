From: akpm@linux-foundation.org
Subject: +
 mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch added to -mm tree
Date: Wed, 17 Jun 2020 15:30:56 -0700
Message-ID: <20200617223056.c9nhg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQWa6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 18:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thomas_os@shipmail.org, maarten.lankhorst@linux.intel.com, jgg@mellanox.com, daniel.vetter@intel.com, christian.koenig@amd.com, daniel.vetter@ffwll.ch


The patch titled
     Subject: mm: track mmu notifiers in fs_reclaim_acquire/release
has been added to the -mm tree.  Its filename is
     mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-mmu-notifiers-in-fs_r=
eclaim_acquire-release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-mmu-notifiers-in-fs_r=
eclaim_acquire-release.patch

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
From: Daniel Vetter <daniel.vetter@ffwll.ch>
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

Link: http://lkml.kernel.org/r/20200610194101.1668038-1-daniel.vetter@ffwll=
.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Jason Gunthorpe <jgg@mellanox.com>	[mmu_notifiers]
Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    7 -------
 mm/page_alloc.c   |   25 ++++++++++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

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
@@ -4155,7 +4156,7 @@ should_compact_retry(struct alloc_contex
 static struct lockdep_map __fs_reclaim_map =3D
 	STATIC_LOCKDEP_MAP_INIT("fs_reclaim", &__fs_reclaim_map);
=20
-static bool __need_fs_reclaim(gfp_t gfp_mask)
+static bool __need_reclaim(gfp_t gfp_mask)
 {
 	gfp_mask =3D current_gfp_context(gfp_mask);
=20
@@ -4167,10 +4168,6 @@ static bool __need_fs_reclaim(gfp_t gfp_
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
@@ -4189,15 +4186,25 @@ void __fs_reclaim_release(void)
=20
 void fs_reclaim_acquire(gfp_t gfp_mask)
 {
-	if (__need_fs_reclaim(gfp_mask))
-		__fs_reclaim_acquire();
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
+	if (__need_reclaim(gfp_mask)) {
+		if (gfp_mask & __GFP_FS)
+			__fs_reclaim_release();
+	}
 }
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch
