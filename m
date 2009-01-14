From: akpm@linux-foundation.org
Subject: + memcg-fix-a-race-when-setting-memoryswappiness.patch added to -mm tree
Date: Wed, 14 Jan 2009 14:11:38 -0800
Message-ID: <200901142211.n0EMBcZr021449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbZANWM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 17:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix a race when setting memory.swappiness
has been added to the -mm tree.  Its filename is
     memcg-fix-a-race-when-setting-memoryswappiness.patch

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
Subject: memcg: fix a race when setting memory.swappiness
From: Li Zefan <lizf@cn.fujitsu.com>

(suppose: memcg->use_hierarchy == 0 and memcg->swappiness == 60)

echo 10 > /memcg/0/swappiness   |
  mem_cgroup_swappiness_write() |
    ...                         | echo 1 > /memcg/0/use_hierarchy
                                | mkdir /mnt/0/1
                                |   sub_memcg->swappiness = 60;
    memcg->swappiness = 10;     |

In the above scenario, we end up having 2 different swappiness
values in a single hierarchy.

We should hold cgroup_lock() when cheking cgrp->children list.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-a-race-when-setting-memoryswappiness mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-a-race-when-setting-memoryswappiness
+++ a/mm/memcontrol.c
@@ -1992,6 +1992,7 @@ static int mem_cgroup_swappiness_write(s
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup *parent;
+
 	if (val > 100)
 		return -EINVAL;
 
@@ -1999,15 +2000,22 @@ static int mem_cgroup_swappiness_write(s
 		return -EINVAL;
 
 	parent = mem_cgroup_from_cont(cgrp->parent);
+
+	cgroup_lock();
+
 	/* If under hierarchy, only empty-root can set this value */
 	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children)))
+	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+		cgroup_unlock();
 		return -EINVAL;
+	}
 
 	spin_lock(&memcg->reclaim_param_lock);
 	memcg->swappiness = val;
 	spin_unlock(&memcg->reclaim_param_lock);
 
+	cgroup_unlock();
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-clean-up-kconfig.patch
cgroups-consolidate-cgroup-documents.patch
idr-fix-wrong-kernel-doc.patch
memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch
memcg-fix-error-path-of-mem_cgroup_move_parent.patch
memcg-fix-hierarchical-reclaim.patch
memcg-make-oom-less-frequently.patch
memcg-fix-section-mismatch.patch
memcg-fix-a-race-when-setting-memoryswappiness.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

