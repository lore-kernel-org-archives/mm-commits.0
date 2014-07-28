From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-dont-allow-fault_around_bytes-to-be-0.patch removed from -mm tree
Date: Mon, 28 Jul 2014 14:15:02 -0700
Message-ID: <53d6bd56.Psu7uDPiQyJQP5TK%akpm__41200.8396852345$1406582124$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40450 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaG1VPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 17:15:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1286933qaq.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 14:15:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't allow fault_around_bytes to be 0
has been removed from the -mm tree.  Its filename was
     mm-dont-allow-fault_around_bytes-to-be-0.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: don't allow fault_around_bytes to be 0

Sasha Levin triggered use-after-free when fuzzing using trinity and the
KASAN patchset:

	AddressSanitizer: use after free in do_read_fault.isra.40+0x3c2/0x510 at addr ffff88048a733110
	page:ffffea001229ccc0 count:0 mapcount:0 mapping:          (null) index:0x0
	page flags: 0xafffff80008000(tail)
	page dumped because: kasan error
	CPU: 6 PID: 9262 Comm: trinity-c104 Not tainted 3.16.0-rc6-next-20140723-sasha-00047-g289342b-dirty #929
	 00000000000000fb 0000000000000000 ffffea001229ccc0 ffff88038ac0fb78
	 ffffffffa5e40903 ffff88038ac0fc48 ffff88038ac0fc38 ffffffffa142acfc
	 0000000000000001 ffff880509ff5aa8 ffff88038ac10038 ffff88038ac0fbb0
	Call Trace:
	dump_stack (lib/dump_stack.c:52)
	kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
	? debug_smp_processor_id (lib/smp_processor_id.c:57)
	? preempt_count_sub (kernel/sched/core.c:2606)
	? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
	? do_read_fault.isra.40 (mm/memory.c:2784 mm/memory.c:2849 mm/memory.c:2898)
	__asan_load8 (mm/kasan/kasan.c:364)
	? do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
	do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
	? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
	? __pte_alloc (mm/memory.c:598)
	handle_mm_fault (mm/memory.c:3092 mm/memory.c:3225 mm/memory.c:3345 mm/memory.c:3374)
	? pud_huge (./arch/x86/include/asm/paravirt.h:611 arch/x86/mm/hugetlbpage.c:76)
	__get_user_pages (mm/gup.c:286 mm/gup.c:478)
	__mlock_vma_pages_range (mm/mlock.c:262)
	__mm_populate (mm/mlock.c:710)
	SyS_remap_file_pages (mm/mmap.c:2653 mm/mmap.c:2593)
	tracesys (arch/x86/kernel/entry_64.S:541)
	Read of size 8 by thread T9262:
	Memory state around the buggy address:
	 ffff88048a732e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a732f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a732f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	>ffff88048a733100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	                         ^
	 ffff88048a733180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

It looks like that pte pointer is invalid in do_fault_around().
This could happen if fault_around_bytes is set to 0.
fault_around_pages() and fault_around_mask() calls rounddown_pow_of_to(fault_around_bytes)
The result of rounddown_pow_of_to is undefined if parameter == 0
(in my environment it returns 0x8000000000000000).

One way to fix this would be to return 0 from fault_around_pages() if fault_around_bytes == 0,
however this would add extra code on fault path.

So let's just forbid to set fault_around_bytes to zero.
Fault around is not used if fault_around_pages() <= 1, so if anyone doesn't want to use
it, fault_around_bytes could be set to any value in range [1, 2*PAGE_SIZE - 1]
instead of 0.

Fixes: a9b0f861("mm: nominate faultaround area in bytes rather than page order")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-dont-allow-fault_around_bytes-to-be-0 mm/memory.c
--- a/mm/memory.c~mm-dont-allow-fault_around_bytes-to-be-0
+++ a/mm/memory.c
@@ -2784,7 +2784,7 @@ static int fault_around_bytes_get(void *
 
 static int fault_around_bytes_set(void *data, u64 val)
 {
-	if (val / PAGE_SIZE > PTRS_PER_PTE)
+	if (!val || val / PAGE_SIZE > PTRS_PER_PTE)
 		return -EINVAL;
 	fault_around_bytes = val;
 	return 0;
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
linux-next.patch

