From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-stall-register_shrinker.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:31:19 -0800
Message-ID: <20180201193119.rbo_K5v0z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbeBATbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, shakeelb@google.com


The patch titled
     Subject: mm: do not stall register_shrinker()
has been removed from the -mm tree.  Its filename was
     mm-do-not-stall-register_shrinker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not stall register_shrinker()

Shakeel Butt reported he has observed in production systems that the job
loader gets stuck for 10s of seconds while doing a mount operation.  It
turns out that it was stuck in register_shrinker() because some unrelated
job was under memory pressure and was spending time in shrink_slab(). 
Machines have a lot of shrinkers registered and jobs under memory pressure
have to traverse all of those memcg-aware shrinkers and affect unrelated
jobs which want to register their own shrinkers.

To solve the issue, this patch simply bails out slab shrinking if it is
found that someone wants to register a shrinker in parallel.  A downside
is it could cause unfair shrinking between shrinkers.  However, it should
be rare and we can add compilcated logic if we find it's not enough.

[akpm@linux-foundation.org: tweak code comment]
Link: http://lkml.kernel.org/r/20171115005602.GB23810@bbox
Link: http://lkml.kernel.org/r/1511481899-20335-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/vmscan.c~mm-do-not-stall-register_shrinker mm/vmscan.c
--- a/mm/vmscan.c~mm-do-not-stall-register_shrinker
+++ a/mm/vmscan.c
@@ -489,6 +489,15 @@ static unsigned long shrink_slab(gfp_t g
 			sc.nid = 0;
 
 		freed += do_shrink_slab(&sc, shrinker, priority);
+		/*
+		 * Bail out if someone want to register a new shrinker to
+		 * prevent the regsitration from being stalled for long periods
+		 * by parallel ongoing shrinking.
+		 */
+		if (rwsem_is_contended(&shrinker_rwsem)) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 
 	up_read(&shrinker_rwsem);
_

Patches currently in -mm which might be from minchan@kernel.org are


