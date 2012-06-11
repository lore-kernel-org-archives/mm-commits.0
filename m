From: akpm@linux-foundation.org
Subject: + mm-oom-fix-and-cleanup-oom-score-calculations.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:19:14 -0700
Message-ID: <20120611211914.A834BA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56626 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2FKVTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:19:17 -0400
Received: by bkty5 with SMTP id y5so250300bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:19:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davej@redhat.com, kosaki.motohiro@gmail.com


The patch titled
     Subject: mm, oom: fix and cleanup oom score calculations
has been added to the -mm tree.  Its filename is
     mm-oom-fix-and-cleanup-oom-score-calculations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fix and cleanup oom score calculations

The divide in p->signal->oom_score_adj * totalpages / 1000 within
oom_badness() was causing an overflow of the signed long data type.

This adds both the root bias and p->signal->oom_score_adj before doing the
normalization which fixes the issue and also cleans up the calculation.

Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fix-and-cleanup-oom-score-calculations mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-and-cleanup-oom-score-calculations
+++ a/mm/oom_kill.c
@@ -184,6 +184,7 @@ unsigned long oom_badness(struct task_st
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
 	long points;
+	long adj;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -192,7 +193,8 @@ unsigned long oom_badness(struct task_st
 	if (!p)
 		return 0;
 
-	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+	adj = p->signal->oom_score_adj;
+	if (adj == OOM_SCORE_ADJ_MIN) {
 		task_unlock(p);
 		return 0;
 	}
@@ -210,14 +212,11 @@ unsigned long oom_badness(struct task_st
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30 * totalpages / 1000;
+		adj -= 30;
 
-	/*
-	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
-	 * either completely disable oom killing or always prefer a certain
-	 * task.
-	 */
-	points += p->signal->oom_score_adj * totalpages / 1000;
+	/* Normalize to oom_score_adj units */
+	adj *= totalpages / 1000;
+	points += adj;
 
 	/*
 	 * Never return 0 for an eligible task regardless of the root bonus and
_
Subject: Subject: mm, oom: fix and cleanup oom score calculations

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-oom-fix-and-cleanup-oom-score-calculations.patch
slab-move-full-state-transition-to-an-initcall.patch

