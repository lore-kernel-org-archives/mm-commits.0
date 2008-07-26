From: akpm@linux-foundation.org
Subject: - x86-implement-pte_special-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 17:28:23 -0700
Message-ID: <200807260028.m6Q0SN48007294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbYGZAbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 20:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, npiggin@suse.de, pbadari@us.ibm.com, rmh3093@gmail.com, shaggy@a


The patch titled
     Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
has been removed from the -mm tree.  Its filename was
     x86-implement-pte_special-fix.patch

This patch was dropped because it was folded into x86-implement-pte_special.patch

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
Reported-by: "Ryan Hope" <rmh3093@gmail.com>
Tested-by: "Ryan Hope" <rmh3093@gmail.com>
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
Tested-by: Zan Lynx <zlynx@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/pgtable.h~x86-implement-pte_special-fix include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~x86-implement-pte_special-fix
+++ a/include/asm-x86/pgtable.h
@@ -57,7 +57,7 @@
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_ACCESSED | _PAGE_DIRTY)
+			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
git-unionfs.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
prio_tree-debugging-patch.patch

