From: akpm@linux-foundation.org
Subject: + mm-do-not-stall-register_shrinker.patch added to -mm tree
Date: Mon, 27 Nov 2017 16:33:01 -0800
Message-ID: <5a1caebd.n4PJpAJMOA9zpblM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbdK1AdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, shakeelb@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not stall register_shrinker()
has been added to the -mm tree.  Its filename is
     mm-do-not-stall-register_shrinker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-stall-register_shrinker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-stall-register_shrinker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmscan.c~mm-do-not-stall-register_shrinker mm/vmscan.c
--- a/mm/vmscan.c~mm-do-not-stall-register_shrinker
+++ a/mm/vmscan.c
@@ -486,6 +486,14 @@ static unsigned long shrink_slab(gfp_t g
 			sc.nid = 0;
 
 		freed += do_shrink_slab(&sc, shrinker, priority);
+		/*
+		 * bail out if someone want to register a new shrinker to
+		 * prevent long time stall by parallel ongoing shrinking.
+		 */
+		if (rwsem_is_contended(&shrinker_rwsem)) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 
 	up_read(&shrinker_rwsem);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-clean-up-swap-readahead.patch
mm-swap-unify-cluster-based-and-vma-based-swap-readahead.patch
mm-do-not-stall-register_shrinker.patch

