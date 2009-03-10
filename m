From: akpm@linux-foundation.org
Subject: + memcg-charge-swapcache-to-proper-memcg.patch added to -mm tree
Date: Tue, 10 Mar 2009 13:59:33 -0700
Message-ID: <200903102059.n2AKxXrd004327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbZCJVBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 17:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memcg: charge swapcache to proper memcg
has been added to the -mm tree.  Its filename is
     memcg-charge-swapcache-to-proper-memcg.patch

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
Subject: memcg: charge swapcache to proper memcg
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

memcg_test.txt says at 4.1:

	This swap-in is one of the most complicated work. In do_swap_page(),
	following events occur when pte is unchanged.

	(1) the page (SwapCache) is looked up.
	(2) lock_page()
	(3) try_charge_swapin()
	(4) reuse_swap_page() (may call delete_swap_cache())
	(5) commit_charge_swapin()
	(6) swap_free().

	Considering following situation for example.

	(A) The page has not been charged before (2) and reuse_swap_page()
	    doesn't call delete_from_swap_cache().
	(B) The page has not been charged before (2) and reuse_swap_page()
	    calls delete_from_swap_cache().
	(C) The page has been charged before (2) and reuse_swap_page() doesn't
	    call delete_from_swap_cache().
	(D) The page has been charged before (2) and reuse_swap_page() calls
	    delete_from_swap_cache().

	    memory.usage/memsw.usage changes to this page/swp_entry will be
	 Case          (A)      (B)       (C)     (D)
         Event
       Before (2)     0/ 1     0/ 1      1/ 1    1/ 1
          ===========================================
          (3)        +1/+1    +1/+1     +1/+1   +1/+1
          (4)          -       0/ 0       -     -1/ 0
          (5)         0/-1     0/ 0     -1/-1    0/ 0
          (6)          -       0/-1       -      0/-1
          ===========================================
       Result         1/ 1     1/ 1      1/ 1    1/ 1

       In any cases, charges to this page should be 1/ 1.

In case of (D), mem_cgroup_try_get_from_swapcache() returns NULL
(because lookup_swap_cgroup() returns NULL), so "+1/+1" at (3) means
charges to the memcg("foo") to which the "current" belongs.
OTOH, "-1/0" at (4) and "0/-1" at (6) means uncharges from the memcg("baa")
to which the page has been charged.

So, if the "foo" and "baa" is different(for example because of task move),
this charge will be moved from "baa" to "foo".

I think this is an unexpected behavior.

This patch fixes this by modifying mem_cgroup_try_get_from_swapcache()
to return the memcg to which the swapcache has been charged if PCG_USED bit
is set.
IIUC, checking PCG_USED bit of swapcache is safe under page lock.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-charge-swapcache-to-proper-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-charge-swapcache-to-proper-memcg
+++ a/mm/memcontrol.c
@@ -994,13 +994,24 @@ nomem:
 static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
 {
 	struct mem_cgroup *mem;
+	struct page_cgroup *pc;
 	swp_entry_t ent;
 
+	VM_BUG_ON(!PageLocked(page));
+
 	if (!PageSwapCache(page))
 		return NULL;
 
-	ent.val = page_private(page);
-	mem = lookup_swap_cgroup(ent);
+	pc = lookup_page_cgroup(page);
+	/*
+	 * Used bit of swapcache is solid under page lock.
+	 */
+	if (PageCgroupUsed(pc))
+		mem = pc->mem_cgroup;
+	else {
+		ent.val = page_private(page);
+		mem = lookup_swap_cgroup(ent);
+	}
 	if (!mem)
 		return NULL;
 	if (!css_tryget(&mem->css))
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch

