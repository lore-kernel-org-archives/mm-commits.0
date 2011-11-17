From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-avoid-livelock-on-__gfp_fs-allocations.patch removed from -mm tree
Date: Thu, 17 Nov 2011 13:34:17 -0800
Message-ID: <201111172134.pAHLYHpj009980@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:39835 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1KQVeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 16:34:21 -0500
Received: by faap16 with SMTP id p16so78140faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 13:34:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, ccross@android.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid livelock on !__GFP_FS allocations
has been removed from the -mm tree.  Its filename was
     mm-avoid-livelock-on-__gfp_fs-allocations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: avoid livelock on !__GFP_FS allocations

This patch seems to have gotten lost in the cracks and the discussion on
alternatives that started here https://lkml.org/lkml/2011/10/25/24 petered
out without any alternative patches being posted.  Lacking a viable
alternative patch, I'm reposting this patch because AFAIK, this bug still
exists.

Colin Cross reported;

  Under the following conditions, __alloc_pages_slowpath can loop forever:
  gfp_mask & __GFP_WAIT is true
  gfp_mask & __GFP_FS is false
  reclaim and compaction make no progress
  order <= PAGE_ALLOC_COSTLY_ORDER

  These conditions happen very often during suspend and resume,
  when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
  allocations into __GFP_WAIT.

  The oom killer is not run because gfp_mask & __GFP_FS is false,
  but should_alloc_retry will always return true when order is less
  than PAGE_ALLOC_COSTLY_ORDER.

In his fix, he avoided retrying the allocation if reclaim made no progress
and __GFP_FS was not set.  The problem is that this would result in
GFP_NOIO allocations failing that previously succeeded which would be very
unfortunate.

The big difference between GFP_NOIO and suspend converting GFP_KERNEL to
behave like GFP_NOIO is that normally flushers will be cleaning pages and
kswapd reclaims pages allowing GFP_NOIO to succeed after a short delay. 
The same does not necessarily apply during suspend as the storage device
may be suspended.  Hence, this patch special cases the suspend case to
fail the page allocation if reclaim cannot make progress.  This might
cause suspend to abort but that is better than a livelock.

[mgorman@suse.de: Rework fix to be suspend specific]
[akpm@linux-foundation.org: augment comment]
Reported-by: Colin Cross <ccross@android.com>
Tested-by: Colin Cross <ccross@android.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations
+++ a/mm/page_alloc.c
@@ -127,6 +127,20 @@ void pm_restrict_gfp_mask(void)
 	saved_gfp_mask = gfp_allowed_mask;
 	gfp_allowed_mask &= ~GFP_IOFS;
 }
+
+static bool pm_suspending(void)
+{
+	if ((gfp_allowed_mask & GFP_IOFS) == GFP_IOFS)
+		return false;
+	return true;
+}
+
+#else
+
+static bool pm_suspending(void)
+{
+	return false;
+}
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -2247,6 +2261,15 @@ rebalance:
 
 			goto restart;
 		}
+
+		/*
+		 * Suspend converts GFP_KERNEL to __GFP_WAIT which can prevent
+		 * reclaim making forward progress without invoking OOM.
+		 * Suspend also disables storage devices so kswapd cannot save
+		 * us.  Bail if we are suspending.
+		 */
+		if (pm_suspending())
+			goto nopage;
 	}
 
 	/* Check if we should retry the allocation */
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch

