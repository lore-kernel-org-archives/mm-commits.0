From: akpm@linux-foundation.org
Subject: + x86-implement-pte_special-fix.patch added to -mm tree
Date: Fri, 04 Jul 2008 15:11:00 -0700
Message-ID: <200807042211.m64MB0b6021043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYGDWSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 18:18:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, npiggin@suse.de, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, zach.brown@oracle.com


The patch titled
     Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
has been added to the -mm tree.  Its filename is
     x86-implement-pte_special-fix.patch

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
Subject: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
From: Hugh Dickins <hugh@veritas.com>

On Fri, 4 Jul 2008, Zan Lynx wrote:
> Ryan Hope wrote:
> > I have tested this with 2.6.26-rc5-mm3 and with 2.6.26-rc8 w/ the
> > get_user_pages_fast patches from -rc5-mm3... Xorg 1.4.99.* will start
> > to load but hangs at a black screen. At this point, I can not switch
> > to another tty. When I try pressing ctrl+alt+del the kernel ooopses
> > and the caps lock led starts to blink. This happens using the nv,
> > radeon and radeonhd drivers (the nv was tested on another box
> > obviously). I have also tried to unselect HAVE_GET_USER_PAGES_FAST in
> > my kernel config but this does not help. I can not figure out where or
> > what the bug is. I can provide any other info you guys need to figure
> > this out. Let me know what I can do.
>
> I think that I've seen this too on 2.6.26-rc8 on my laptop.  It's 64-bit

Your attachment tells us it's actually 2.6.26-rc8-mm1, less of a worry.

> AMD-64 single core (although I run a SMP-alternatives kernel on it) and I was
> using the nv driver.
>
> The symptoms are the same.  Everything was working great until I started X.  I
> SSH'd in and got the dmesg after X locked up.  The full dmesg and config are
> attached because Thunderbird is a very stupid program and won't let me paste
> without wrapping.
>
> Here is a bit of what I got though.
>
> [  269.224276] BUG: unable to handle kernel paging request at ffffe20003480000
> [  269.224291] IP: [<ffffffff80297e30>] copy_page_range+0x520/0x760
> [  269.224306] PGD 1102067 PUD 1103067 PMD 0
> [  269.224315] Oops: 0000 [1] SMP
>
> [  269.224473] Call Trace:
> [  269.224495]  [<ffffffff80239a9b>] dup_mm+0x26b/0x3c0
> [  269.224507]  [<ffffffff8023a84c>] copy_process+0xc2c/0x1210
> [  269.224518]  [<ffffffff8023aea3>] do_fork+0x73/0x310
> [  269.224526]  [<ffffffff8024719e>] sys_rt_sigaction+0x8e/0xd0
> [  269.224536]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
> [  269.224542]  [<ffffffff8020c5d7>] ptregscall_common+0x67/0xb0

Useful info, thank you; even more useful was the Code line in your attachment

> [  269.224557] Code: 00 00 48 b9 00 00 00 00 00 e2 ff ff 48 21 d8 48 c1 e8 0c 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 29 d0 48 01 c1 0f 84 10 ff ff ff <48> 8b 01 48 89 ca f6 c4 40 74 04 48 8b 51 10 90 ff 42 08 90 ff

which is enough to identify the oops as in copy_one_pte's get_page(page).
Here's a patch I think we need, which I'm hoping will fix both your
crashes - please let us know - thanks a lot.

Stop mprotect's pte_modify from wiping out the x86 pte_special bit, which
caused oops thereafter when vm_normal_page thought X's abnormal was normal.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/pgtable.h~x86-implement-pte_special-fix include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~x86-implement-pte_special-fix
+++ a/include/asm-x86/pgtable.h
@@ -57,7 +57,7 @@
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_ACCESSED | _PAGE_DIRTY)
+			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
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
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
security-remove-unused-forwards.patch
exec-remove-some-includes.patch
exec-remove-some-includes-fix.patch
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
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
x86-implement-pte_special-fix.patch
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

