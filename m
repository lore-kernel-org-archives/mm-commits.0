From: akpm@linux-foundation.org
Subject: + cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch added to -mm tree
Date: Thu, 17 Feb 2011 14:47:47 -0800
Message-ID: <201102172247.p1HMllFl020471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab1BQWsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_attch()
has been added to the -mm tree.  Its filename is
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch

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
Subject: cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_attch()
From: Li Zefan <lizf@cn.fujitsu.com>

oldcs->mems_allowed is not modified during cpuset_attach(), so we don't
have to copy it to a buffer allocated by NODEMASK_ALLOC().  Just pass it
to cpuset_migrate_mm().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch
+++ a/kernel/cpuset.c
@@ -1438,10 +1438,9 @@ static void cpuset_attach(struct cgroup_
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
 	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
 
-	if (from == NULL || to == NULL)
+	if (to == NULL)
 		goto alloc_fail;
 
 	if (cs == &top_cpuset) {
@@ -1463,18 +1462,16 @@ static void cpuset_attach(struct cgroup_
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	*from = oldcs->mems_allowed;
 	*to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
 		mpol_rebind_mm(mm, to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, from, to);
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
 		mmput(mm);
 	}
 
 alloc_fail:
-	NODEMASK_FREE(from);
 	NODEMASK_FREE(to);
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

