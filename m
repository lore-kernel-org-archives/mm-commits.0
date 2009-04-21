From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch added to -mm tree
Date: Tue, 21 Apr 2009 15:53:37 -0700
Message-ID: <200904212253.n3LMrc3J024614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbZDUW5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 18:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, a.p.zijlstra@chello.nl, hannes@cmpxchg.org, hsweeten@visionengravers.com


The patch titled
     mm/page-writeback.c: dirty limit type should be unsigned long
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page-writeback.c: dirty limit type should be unsigned long
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

get_dirty_limits() calls clip_bdi_dirty_limit() and task_dirty_limit()
with variable pbdi_dirty as one of the arguments.  This variable is an
unsigned long * but both functions expect it to be a long *.  This causes
the following sparse warnings:

  warning: incorrect type in argument 3 (different signedness)
     expected long *pbdi_dirty
     got unsigned long *pbdi_dirty
  warning: incorrect type in argument 2 (different signedness)
     expected long *pdirty
     got unsigned long *pbdi_dirty

Fix the warnings by changing the long * to unsigned long * in both
functions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-dirty-limit-type-should-be-unsigned-long mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-dirty-limit-type-should-be-unsigned-long
+++ a/mm/page-writeback.c
@@ -265,18 +265,19 @@ static void bdi_writeout_fraction(struct
  * This avoids exceeding the total dirty_limit when the floating averages
  * fluctuate too quickly.
  */
-static void
-clip_bdi_dirty_limit(struct backing_dev_info *bdi, long dirty, long *pbdi_dirty)
+static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
+		unsigned long dirty, unsigned long *pbdi_dirty)
 {
-	long avail_dirty;
+	unsigned long avail_dirty;
 
-	avail_dirty = dirty -
-		(global_page_state(NR_FILE_DIRTY) +
+	avail_dirty = global_page_state(NR_FILE_DIRTY) +
 		 global_page_state(NR_WRITEBACK) +
 		 global_page_state(NR_UNSTABLE_NFS) +
-		 global_page_state(NR_WRITEBACK_TEMP));
+		 global_page_state(NR_WRITEBACK_TEMP);
 
-	if (avail_dirty < 0)
+	if (avail_dirty < dirty)
+		avail_dirty = dirty - avail_dirty;
+	else
 		avail_dirty = 0;
 
 	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
@@ -299,10 +300,10 @@ static inline void task_dirties_fraction
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+static void task_dirty_limit(struct task_struct *tsk, unsigned long *pdirty)
 {
 	long numerator, denominator;
-	long dirty = *pdirty;
+	unsigned long dirty = *pdirty;
 	u64 inv = dirty >> 3;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

