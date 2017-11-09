From: akpm@linux-foundation.org
Subject: + mm-simplify-nodemask-printing.patch added to -mm tree
Date: Thu, 09 Nov 2017 15:03:54 -0800
Message-ID: <5a04deda.7+Oqt31A8QFohKnS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbdKIXDz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2017 18:03:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify nodemask printing
has been added to the -mm tree.  Its filename is
     mm-simplify-nodemask-printing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-nodemask-printing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-nodemask-printing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: simplify nodemask printing

alloc_warn() and dump_header() have to explicitly handle NULL nodemask
which forces both paths to use pr_cont.  We can do better.  printk already
handles NULL pointers properly so all we need is to teach nodemask_pr_args
to handle NULL nodemask carefully.  This allows simplification of both
alloc_warn() and dump_header() and gets rid of pr_cont altogether.

This patch has been motivated by patch from Joe Perches
http://lkml.kernel.org/r/b31236dfe3fc924054fd7842bde678e71d193638.1509991345.git.joe@perches.com

Link: http://lkml.kernel.org/r/20171109100531.3cn2hcqnuj7mjaju@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    2 +-
 mm/oom_kill.c            |   12 ++++--------
 mm/page_alloc.c          |   12 +++---------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff -puN include/linux/nodemask.h~mm-simplify-nodemask-printing include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-simplify-nodemask-printing
+++ a/include/linux/nodemask.h
@@ -104,7 +104,7 @@ extern nodemask_t _unused_nodemask_arg_;
  *
  * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
  */
-#define nodemask_pr_args(maskp)		MAX_NUMNODES, (maskp)->bits
+#define nodemask_pr_args(maskp)	(maskp) ? MAX_NUMNODES : 0, (maskp) ? (maskp)->bits : NULL
 
 /*
  * The inline keyword gives the compiler room to decide to inline, or
diff -puN mm/oom_kill.c~mm-simplify-nodemask-printing mm/oom_kill.c
--- a/mm/oom_kill.c~mm-simplify-nodemask-printing
+++ a/mm/oom_kill.c
@@ -426,14 +426,10 @@ static void dump_tasks(struct mem_cgroup
 
 static void dump_header(struct oom_control *oc, struct task_struct *p)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), nodemask=",
-		current->comm, oc->gfp_mask, &oc->gfp_mask);
-	if (oc->nodemask)
-		pr_cont("%*pbl", nodemask_pr_args(oc->nodemask));
-	else
-		pr_cont("(null)");
-	pr_cont(",  order=%d, oom_score_adj=%hd\n",
-		oc->order, current->signal->oom_score_adj);
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), nodemask=%*pbl, order=%d, oom_score_adj=%hd\n",
+		current->comm, oc->gfp_mask, &oc->gfp_mask,
+		nodemask_pr_args(oc->nodemask), oc->order,
+			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
 		pr_warn("COMPACTION is disabled!!!\n");
 
diff -puN mm/page_alloc.c~mm-simplify-nodemask-printing mm/page_alloc.c
--- a/mm/page_alloc.c~mm-simplify-nodemask-printing
+++ a/mm/page_alloc.c
@@ -3275,20 +3275,14 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
 		return;
 
-	pr_warn("%s: ", current->comm);
-
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_cont("%pV", &vaf);
+	pr_warn("%s: %pV, mode:%#x(%pGg), nodemask=%*pbl\n",
+			current->comm, &vaf, gfp_mask, &gfp_mask,
+			nodemask_pr_args(nodemask));
 	va_end(args);
 
-	pr_cont(", mode:%#x(%pGg), nodemask=", gfp_mask, &gfp_mask);
-	if (nodemask)
-		pr_cont("%*pbl\n", nodemask_pr_args(nodemask));
-	else
-		pr_cont("(null)\n");
