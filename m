From: akpm@linux-foundation.org
Subject: + memcg-oom-kill-disable-and-oom-status-update.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:03:09 -0700
Message-ID: <201003192303.o2JN395n017359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0CSXDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg-oom-kill-disable-and-oom-status-update
has been added to the -mm tree.  Its filename is
     memcg-oom-kill-disable-and-oom-status-update.patch

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
Subject: memcg-oom-kill-disable-and-oom-status-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 - rewrote Documentation.
 - changed oom_kill_disable from unsigned long to int.

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    6 +++++-
 mm/memcontrol.c                  |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-oom-kill-disable-and-oom-status-update Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-oom-kill-disable-and-oom-status-update
+++ a/Documentation/cgroups/memory.txt
@@ -514,10 +514,14 @@ As.
 This operation is only allowed to the top cgroup of subhierarchy.
 If oom-killer is disabled, tasks under cgroup will hang/sleep
 in memcg's oom-waitq when they request accountable memory.
+
 For running them, you have to relax the memcg's oom sitaution by
-	* enlarge limit
+	* enlarge limit or reduce usage.
+To reduce usage,
 	* kill some tasks.
 	* move some tasks to other group with account migration.
+	* remove some files (on tmpfs?)
+
 Then, stopped tasks will work again.
 
 At reading, current status of OOM is shown.
diff -puN mm/memcontrol.c~memcg-oom-kill-disable-and-oom-status-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-kill-disable-and-oom-status-update
+++ a/mm/memcontrol.c
@@ -214,6 +214,8 @@ struct mem_cgroup {
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
+	/* OOM-Killer disable */
+	int 		oom_kill_disable;
 
 	/* set when res.limit == memsw.limit */
 	bool		memsw_is_minimum;
@@ -235,8 +237,6 @@ struct mem_cgroup {
 	 * mem_cgroup ? And what type of charges should we move ?
 	 */
 	unsigned long 	move_charge_at_immigrate;
-	/* Disable OOM killer */
-	unsigned long	oom_kill_disable;
 	/*
 	 * percpu counter.
 	 */
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

