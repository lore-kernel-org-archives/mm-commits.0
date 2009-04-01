From: akpm@linux-foundation.org
Subject: [merged] vmscan-print-shrink_slab-symbol-name-on-negative-shrinker-objects.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:52 -0700
Message-ID: <200904011838.n31IcqNs008422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062AbZDASly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     vmscan: print shrink_slab symbol name on negative shrinker objects
has been removed from the -mm tree.  Its filename was
     vmscan-print-shrink_slab-symbol-name-on-negative-shrinker-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: print shrink_slab symbol name on negative shrinker objects
From: David Rientjes <rientjes@google.com>

When a shrinker has a negative number of objects to delete, the symbol
name of the shrinker should be printed, not shrink_slab.  This also makes
the error message slightly more informative.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-print-shrink_slab-symbol-name-on-negative-shrinker-objects mm/vmscan.c
--- a/mm/vmscan.c~vmscan-print-shrink_slab-symbol-name-on-negative-shrinker-objects
+++ a/mm/vmscan.c
@@ -214,8 +214,9 @@ unsigned long shrink_slab(unsigned long 
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
-			printk(KERN_ERR "%s: nr=%ld\n",
-					__func__, shrinker->nr);
+			printk(KERN_ERR "shrink_slab: %pF negative objects to "
+			       "delete nr=%ld\n",
+			       shrinker->shrink, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch

