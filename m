From: akpm@linux-foundation.org
Subject: + memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch added to -mm tree
Date: Tue, 01 Jul 2008 17:21:44 -0700
Message-ID: <200807020021.m620LjLk022474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbYGBAWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 20:22:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: fix shmem_unuse_inode charging
has been added to the -mm tree.  Its filename is
     memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch

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
Subject: memcg: fix shmem_unuse_inode charging
From: Hugh Dickins <hugh@veritas.com>

The mem_cgroup_cache_charge in shmem_unuse_inode has been moved after the
radix_tree_preload, so generating a BUG: sleeping function called from
invalid context.  Move it back, uncharging where necessary.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging mm/shmem.c
--- a/mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging
+++ a/mm/shmem.c
@@ -922,27 +922,24 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
-	if (error)
-		goto out;
-	/*
-	 * Because we use GFP_NOWAIT in add_to_page_cache(), we can see -ENOMEM
-	 * failure because of memory pressure in memory resource controller.
-	 * Then, precharge page while we can wait, uncharge at failure will be
-	 * automatically done in add_to_page_cache()
-	 */
+	/* Precharge page using GFP_KERNEL while we can wait */
 	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
-		goto preload_out;
-
+		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error) {
+		mem_cgroup_uncharge_cache_page(page);
+		goto out;
+	}
 	error = 1;
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
-	if (ptr && ptr->val == entry.val)
-		error = add_to_page_cache(page, inode->i_mapping, idx,
-					GFP_NOWAIT);
-	else /* we don't have to account this page. */
+	if (ptr && ptr->val == entry.val) {
+		error = add_to_page_cache(page, inode->i_mapping,
+						idx, GFP_NOWAIT);
+		/* does mem_cgroup_uncharge_cache_page on error */
+	} else	/* we must compensate for our precharge above */
 		mem_cgroup_uncharge_cache_page(page);
 
 	if (error == -EEXIST) {
@@ -969,7 +966,6 @@ found:
 	if (ptr)
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-preload_out:
 	radix_tree_preload_end();
 out:
 	unlock_page(page);
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
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
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

