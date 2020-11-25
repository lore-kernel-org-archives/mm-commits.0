Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50A2C6379D
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659FE221FE
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SR43H+CI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgKYWST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733214AbgKYWST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:18:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 973592075A;
        Wed, 25 Nov 2020 22:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606342697;
        bh=2rfGePGU/WqIz0dDuJkwz2aqGcfG5nqisBBQS5+dW6E=;
        h=Date:From:To:Subject:From;
        b=SR43H+CI5eoSCR2MS9cO0Lbh1hw1OXiBuv9lGzhbPcCCRVjOiXVF3vje+BpFcyoCI
         kOp+4WA5wcW6gb3bY+HukeQSo/1A4GBedDlhcGV1o4XP++28PfQ8a3pijdVPIK1sfF
         tJs9WA2zLk4ASeG4MQaqLebRr57f2jOf9htczNY0=
Date:   Wed, 25 Nov 2020 14:18:15 -0800
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
Subject:  +
 mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch added to -mm
 tree
Message-ID: <20201125221815.wTY0zupyJ%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-track-mmu-notifiers-in-fs_=
reclaim_acquire-release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-track-mmu-notifiers-in-fs_=
reclaim_acquire-release.patch

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

mm-track-mmu-notifiers-in-fs_reclaim_acquire-release.patch
mm-extract-might_alloc-debug-check.patch
locking-selftests-add-testcases-for-fs_reclaim.patch

