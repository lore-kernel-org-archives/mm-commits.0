From: akpm@linux-foundation.org
Subject: + cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:03:22 -0700
Message-ID: <200903302303.n2UN3MnU016618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbZC3XH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     memcg: try_get_mem_cgroup_from_swapcache fix
has been added to the -mm tree.  Its filename is
     cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch

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
Subject: memcg: try_get_mem_cgroup_from_swapcache fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

css_tryget can be called twice in !PageCgroupUsed case.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix
+++ a/mm/memcontrol.c
@@ -1027,9 +1027,11 @@ static struct mem_cgroup *try_get_mem_cg
 	/*
 	 * Used bit of swapcache is solid under page lock.
 	 */
-	if (PageCgroupUsed(pc))
+	if (PageCgroupUsed(pc)) {
 		mem = pc->mem_cgroup;
-	else {
+		if (mem && !css_tryget(&mem->css))
+			mem = NULL;
+	} else {
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup(ent);
 		rcu_read_lock();
@@ -1038,10 +1040,6 @@ static struct mem_cgroup *try_get_mem_cg
 			mem = NULL;
 		rcu_read_unlock();
 	}
-	if (!mem)
-		return NULL;
-	if (!css_tryget(&mem->css))
-		return NULL;
 	return mem;
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch

