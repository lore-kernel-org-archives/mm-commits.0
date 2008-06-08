From: akpm@linux-foundation.org
Subject: - hugetlb-fix-lockdep-error.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:09 -0700
Message-ID: <200806081947.m58Jl997017399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbYFHTry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix lockdep error
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-lockdep-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix lockdep error
From: Nick Piggin <npiggin@suse.de>

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc4 #30
---------------------------------------------
heap-overflow/2250 is trying to acquire lock:
 (&mm->page_table_lock){--..}, at: [<c0000000000cf2e8>] .copy_hugetlb_page_range+0x108/0x280

but task is already holding lock:
 (&mm->page_table_lock){--..}, at: [<c0000000000cf2dc>] .copy_hugetlb_page_range+0xfc/0x280

other info that might help us debug this:
3 locks held by heap-overflow/2250:
 #0:  (&mm->mmap_sem){----}, at: [<c000000000050e44>] .dup_mm+0x134/0x410
 #1:  (&mm->mmap_sem/1){--..}, at: [<c000000000050e54>] .dup_mm+0x144/0x410
 #2:  (&mm->page_table_lock){--..}, at: [<c0000000000cf2dc>] .copy_hugetlb_page_range+0xfc/0x280

stack backtrace:
Call Trace:
[c00000003b2774e0] [c000000000010ce4] .show_stack+0x74/0x1f0 (unreliable)
[c00000003b2775a0] [c0000000003f10e0] .dump_stack+0x20/0x34
[c00000003b277620] [c0000000000889bc] .__lock_acquire+0xaac/0x1080
[c00000003b277740] [c000000000089000] .lock_acquire+0x70/0xb0
[c00000003b2777d0] [c0000000003ee15c] ._spin_lock+0x4c/0x80
[c00000003b277870] [c0000000000cf2e8] .copy_hugetlb_page_range+0x108/0x280
[c00000003b277950] [c0000000000bcaa8] .copy_page_range+0x558/0x790
[c00000003b277ac0] [c000000000050fe0] .dup_mm+0x2d0/0x410
[c00000003b277ba0] [c000000000051d24] .copy_process+0xb94/0x1020
[c00000003b277ca0] [c000000000052244] .do_fork+0x94/0x310
[c00000003b277db0] [c000000000011240] .sys_clone+0x60/0x80
[c00000003b277e30] [c0000000000078c4] .ppc_clone+0x8/0xc

Fix is the same way that mm/memory.c copy_page_range does the
lockdep annotation.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-fix-lockdep-error mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-lockdep-error
+++ a/mm/hugetlb.c
@@ -785,7 +785,7 @@ int copy_hugetlb_page_range(struct mm_st
 			continue;
 
 		spin_lock(&dst->page_table_lock);
-		spin_lock(&src->page_table_lock);
+		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
 		if (!huge_pte_none(huge_ptep_get(src_pte))) {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

