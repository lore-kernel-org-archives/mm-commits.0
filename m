From: akpm@linux-foundation.org
Subject: + mm-terminate-shrink_slab-loop-if-signal-is-pending.patch added
 to -mm tree
Date: Wed, 06 Dec 2017 15:28:39 -0800
Message-ID: <5a287d27.zPT1xyJWY9/HgZvX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdLFX2l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 18:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: surenb@google.com, cl@linux.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, penberg@kernel.org, rientjes@google.com, timmurray@google.com, tkjos@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: terminate shrink_slab loop if signal is pending
has been added to the -mm tree.  Its filename is
     mm-terminate-shrink_slab-loop-if-signal-is-pending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-terminate-shrink_slab-loop-if-signal-is-pending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-terminate-shrink_slab-loop-if-signal-is-pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vmscan.c: terminate shrink_slab loop if signal is pending

Slab shrinkers can be quite time consuming and when signal is pending they
can delay handling of the signal.  If fatal signal is pending there is no
point in shrinking that process since it will be killed anyway.  This
change checks for pending fatal signals inside shrink_slab loop and if one
is detected terminates this loop early.

Link: http://lkml.kernel.org/r/20171206192026.25133-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending mm/vmscan.c
--- a/mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending
+++ a/mm/vmscan.c
@@ -487,6 +487,13 @@ static unsigned long shrink_slab(gfp_t g
 		};
 
 		/*
+		 * We are about to die and free our memory.
+		 * Stop shrinking which might delay signal handling.
+		 */
+		if (unlikely(fatal_signal_pending(current))
+			break;
+
+		/*
 		 * If kernel memory accounting is disabled, we ignore
 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
 		 * passing NULL for memcg.
_

Patches currently in -mm which might be from surenb@google.com are

mm-terminate-shrink_slab-loop-if-signal-is-pending.patch

