From: akpm@linux-foundation.org
Subject: [merged] mm-simplify-nodemask-printing.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:05:31 -0800
Message-ID: <20171116200531.wC6v4GaHi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936737AbdKPUFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, joe@perches.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify nodemask printing
has been removed from the -mm tree.  Its filename was
     mm-simplify-nodemask-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix tile warning, per Arnd]
Link: http://lkml.kernel.org/r/20171109100531.3cn2hcqnuj7mjaju@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    4 +++-
 mm/oom_kill.c            |   12 ++++--------
 mm/page_alloc.c          |   12 +++---------
 3 files changed, 10 insertions(+), 18 deletions(-)

diff -puN include/linux/nodemask.h~mm-simplify-nodemask-printing include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-simplify-nodemask-printing
+++ a/include/linux/nodemask.h
@@ -104,7 +104,9 @@ extern nodemask_t _unused_nodemask_arg_;
  *
  * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
  */
-#define nodemask_pr_args(maskp)		MAX_NUMNODES, (maskp)->bits
+#define nodemask_pr_args(maskp)				\
+	((maskp) != NULL) ? MAX_NUMNODES : 0,		\
+	((maskp) != NULL) ? (maskp)->bits : NULL
 
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
@@ -3279,20 +3279,14 @@ void warn_alloc(gfp_t gfp_mask, nodemask
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
