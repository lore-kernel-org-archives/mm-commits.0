From: akpm@linux-foundation.org
Subject: + x86-fix-intel-mac-booting-with-efi.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:40:47 -0700
Message-ID: <200807022340.m62NelKu009702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbYGBXmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, mingo@elte.hu, pjones@redhat.com, tglx@linutronix.de


The patch titled
     x86: fix Intel Mac booting with EFI
has been added to the -mm tree.  Its filename is
     x86-fix-intel-mac-booting-with-efi.patch

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
Subject: x86: fix Intel Mac booting with EFI
From: Hugh Dickins <hugh@veritas.com>

Fedora reports that mem_init()'s zap_low_mappings(), extended to SMP in
61165d7a035f6571c7576e7f51e7230157724c8d x86: fix app crashes after SMP
resume causes 32-bit Intel Mac machines to reboot very early when booting
with EFI.

The EFI code appears to manage low mappings for itself when needed; but
like many before it, confuses PSE with PAE.  So it has only been mapping
half the space it needed when PSE but not PAE.  This remained unnoticed
until we moved the SMP zap_low_mappings() before efi_enter_virtual_mode().
 Presumably could have been noticed years ago if anyone ran a UP kernel on
such machines?

Reviewed-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Peter Jones <pjones@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/efi_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/efi_32.c~x86-fix-intel-mac-booting-with-efi arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~x86-fix-intel-mac-booting-with-efi
+++ a/arch/x86/kernel/efi_32.c
@@ -49,13 +49,13 @@ void efi_call_phys_prelog(void)
 	local_irq_save(efi_rt_eflags);
 
 	/*
-	 * If I don't have PSE, I should just duplicate two entries in page
-	 * directory. If I have PSE, I just need to duplicate one entry in
+	 * If I don't have PAE, I should just duplicate two entries in page
+	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
 		    swapper_pg_dir[pgd_index(0)].pgd;
 		swapper_pg_dir[0].pgd =
@@ -93,7 +93,7 @@ void efi_call_phys_epilog(void)
 
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
 		    efi_bak_pg_dir_pointer[0].pgd;
 	} else {
_

Patches currently in -mm which might be from hugh@veritas.com are

mm-dirty-page-accounting-vs-vm_mixedmap.patch
linux-next.patch
git-unionfs.patch
unionfs-fix-memory-leak.patch
fsstack-fsstack_copy_inode_size-locking.patch
x86-fix-intel-mac-booting-with-efi.patch
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
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
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
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
prio_tree-debugging-patch.patch

