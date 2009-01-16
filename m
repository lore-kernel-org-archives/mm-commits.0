From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-error-path-of-mem_cgroup_move_parent.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:26 -0800
Message-ID: <200901161917.n0GJHQjM026008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936937AbZAPTSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix error path of mem_cgroup_move_parent
has been removed from the -mm tree.  Its filename was
     memcg-fix-error-path-of-mem_cgroup_move_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix error path of mem_cgroup_move_parent
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

There is a bug in error path of mem_cgroup_move_parent.

Extra refcnt got from try_charge should be dropped, and usages incremented
by try_charge should be decremented in both error paths:

    A: failure at get_page_unless_zero
    B: failure at isolate_lru_page

This bug makes this parent directory unremovable.

In case of A, rmdir doesn't return, because res.usage doesn't go down to 0
at mem_cgroup_force_empty even after all the pc in lru are removed.

In case of B, rmdir fails and returns -EBUSY, because it has extra ref
counts even after res.usage goes down to 0.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-error-path-of-mem_cgroup_move_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-error-path-of-mem_cgroup_move_parent
+++ a/mm/memcontrol.c
@@ -994,14 +994,15 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	css_put(&from->css);
 	res_counter_uncharge(&from->res, PAGE_SIZE);
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (do_swap_account)
 		res_counter_uncharge(&from->memsw, PAGE_SIZE);
+	css_put(&from->css);
+
+	css_get(&to->css);
 	pc->mem_cgroup = to;
 	mem_cgroup_charge_statistics(to, pc, true);
-	css_get(&to->css);
 	ret = 0;
 out:
 	unlock_page_cgroup(pc);
@@ -1034,8 +1035,10 @@ static int mem_cgroup_move_parent(struct
 	if (ret || !parent)
 		return ret;
 
-	if (!get_page_unless_zero(page))
-		return -EBUSY;
+	if (!get_page_unless_zero(page)) {
+		ret = -EBUSY;
+		goto uncharge;
+	}
 
 	ret = isolate_lru_page(page);
 
@@ -1044,19 +1047,23 @@ static int mem_cgroup_move_parent(struct
 
 	ret = mem_cgroup_move_account(pc, child, parent);
 
-	/* drop extra refcnt by try_charge() (move_account increment one) */
-	css_put(&parent->css);
 	putback_lru_page(page);
 	if (!ret) {
 		put_page(page);
+		/* drop extra refcnt by try_charge() */
+		css_put(&parent->css);
 		return 0;
 	}
-	/* uncharge if move fails */
+
 cancel:
+	put_page(page);
+uncharge:
+	/* drop extra refcnt by try_charge() */
+	css_put(&parent->css);
+	/* uncharge if move fails */
 	res_counter_uncharge(&parent->res, PAGE_SIZE);
 	if (do_swap_account)
 		res_counter_uncharge(&parent->memsw, PAGE_SIZE);
-	put_page(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-get-put-parents-at-create-free.patch

