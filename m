From: akpm@linux-foundation.org
Subject: +
 memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem.patch added to -mm tree
Date: Thu, 26 May 2016 14:02:17 -0700
Message-ID: <57476459.Rw9i442FWobp7cH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbcEZVCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add RCU locking around css_for_each_descendant_pre() in memcg_offline_kmem()
has been added to the -mm tree.  Its filename is
     memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem.patch

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
Subject: memcg: add RCU locking around css_for_each_descendant_pre() in memcg_offline_kmem()

memcg_offline_kmem() may be called from memcg_free_kmem() after a css init
failure.  memcg_free_kmem() is a ->css_free callback which is called
without cgroup_mutex and memcg_offline_kmem() ends up using
css_for_each_descendant_pre() without any locking.  Fix it by adding rcu
read locking around it.

 mkdir: cannot create directory `65530': No space left on device
 [  527.241361] ===============================
 [  527.241845] [ INFO: suspicious RCU usage. ]
 [  527.242367] 4.6.0-work+ #321 Not tainted
 [  527.242730] -------------------------------
 [  527.243220] kernel/cgroup.c:4008 cgroup_mutex or RCU read lock required!
 [  527.243970]
 [  527.243970] other info that might help us debug this:
 [  527.243970]
 [  527.244715]
 [  527.244715] rcu_scheduler_active = 1, debug_locks = 0
 [  527.245463] 2 locks held by kworker/0:5/1664:
 [  527.245939]  #0:  ("cgroup_destroy"){.+.+..}, at: [<ffffffff81060ab5>] process_one_work+0x165/0x4a0
 [  527.246958]  #1:  ((&css->destroy_work)#3){+.+...}, at: [<ffffffff81060ab5>] process_one_work+0x165/0x4a0
 [  527.248098]
 [  527.248098] stack backtrace:
 [  527.249565] CPU: 0 PID: 1664 Comm: kworker/0:5 Not tainted 4.6.0-work+ #321
 [  527.250429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
 [  527.250555] Workqueue: cgroup_destroy css_free_work_fn
 [  527.250555]  0000000000000000 ffff880178747c68 ffffffff8128bfc7 ffff880178b8ac40
 [  527.250555]  0000000000000001 ffff880178747c98 ffffffff8108c297 0000000000000000
 [  527.250555]  ffff88010de54138 000000000000fffb ffff88010de537e8 ffff880178747cc0
 [  527.250555] Call Trace:
 [  527.250555]  [<ffffffff8128bfc7>] dump_stack+0x68/0xa1
 [  527.250555]  [<ffffffff8108c297>] lockdep_rcu_suspicious+0xd7/0x110
 [  527.250555]  [<ffffffff810ca03d>] css_next_descendant_pre+0x7d/0xb0
 [  527.250555]  [<ffffffff8114d14a>] memcg_offline_kmem.part.44+0x4a/0xc0
 [  527.250555]  [<ffffffff8114d3ac>] mem_cgroup_css_free+0x1ec/0x200
 [  527.250555]  [<ffffffff810ccdc9>] css_free_work_fn+0x49/0x5e0
 [  527.250555]  [<ffffffff81060b15>] process_one_work+0x1c5/0x4a0
 [  527.250555]  [<ffffffff81060ab5>] ? process_one_work+0x165/0x4a0
 [  527.250555]  [<ffffffff81060e39>] worker_thread+0x49/0x490
 [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
 [  527.250555]  [<ffffffff81060df0>] ? process_one_work+0x4a0/0x4a0
 [  527.250555]  [<ffffffff810672ba>] kthread+0xea/0x100
 [  527.250555]  [<ffffffff814cbcff>] ret_from_fork+0x1f/0x40
 [  527.250555]  [<ffffffff810671d0>] ? kthread_create_on_node+0x200/0x200

Link: http://lkml.kernel.org/r/20160526203018.GG23194@mtj.duckdns.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem
+++ a/mm/memcontrol.c
@@ -2894,6 +2894,7 @@ static void memcg_offline_kmem(struct me
 	 * ordering is imposed by list_lru_node->lock taken by
 	 * memcg_drain_all_list_lrus().
 	 */
+	rcu_read_lock(); /* can be called from css_free w/o cgroup_mutex */
 	css_for_each_descendant_pre(css, &memcg->css) {
 		child = mem_cgroup_from_css(css);
 		BUG_ON(child->kmemcg_id != kmemcg_id);
@@ -2901,6 +2902,8 @@ static void memcg_offline_kmem(struct me
 		if (!memcg->use_hierarchy)
 			break;
 	}
+	rcu_read_unlock();
+
 	memcg_drain_all_list_lrus(kmemcg_id, parent->kmemcg_id);
 
 	memcg_free_cache_id(kmemcg_id);
_

Patches currently in -mm which might be from tj@kernel.org are

memcg-add-rcu-locking-around-css_for_each_descendant_pre-in-memcg_offline_kmem.patch

