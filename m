From: akpm@linux-foundation.org
Subject: + memcg-clean-up-waiting-move-acct-v2-fix.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:41:25 -0700
Message-ID: <201006182341.o5INfPwb029934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895Ab0FRXmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-clean-up-waiting-move-acct-v2-fix
has been added to the -mm tree.  Its filename is
     memcg-clean-up-waiting-move-acct-v2-fix.patch

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
Subject: memcg-clean-up-waiting-move-acct-v2-fix
From: Balbir Singh <balbir@linux.vnet.ibm.com>

>
> When cgroup_cancel_attach() is called via cgroup_attach_task(),
> mem_cgroup_clear_mc() can be called even when any migration
> was done. In such case, mc.to and mc.from is NULL.
>
> But, memcg-clean-up-waiting-move-acct-v2.patch
> doesn't handle this correctly and pass NULL to memcg_oom_recover.
> fix it.
>
> BUG: unable to handle kernel paging request at 000000000000114c
> IP: [<ffffffff81153bb9>] memcg_oom_recover+0x9/0x30
> PGD 61ce4b067 PUD 613ea0067 PMD 0
> Oops: 0000 [#1] SMP
> <snip>
> Call Trace:
>  [<ffffffff81155359>] mem_cgroup_clear_mc+0x119/0x1c0
>  [<ffffffff811554de>] mem_cgroup_cancel_attach+0xe/0x10
>  [<ffffffff810b619c>] cgroup_attach_task+0x26c/0x2c0
>  [<ffffffff810b6257>] cgroup_tasks_write+0x67/0x1c0
>  [<ffffffff81121555>] ? might_fault+0xa5/0xb0
>  [<ffffffff8112150c>] ? might_fault+0x5c/0xb0
>  [<ffffffff810b40a2>] cgroup_file_write+0x2d2/0x330
>  [<ffffffff81093aa2>] ? print_lock_contention_bug+0x22/0xf0
>  [<ffffffff81259fef>] ? security_file_permission+0x1f/0x80
>  [<ffffffff8115d998>] vfs_write+0xc8/0x190
>  [<ffffffff8115e3a1>] sys_write+0x51/0x90
>  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
> Code: 20 48 39 43 20 41 bc f0 ff ff ff 75 c7 45 88 ae 48 11 00 00 45 31 e4 eb bb 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 <8b> 87 4c 11 00 00 85 c0 75 05 c9 c3 0f 1f 00 48 89 f9 31 d2 be
> RIP  [<ffffffff81153bb9>] memcg_oom_recover+0x9/0x30
>

Don't crash on a null memcg being passed, check if memcg
is NULL and handle the condition gracefully

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-clean-up-waiting-move-acct-v2-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-waiting-move-acct-v2-fix
+++ a/mm/memcontrol.c
@@ -1413,7 +1413,7 @@ static void memcg_wakeup_oom(struct mem_
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (atomic_read(&mem->oom_lock))
+	if (mem && atomic_read(&mem->oom_lock))
 		memcg_wakeup_oom(mem);
 }
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-waiting-move-acct-v2-fix.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch

