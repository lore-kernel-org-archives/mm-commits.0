From: akpm@linux-foundation.org
Subject: [folded-merged] mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:16:36 -0800
Message-ID: <20121218221636.F38C620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41543 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:16:39 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so67805eei.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:16:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix
has been removed from the -mm tree.  Its filename was
     mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

This patch was dropped because it was folded into mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix

tweak comment

Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix
+++ a/mm/vmscan.c
@@ -1203,8 +1203,9 @@ static int too_many_isolated(struct zone
 	}
 
 	/*
-	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so that
-	 * they won't get blocked by normal ones and form circular deadlock.
+	 * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages, so they
+	 * won't get blocked by normal direct-reclaimers, forming a circular
+	 * deadlock.
 	 */
 	if ((sc->gfp_mask & GFP_IOFS) == GFP_IOFS)
 		inactive >>= 3;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch

