From: akpm@linux-foundation.org
Subject: + mmcompaction-serialize-waitqueue_active-checks-for-real.patch
 added to -mm tree
Date: Thu, 14 Sep 2017 14:23:13 -0700
Message-ID: <59baf341.yAoqPKOY3h8AU4RI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdINVXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2017 17:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, parri.andrea@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,compaction: serialize waitqueue_active() checks (for real)
has been added to the -mm tree.  Its filename is
     mmcompaction-serialize-waitqueue_active-checks-for-real.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmcompaction-serialize-waitqueue_active-checks-for-real.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmcompaction-serialize-waitqueue_active-checks-for-real.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm,compaction: serialize waitqueue_active() checks (for real)

Andrea brought to my attention that the L->{L,S} guarantees are completely
bogus for this case.  I was looking at the diagram, from the offending
commit, when that _is_ the race, we had the load reordered already.

What we need is at least S->L semantics, thus simply use wq_has_sleeper()
to serialize the call for good.

Link: http://lkml.kernel.org/r/20170914175313.GB811@linux-80c1.suse
Fixes: 46acef048a6 (mm,compaction: serialize waitqueue_active() checks)
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Andrea Parri <parri.andrea@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mmcompaction-serialize-waitqueue_active-checks-for-real mm/compaction.c
--- a/mm/compaction.c~mmcompaction-serialize-waitqueue_active-checks-for-real
+++ a/mm/compaction.c
@@ -1999,17 +1999,14 @@ void wakeup_kcompactd(pg_data_t *pgdat,
 	if (pgdat->kcompactd_max_order < order)
 		pgdat->kcompactd_max_order = order;
 
-	/*
-	 * Pairs with implicit barrier in wait_event_freezable()
-	 * such that wakeups are not missed in the lockless
-	 * waitqueue_active() call.
-	 */
-	smp_acquire__after_ctrl_dep();
