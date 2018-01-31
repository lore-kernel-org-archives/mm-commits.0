From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-terminate-shrink_slab-loop-if-signal-is-pending.patch removed from -mm
 tree
Date: Wed, 31 Jan 2018 14:52:09 -0800
Message-ID: <5a724899.Fjn5jDhvx+bS8yGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbeAaWwM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 17:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: surenb@google.com, cl@linux.com, hannes@cmpxchg.org, hdanton@sina.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com, timmurray@google.com, tkjos@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: terminate shrink_slab loop if signal is pending
has been removed from the -mm tree.  Its filename was
     mm-terminate-shrink_slab-loop-if-signal-is-pending.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vmscan.c: terminate shrink_slab loop if signal is pending

Slab shrinkers can be quite time consuming and when signal is pending they
can delay handling of the signal.  If fatal signal is pending there is no
point in shrinking that process since it will be killed anyway.  This
change checks for pending fatal signals inside shrink_slab loop and if one
is detected terminates this loop early.

The observable delay depends on the implementation of the shrinkers
registered in the system including the ones from drivers.  I've
captured traces showing delays of up to 100ms where the process with
pending SIGKILL is in direct memory reclaim and signal handling is
delayed because of that.  I realize that it's not the fault of
shrink_slab() that some shrinkers take long time to shrink their slabs
(sometimes because of justifiable reasons and sometimes because of a
bug which has to be fixed) but this can be a safeguard against such
cases.  Couple shrinker examples that I found most time consuming are
(most of that 100ms delay is the result of the first two ones):

https://patchwork.kernel.org/patch/10096641/: the patch fixes dm-bufio
shrinker which in certain conditions reclaims only one buffer per scan
making the shrinking process very inefficient.

https://android.googlesource.com/kernel/msm/+/android-7.1.0_r0.2/drivers/gpu/msm/kgsl_pool.c#420:
This example is from a driver where shrinker returns 0 instead of
SHRINK_STOP when it's unable to reclaim anymore.  As a result when
total_scan in do_shrink_slab() is large this will cause multiple
scan_objects() calls with no memory being reclaimed.  Patch for this
one is under review by the owners.

Shrinker that seems to be justifiably heavy is super_cache_scan()
inside fs/super.c.  I have traces where it takes up to 4ms to complete.

[akpm@linux-foundation.org: fix build, per Sergey]
Link: http://lkml.kernel.org/r/20171206192026.25133-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending mm/vmscan.c
--- a/mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending
+++ a/mm/vmscan.c
@@ -490,6 +490,13 @@ static unsigned long shrink_slab(gfp_t g
 		};
 
 		/*
+		 * We are about to die and free our memory.
+		 * Stop shrinking which might delay signal handling.
+		 */
+		if (unlikely(fatal_signal_pending(current)))
+			break;
+
+		/*
 		 * If kernel memory accounting is disabled, we ignore
 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
 		 * passing NULL for memcg.
_

Patches currently in -mm which might be from surenb@google.com are


