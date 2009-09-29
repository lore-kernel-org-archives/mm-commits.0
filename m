From: akpm@linux-foundation.org
Subject: + memcg-fix-refcnt-goes-to-minus.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:46:22 -0700
Message-ID: <200909291946.n8TJkNKj031519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZI2Tq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix refcnt going negative
has been added to the -mm tree.  Its filename is
     memcg-fix-refcnt-goes-to-minus.patch

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
Subject: memcg: fix refcnt going negative
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

__mem_cgroup_largest_soft_limit_node() returns a mem_cgroup_per_zone "mz"
with incremnted mz->mem->css's refcnt.  Then, the caller of this function
has to call css_put(mz->mem->css).

But, mz can be !NULL even if "not found" i.e.  without css_get().  By
this, css->refcnt will go down to minus.

This may cause various things...one of results will be
initite-loop in css_tryget()  as this.

INFO: RCU detected CPU 0 stall (t=10000 jiffies)
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU 0:
<snip>

 <<EOE>>  <IRQ>  [<ffffffff810884bd>] trace_hardirqs_off+0xd/0x10
  [<ffffffff8102a940>] flat_send_IPI_mask+0x90/0xb0
  [<ffffffff8102a9c9>] flat_send_IPI_all+0x69/0x70
  [<ffffffff81027372>] arch_trigger_all_cpu_backtrace+0x62/0xa0
  [<ffffffff810bff8e>] __rcu_pending+0x7e/0x370
  [<ffffffff810c02c7>] rcu_check_callbacks+0x47/0x130
  [<ffffffff81063a26>] update_process_times+0x46/0x70
  [<ffffffff81085930>] tick_sched_timer+0x60/0x160
  [<ffffffff810858d0>] ? tick_sched_timer+0x0/0x160
  [<ffffffff8107a03a>] __run_hrtimer+0xba/0x150
  [<ffffffff8107a325>] hrtimer_interrupt+0xd5/0x1b0
  [<ffffffff81426dfe>] ? trace_hardirqs_off_thunk+0x3a/0x3c
  [<ffffffff8142cacd>] smp_apic_timer_interrupt+0x6d/0x9b
  [<ffffffff8100cb33>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff811317b6>] ? mem_cgroup_walk_tree+0x156/0x180
  [<ffffffff811316d3>] ? mem_cgroup_walk_tree+0x73/0x180
  [<ffffffff81131692>] ? mem_cgroup_walk_tree+0x32/0x180
  [<ffffffff81131a00>] ? mem_cgroup_get_local_stat+0x0/0x110
  [<ffffffff81131d5b>] ? mem_control_stat_show+0x14b/0x330
  [<ffffffff810a57fd>] ? cgroup_seqfile_show+0x3d/0x60

Above shows CPU0 caught in css_tryget()'s inifinite loop because
of bad refcnt.

This is a fix to set mz=NULL at the top of retry path.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-refcnt-goes-to-minus mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-refcnt-goes-to-minus
+++ a/mm/memcontrol.c
@@ -447,9 +447,10 @@ static struct mem_cgroup_per_zone *
 __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
 {
 	struct rb_node *rightmost = NULL;
-	struct mem_cgroup_per_zone *mz = NULL;
+	struct mem_cgroup_per_zone *mz;
 
 retry:
+	mz = NULL;
 	rightmost = rb_last(&mctz->rb_root);
 	if (!rightmost)
 		goto done;		/* Nothing to reclaim from */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-refcnt-goes-to-minus.patch
cgroup-catch-bad-css-refcnt-at-css_put.patch
memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch
memcg-reduce-check-for-softlimit-excess.patch

