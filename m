From: akpm@linux-foundation.org
Subject: + x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch added to -mm tree
Date: Thu, 27 Oct 2011 15:48:34 -0700
Message-ID: <201110272248.p9RMmZrH010496@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1J0WtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 18:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad.wilk@oracle.com, a.p.zijlstra@chello.nl, hpa@zytor.com, jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
has been added to the -mm tree.  Its filename is
     x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch

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
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode

Fix an outstanding issue that has been reported since 2.6.37.  Under a
heavy loaded machine processing "fork()" calls could crash with:

BUG: unable to handle kernel paging request at f573fc8c
IP: [<c01abc54>] swap_count_continued+0x104/0x180
*pdpt = 000000002a3b9027 *pde = 0000000001bed067 *pte = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in:
Pid: 1638, comm: apache2 Not tainted 3.0.4-linode37 #1
EIP: 0061:[<c01abc54>] EFLAGS: 00210246 CPU: 3
EIP is at swap_count_continued+0x104/0x180
.. snip..
Call Trace:
 [<c01ac222>] ? __swap_duplicate+0xc2/0x160
 [<c01040f7>] ? pte_mfn_to_pfn+0x87/0xe0
 [<c01ac2e4>] ? swap_duplicate+0x14/0x40
 [<c01a0a6b>] ? copy_pte_range+0x45b/0x500
 [<c01a0ca5>] ? copy_page_range+0x195/0x200
 [<c01328c6>] ? dup_mmap+0x1c6/0x2c0
 [<c0132cf8>] ? dup_mm+0xa8/0x130
 [<c013376a>] ? copy_process+0x98a/0xb30
 [<c013395f>] ? do_fork+0x4f/0x280
 [<c01573b3>] ? getnstimeofday+0x43/0x100
 [<c010f770>] ? sys_clone+0x30/0x40
 [<c06c048d>] ? ptregs_clone+0x15/0x48
 [<c06bfb71>] ? syscall_call+0x7/0xb

The problem is that in copy_page_range() we turn lazy mode on, and then in
swap_entry_free() we call swap_count_continued() which ends up in:

         map = kmap_atomic(page, KM_USER0) + offset;

and then later we touch *map.

Since we are running in batched mode (lazy) we don't actually set up the
PTE mappings and the kmap_atomic is not done synchronously and ends up
trying to dereference a page that has not been set.

Looking at kmap_atomic_prot_pfn(), it uses 'arch_flush_lazy_mmu_mode' and
doing the same in kmap_atomic_prot() and __kunmap_atomic() makes the problem
go away.

Interestingly, commit b8bcfe997e4615 ("x86/paravirt: remove lazy mode in
interrupts") removed part of this to fix an interrupt issue - but it went
to far and did not consider this scenario.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode
+++ a/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {
_
Subject: Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
linux-next.patch
x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch

