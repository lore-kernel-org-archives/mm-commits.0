From: akpm@linux-foundation.org
Subject: + memcg-move-charge-swapin-under-lock.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:49:06 -0700
Message-ID: <200810102349.m9ANn6Fs018336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbYJJXuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: move charge swapin under lock
has been added to the -mm tree.  Its filename is
     memcg-move-charge-swapin-under-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move charge swapin under lock
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

While page-cache's charge/uncharge is done under page_lock(), swap-cache
isn't.  (anonymous page is charged when it's newly allocated.)

This patch moves do_swap_page()'s charge() call under lock.  I don't see
any bad problem *now* but this fix will be good for future for avoiding
unnecessary racy state.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~memcg-move-charge-swapin-under-lock mm/memory.c
--- a/mm/memory.c~memcg-move-charge-swapin-under-lock
+++ a/mm/memory.c
@@ -2326,16 +2326,17 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
+	mark_page_accessed(page);
+
+	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+
 	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
+		unlock_page(page);
 		goto out;
 	}
 
-	mark_page_accessed(page);
-	lock_page(page);
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
-
 	/*
 	 * Back out if somebody else already faulted in this pte.
 	 */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

drivers-mfd-ucb1400_corec-further-unbork.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

