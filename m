From: akpm@linux-foundation.org
Subject: + memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch added to -mm tree
Date: Wed, 05 Jan 2011 12:51:47 -0800
Message-ID: <201101052051.p05KpmZP017671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730Ab1AEUwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 15:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, bblum@andrew.cmu.edu, kamezawa.hiroyuki@gmail.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     memcg-fix-deadlock-between-cpuset-and-memcg-fix
has been added to the -mm tree.  Its filename is
     memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch

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
thp-compound_trans_order-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-fix-deadlock-between-cpuset-and-memcg.patch
memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch

