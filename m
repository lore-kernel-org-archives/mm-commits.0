From: akpm@linux-foundation.org
Subject: + memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch added to -mm tree
Date: Tue, 01 Jul 2008 17:25:06 -0700
Message-ID: <200807020025.m620P65j022545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915AbYGBA0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 20:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memcg: further checking of disabled flag
has been added to the -mm tree.  Its filename is
     memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: further checking of disabled flag
From: Hugh Dickins <hugh@veritas.com>

Further adjustments to the mem_cgroup_subsys.disabled tests: add one to
mem_cgroup_shrink_usage; move mem_cgroup_charge_common's into its callers,
before they've done any work; and add one to mem_cgroup_move_lists, to
avoid the overhead of its bit spin locking and unlocking.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag
+++ a/mm/memcontrol.c
@@ -354,6 +354,9 @@ void mem_cgroup_move_lists(struct page *
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	/*
 	 * We cannot lock_page_cgroup while holding zone's lru_lock,
 	 * because other holders of lock_page_cgroup can be interrupted
@@ -533,9 +536,6 @@ static int mem_cgroup_charge_common(stru
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
@@ -620,6 +620,9 @@ err:
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * If already mapped, we don't have to account.
 	 * If page cache, page->mapping has address_space.
@@ -638,6 +641,9 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * Corner case handling. This is called from add_to_page_cache()
 	 * in usual. But some FS (shmem) precharges this page before calling it
@@ -789,6 +795,9 @@ int mem_cgroup_shrink_usage(struct mm_st
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	css_get(&mem->css);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-dirty-page-accounting-vs-vm_mixedmap.patch
git-unionfs.patch
unionfs-fix-memory-leak.patch
fsstack-fsstack_copy_inode_size-locking.patch
mm-remove-nopfn-fix.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch
hugetlb-reservations-move-region-tracking-earlier.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
security-remove-unused-forwards.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
prio_tree-debugging-patch.patch

