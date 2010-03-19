From: akpm@linux-foundation.org
Subject: + memcg-oom-wakeup-filter-update.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:03:03 -0700
Message-ID: <201003192303.o2JN33OE017347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0CSXDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg-oom-wakeup-filter-update.txt
has been added to the -mm tree.  Its filename is
     memcg-oom-wakeup-filter-update.patch

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
Subject: memcg-oom-wakeup-filter-update.txt
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Updated comments.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-wakeup-filter-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-wakeup-filter-update
+++ a/mm/memcontrol.c
@@ -1304,7 +1304,6 @@ static int memcg_oom_wake_function(wait_
 	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg;
 	struct oom_wait_info *oom_wait_info;
 
-	/* both of oom_wait_info->mem and wake_mem are stable under us */
 	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
 
 	if (oom_wait_info->mem == wake_mem)
@@ -1312,7 +1311,10 @@ static int memcg_oom_wake_function(wait_
 	/* if no hierarchy, no match */
 	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
 		return 0;
-	/* check hierarchy */
+	/*
+	 * Both of oom_wait_info->mem and wake_mem are stable under us.
+	 * Then we can use css_is_ancestor without taking care of RCU.
+	 */
 	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
 	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
 		return 0;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-disable-move-charge-in-no-mmu-case.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

