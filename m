From: akpm@linux-foundation.org
Subject: + memcg-improve-performance-in-moving-swap-charge.patch added to -mm tree
Date: Tue, 22 Dec 2009 16:26:57 -0800
Message-ID: <200912230026.nBN0QvOK001208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbZLWA1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 19:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     memcg: improve performance in moving swap charge
has been added to the -mm tree.  Its filename is
     memcg-improve-performance-in-moving-swap-charge.patch

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
Subject: memcg: improve performance in moving swap charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Try to reduce overheads in moving swap charge by:

- Adds a new function(__mem_cgroup_put), which takes "count" as a arg and
  decrement mem->refcnt by "count".
- Removed res_counter_uncharge, css_put, and mem_cgroup_put from the path
  of moving swap account, and consolidate all of them into mem_cgroup_clear_mc.
  We cannot do that about mc.to->refcnt.

These changes reduces the overhead from 1.35sec to 0.9sec to move charges
of 1G anonymous memory(including 500MB swap) in my test environment.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   73 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-improve-performance-in-moving-swap-charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-performance-in-moving-swap-charge
+++ a/mm/memcontrol.c
@@ -255,6 +255,7 @@ static struct move_charge_struct {
 	struct mem_cgroup *to;
 	unsigned long precharge;
 	unsigned long moved_charge;
+	unsigned long moved_swap;
 	struct task_struct *moving_task;	/* a task moving charges */
 	wait_queue_head_t waitq;		/* a waitq for other context */
 } mc = {
@@ -2277,6 +2278,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * @entry: swap entry to be moved
  * @from:  mem_cgroup which the entry is moved from
  * @to:  mem_cgroup which the entry is moved to
+ * @need_fixup: whether we should fixup res_counters and refcounts.
  *
  * It succeeds only when the swap_cgroup's record for this entry is the same
  * as the mem_cgroup's id of @from.
@@ -2287,7 +2289,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * both res and memsw, and called css_get().
  */
 static int mem_cgroup_move_swap_account(swp_entry_t entry,
-				struct mem_cgroup *from, struct mem_cgroup *to)
+		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
 {
 	unsigned short old_id, new_id;
 
@@ -2295,20 +2297,29 @@ static int mem_cgroup_move_swap_account(
 	new_id = css_id(&to->css);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
-		if (!mem_cgroup_is_root(from))
-			res_counter_uncharge(&from->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(from, false);
-		mem_cgroup_put(from);
+		mem_cgroup_swap_statistics(to, true);
 		/*
-		 * we charged both to->res and to->memsw, so we should uncharge
-		 * to->res.
+		 * This function is only called from task migration context now.
+		 * It postpones res_counter and refcount handling till the end
+		 * of task migration(mem_cgroup_clear_mc()) for performance
+		 * improvement. But we cannot postpone mem_cgroup_get(to)
+		 * because if the process that has been moved to @to does
+		 * swap-in, the refcount of @to might be decreased to 0.
 		 */
-		if (!mem_cgroup_is_root(to))
-			res_counter_uncharge(&to->res, PAGE_SIZE);
-		mem_cgroup_swap_statistics(to, true);
 		mem_cgroup_get(to);
-		css_put(&to->css);
-
+		if (need_fixup) {
+			if (!mem_cgroup_is_root(from))
+				res_counter_uncharge(&from->memsw, PAGE_SIZE);
+			mem_cgroup_put(from);
+			/*
+			 * we charged both to->res and to->memsw, so we should
+			 * uncharge to->res.
+			 */
+			if (!mem_cgroup_is_root(to))
+				res_counter_uncharge(&to->res, PAGE_SIZE);
+			css_put(&to->css);
+		}
 		return 0;
 	}
 	return -EINVAL;
@@ -3393,9 +3404,9 @@ static void mem_cgroup_get(struct mem_cg
 	atomic_inc(&mem->refcnt);
 }
 
-static void mem_cgroup_put(struct mem_cgroup *mem)
+static void __mem_cgroup_put(struct mem_cgroup *mem, int count)
 {
-	if (atomic_dec_and_test(&mem->refcnt)) {
+	if (atomic_sub_and_test(count, &mem->refcnt)) {
 		struct mem_cgroup *parent = parent_mem_cgroup(mem);
 		__mem_cgroup_free(mem);
 		if (parent)
@@ -3403,6 +3414,11 @@ static void mem_cgroup_put(struct mem_cg
 	}
 }
 
+static void mem_cgroup_put(struct mem_cgroup *mem)
+{
+	__mem_cgroup_put(mem, 1);
+}
+
 /*
  * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
  */
@@ -3761,6 +3777,29 @@ static void mem_cgroup_clear_mc(void)
 		__mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
 	}
+	/* we must fixup refcnts and charges */
+	if (mc.moved_swap) {
+		WARN_ON_ONCE(mc.moved_swap > INT_MAX);
+		/* uncharge swap account from the old cgroup */
+		if (!mem_cgroup_is_root(mc.from))
+			res_counter_uncharge(&mc.from->memsw,
+						PAGE_SIZE * mc.moved_swap);
+		__mem_cgroup_put(mc.from, mc.moved_swap);
+
+		if (!mem_cgroup_is_root(mc.to)) {
+			/*
+			 * we charged both to->res and to->memsw, so we should
+			 * uncharge to->res.
+			 */
+			res_counter_uncharge(&mc.to->res,
+						PAGE_SIZE * mc.moved_swap);
+			VM_BUG_ON(test_bit(CSS_ROOT, &mc.to->css.flags));
+			__css_put(&mc.to->css, mc.moved_swap);
+		}
+		/* we've already done mem_cgroup_get(mc.to) */
+
+		mc.moved_swap = 0;
+	}
 	mc.from = NULL;
 	mc.to = NULL;
 	mc.moving_task = NULL;
@@ -3790,11 +3829,13 @@ static int mem_cgroup_can_attach(struct 
 			VM_BUG_ON(mc.to);
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
+			VM_BUG_ON(mc.moved_swap);
 			VM_BUG_ON(mc.moving_task);
 			mc.from = from;
 			mc.to = mem;
 			mc.precharge = 0;
 			mc.moved_charge = 0;
+			mc.moved_swap = 0;
 			mc.moving_task = current;
 
 			ret = mem_cgroup_precharge_mc(mm);
@@ -3855,8 +3896,12 @@ put:			/* is_target_pte_for_mc() gets th
 			break;
 		case MC_TARGET_SWAP:
 			ent = target.ent;
-			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to))
+			if (!mem_cgroup_move_swap_account(ent,
+						mc.from, mc.to, false)) {
 				mc.precharge--;
+				/* we fixup refcnts and charges later. */
+				mc.moved_swap++;
+			}
 			break;
 		default:
 			break;
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch

