From: akpm@linux-foundation.org
Subject: [merged] memcg-add-mem_cgroup_cancel_charge.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:39 -0800
Message-ID: <200912162037.nBGKbdHZ013356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964831AbZLPUh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: add mem_cgroup_cancel_charge()
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_cancel_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add mem_cgroup_cancel_charge()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

There are some places calling both res_counter_uncharge() and css_put() to
cancel the charge and the refcnt we have got by mem_cgroup_tyr_charge().

This patch introduces mem_cgroup_cancel_charge() and call it in those
places.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_cancel_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_cancel_charge
+++ a/mm/memcontrol.c
@@ -1500,6 +1500,21 @@ nomem:
 }
 
 /*
+ * Somemtimes we have to undo a charge we got by try_charge().
+ * This function is for that and do uncharge, put css's refcnt.
+ * gotten by try_charge().
+ */
+static void mem_cgroup_cancel_charge(struct mem_cgroup *mem)
+{
+	if (!mem_cgroup_is_root(mem)) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		if (do_swap_account)
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+	}
+	css_put(&mem->css);
+}
+
+/*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
  * it's concern. (dropping refcnt from swap can be called against removed
@@ -1565,12 +1580,7 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		if (!mem_cgroup_is_root(mem)) {
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
-			if (do_swap_account)
-				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-		}
-		css_put(&mem->css);
+		mem_cgroup_cancel_charge(mem);
 		return;
 	}
 
@@ -1734,14 +1744,7 @@ static int mem_cgroup_move_parent(struct
 cancel:
 	put_page(page);
 uncharge:
-	/* drop extra refcnt by try_charge() */
-	css_put(&parent->css);
-	/* uncharge if move fails */
-	if (!mem_cgroup_is_root(parent)) {
-		res_counter_uncharge(&parent->res, PAGE_SIZE);
-		if (do_swap_account)
-			res_counter_uncharge(&parent->memsw, PAGE_SIZE);
-	}
+	mem_cgroup_cancel_charge(parent);
 	return ret;
 }
 
@@ -1958,12 +1961,7 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-	}
-	css_put(&mem->css);
+	mem_cgroup_cancel_charge(mem);
 }
 
 static void
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
linux-next.patch

