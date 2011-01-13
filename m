From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:39:52 -0800
Message-ID: <201101132339.p0DNdr8G007571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1AMXki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, bblum@andrew.cmu.edu, kamezawa.hiroyuki@gmail.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-deadlock-between-cpuset-and-memcg-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch

This patch was dropped because it was folded into memcg-fix-deadlock-between-cpuset-and-memcg.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-deadlock-between-cpuset-and-memcg-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

We must clear "mc.moving_task" before waking up all waiters at the end of
task migration.

Otherwise, there can be a small race like:

        mem_cgroup_clear_mc()        |    mem_cgroup_wait_acct_move()
    ---------------------------------+-----------------------------------
          __mem_cgroup_clear_mc()    |
            wake_up_all()            |
                                     |    prepare_to_wait()
                                     |    if (mc.moving_task) -> true
                                     |      schedule()
                                     |      -> noone wakes it up.
          mc.moving_task = NULL      |

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Ben Blum <bblum@andrew.cmu.edu>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-deadlock-between-cpuset-and-memcg-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-deadlock-between-cpuset-and-memcg-fix
+++ a/mm/memcontrol.c
@@ -4756,12 +4756,16 @@ static void mem_cgroup_clear_mc(void)
 {
 	struct mem_cgroup *from = mc.from;
 
+	/*
+	 * we must clear moving_task before waking up waiters at the end of
+	 * task migration.
+	 */
+	mc.moving_task = NULL;
 	__mem_cgroup_clear_mc();
 	spin_lock(&mc.lock);
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-	mc.moving_task = NULL;
 	mem_cgroup_end_move(from);
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-compound_trans_order.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-fix-deadlock-between-cpuset-and-memcg.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch

