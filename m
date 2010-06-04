From: akpm@linux-foundation.org
Subject: + memcg-fix-wake-up-in-oom-wait-queue.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:42:01 -0700
Message-ID: <201006042242.o54Mg1r9022609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410Ab0FDWmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix wake up in oom wait queue
has been added to the -mm tree.  Its filename is
     memcg-fix-wake-up-in-oom-wait-queue.patch

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
Subject: memcg: fix wake up in oom wait queue
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

OOM-waitqueue should be waken up when oom_disable is canceled.  This is a
fix for 3c11ecf448eff8f1 ("memcg: oom kill disable and oom status").

How to test:
 Create a cgroup A...
 1. set memory.limit and memory.memsw.limit to be small value
 2. echo 1 > /cgroup/A/memory.oom_control, this disables oom-kill.
 3. run a program which must cause OOM.

A program executed in 3 will sleep by oom_waiqueue in memcg.  Then, how to
wake it up is problem.

 1. echo 0 > /cgroup/A/memory.oom_control (enable OOM-killer)
 2. echo big mem > /cgroup/A/memory.memsw.limit_in_bytes(allow more swap)

etc..

Without the patch, a task in slept can not be waken up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-wake-up-in-oom-wait-queue mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-wake-up-in-oom-wait-queue
+++ a/mm/memcontrol.c
@@ -1370,7 +1370,7 @@ static void memcg_wakeup_oom(struct mem_
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (mem->oom_kill_disable && atomic_read(&mem->oom_lock))
+	if (atomic_read(&mem->oom_lock))
 		memcg_wakeup_oom(mem);
 }
 
@@ -3781,6 +3781,8 @@ static int mem_cgroup_oom_control_write(
 		return -EINVAL;
 	}
 	mem->oom_kill_disable = val;
+	if (!val)
+		memcg_oom_recover(mem);
 	cgroup_unlock();
 	return 0;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroup-alloc_css_id-increments-hierarchy-depth.patch
vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch
memcg-fix-wake-up-in-oom-wait-queue.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch

