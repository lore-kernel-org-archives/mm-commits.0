From: akpm@linux-foundation.org
Subject: [merged] ksm-mem-cgroup-charge-swapin-copy.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:46 -0800
Message-ID: <200912152153.nBFLrkEV015302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761240AbZLOVyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, balbir@linux.vnet.ibm.com, chrisw@redhat.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ksm: mem cgroup charge swapin copy
has been removed from the -mm tree.  Its filename was
     ksm-mem-cgroup-charge-swapin-copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: mem cgroup charge swapin copy
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

But ksm swapping does require one small change in mem cgroup handling. 
When do_swap_page()'s call to ksm_might_need_to_copy() does indeed
substitute a duplicate page to accommodate a different anon_vma (or a the
!PageSwapCache check in mem_cgroup_try_charge_swapin().

That was returning success without charging, on the assumption that
pte_same() would fail after, which is not the case here.  Originally I
proposed that success, so that an unshrinkable mem cgroup at its limit
would not fail unnecessarily; but that's a minor point, and there are
plenty of other places where we may fail an overallocation which might
later prove unnecessary.  So just go ahead and do what all the other
exceptions do: proceed to charge current mm.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~ksm-mem-cgroup-charge-swapin-copy mm/memcontrol.c
--- a/mm/memcontrol.c~ksm-mem-cgroup-charge-swapin-copy
+++ a/mm/memcontrol.c
@@ -1737,11 +1737,12 @@ int mem_cgroup_try_charge_swapin(struct 
 		goto charge_cur_mm;
 	/*
 	 * A racing thread's fault, or swapoff, may have already updated
-	 * the pte, and even removed page from swap cache: return success
-	 * to go on to do_swap_page()'s pte_same() test, which should fail.
+	 * the pte, and even removed page from swap cache: in those cases
+	 * do_swap_page()'s pte_same() test will fail; but there's also a
+	 * KSM case which does need to charge the page.
 	 */
 	if (!PageSwapCache(page))
-		return 0;
+		goto charge_cur_mm;
 	mem = try_get_mem_cgroup_from_swapcache(page);
 	if (!mem)
 		goto charge_cur_mm;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

