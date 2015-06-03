From: akpm@linux-foundation.org
Subject: + memcg-remove-unused-mem_cgroup-oom_wakeups.patch added to -mm
 tree
Date: Wed, 03 Jun 2015 15:47:33 -0700
Message-ID: <556f8405.HmYCYE5u63WaOI6t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbbFCWre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2015 18:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove unused mem_cgroup->oom_wakeups
has been added to the -mm tree.  Its filename is
     memcg-remove-unused-mem_cgroup-oom_wakeups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-unused-mem_cgroup-oom_wakeups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-unused-mem_cgroup-oom_wakeups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: remove unused mem_cgroup->oom_wakeups

Since 4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully"), nobody uses mem_cgroup->oom_wakeups.  Remove it.

While at it, also fold memcg_wakeup_oom() into memcg_oom_recover() which
is its only user.  This cleanup was suggested by Michal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-mem_cgroup-oom_wakeups mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-mem_cgroup-oom_wakeups
+++ a/mm/memcontrol.c
@@ -287,7 +287,6 @@ struct mem_cgroup {
 
 	bool		oom_lock;
 	atomic_t	under_oom;
-	atomic_t	oom_wakeups;
 
 	int	swappiness;
 	/* OOM-Killer disable */
@@ -1851,17 +1850,10 @@ static int memcg_oom_wake_function(wait_
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-static void memcg_wakeup_oom(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->oom_wakeups);
-	/* for filtering, pass "memcg" as argument. */
-	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
-}
-
 static void memcg_oom_recover(struct mem_cgroup *memcg)
 {
 	if (memcg && atomic_read(&memcg->under_oom))
-		memcg_wakeup_oom(memcg);
+		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
memcg-remove-unused-mem_cgroup-oom_wakeups.patch
memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

