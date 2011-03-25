From: akpm@linux-foundation.org
Subject: [merged] cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:27 -0700
Message-ID: <201103250725.p2P7PLZB026014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933953Ab1CYHZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_attach()
has been removed from the -mm tree.  Its filename was
     cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove unneeded NODEMASK_ALLOC() in cpuset_attach()
From: Li Zefan <lizf@cn.fujitsu.com>

oldcs->mems_allowed is not modified during cpuset_attach(), so we don't
have to copy it to a buffer allocated by NODEMASK_ALLOC().  Just pass it
to cpuset_migrate_mm().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
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

origin.patch
cgroup-remove-the-ns_cgroup.patch

