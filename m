From: akpm@linux-foundation.org
Subject: [merged]
 mmcompaction-serialize-waitqueue_active-checks-for-real.patch removed from
 -mm tree
Date: Wed, 04 Oct 2017 12:40:37 -0700
Message-ID: <20171004194037.Jez5SUIe8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, parri.andrea@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm,compaction: serialize waitqueue_active() checks (for real)
has been removed from the -mm tree.  Its filename was
     mmcompaction-serialize-waitqueue_active-checks-for-real.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
