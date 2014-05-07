From: akpm@linux-foundation.org
Subject: + memcg-fold-mem_cgroup_stolen.patch added to -mm tree
Date: Wed, 07 May 2014 13:32:53 -0700
Message-ID: <536a9875.Py6CgNJO1EfH4EGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaEGUcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 16:32:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, h.huangqiang@huawei.com

Subject: + memcg-fold-mem_cgroup_stolen.patch added to -mm tree
To: h.huangqiang@huawei.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 13:32:53 -0700


The patch titled
     Subject: memcg: fold mem_cgroup_stolen
has been added to the -mm tree.  Its filename is
     memcg-fold-mem_cgroup_stolen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fold-mem_cgroup_stolen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fold-mem_cgroup_stolen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg: fold mem_cgroup_stolen

It is only used in __mem_cgroup_begin_update_page_stat(), the name is
confusing and 2 routines for one thing also confuse people, so fold this
function seems more clear.

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-fold-mem_cgroup_stolen mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fold-mem_cgroup_stolen
+++ a/mm/memcontrol.c
@@ -1568,23 +1568,12 @@ static void mem_cgroup_end_move(struct m
 }
 
 /*
- * 2 routines for checking "mem" is under move_account() or not.
+ * A routine for checking "mem" is under move_account() or not.
  *
- * mem_cgroup_stolen() -  checking whether a cgroup is mc.from or not. This
- *			  is used for avoiding races in accounting.  If true,
- *			  pc->mem_cgroup may be overwritten.
- *
- * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
- *			  under hierarchy of moving cgroups. This is for
- *			  waiting at hith-memory prressure caused by "move".
+ * Checking a cgroup is mc.from or mc.to or under hierarchy of
+ * moving cgroups. This is for waiting at hith-memory pressure
+ * caused by "move".
  */
-
-static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
-{
-	VM_BUG_ON(!rcu_read_lock_held());
-	return atomic_read(&memcg->moving_account) > 0;
-}
-
 static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *from;
@@ -1627,7 +1616,6 @@ static bool mem_cgroup_wait_acct_move(st
  * Take this lock when
  * - a code tries to modify page's memcg while it's USED.
  * - a code tries to modify page state accounting in a memcg.
- * see mem_cgroup_stolen(), too.
  */
 static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
 				  unsigned long *flags)
@@ -2301,9 +2289,10 @@ again:
 	 * If this memory cgroup is not under account moving, we don't
 	 * need to take move_lock_mem_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
+	 * rcu_read_unlock().
 	 */
-	if (!mem_cgroup_stolen(memcg))
+	VM_BUG_ON(!rcu_read_lock_held());
+	if (atomic_read(&memcg->moving_account) <= 0)
 		return;
 
 	move_lock_mem_cgroup(memcg, flags);
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch

