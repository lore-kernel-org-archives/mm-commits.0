From: akpm@linux-foundation.org
Subject: [merged] thp-set-compound-tail-page-_count-to-zero.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:26 -0800
Message-ID: <201112092008.pB9K8QM8027822@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38322 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1LIUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: youquan.song@intel.com, aarcange@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: set compound tail page _count to zero
has been removed from the -mm tree.  Its filename was
     thp-set-compound-tail-page-_count-to-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Youquan Song <youquan.song@intel.com>
Subject: thp: set compound tail page _count to zero

70b50f94f1644 ("mm: thp: tail page refcounting fix") keeps all
page_tail->_count zero at all times.  But the current kernel does not set
page_tail->_count to zero if a 1GB page is utilized.  So when an IOMMU 1GB
page is used at KVM, it wil result in a kernel oops because a tail page's
_count does not equal zero.

kernel BUG at include/linux/mm.h:386!
invalid opcode: 0000 [#1] SMP
Call Trace:
 [<ffffffff81072f7f>] gup_pud_range+0xb8/0x19d
 [<ffffffff8107312f>] get_user_pages_fast+0xcb/0x192
 [<ffffffff810bc450>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81006a24>] hva_to_pfn+0x119/0x2f2
 [<ffffffff81006c29>] gfn_to_pfn_memslot+0x2c/0x2e
 [<ffffffff8100b909>] kvm_iommu_map_pages+0xfd/0x1c1
 [<ffffffff8100ba49>] kvm_iommu_map_memslots+0x7c/0xbd
 [<ffffffff8100b9cd>] ? kvm_iommu_map_pages+0x1c1/0x1c1
 [<ffffffff8100bb34>] kvm_iommu_map_guest+0xaa/0xbf
 [<ffffffff8100aeb0>] kvm_vm_ioctl_assigned_device+0x2ef/0xa47
 [<ffffffff8100ac6d>] ? kvm_vm_ioctl_assigned_device+0xac/0xa47
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff810b0c02>] ? sched_clock_cpu+0x45/0xd4
 [<ffffffff810bc450>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810b0cd2>] ? local_clock+0x41/0x5a
 [<ffffffff810bc8a1>] ? lock_release_holdtime+0x2c/0x129
 [<ffffffff8115762d>] ? cmpxchg_double_slab+0xd0/0x12b
 [<ffffffff81248f47>] ? avc_has_perm_noaudit+0x388/0x399
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81007dcb>] kvm_vm_ioctl+0x36c/0x3a2
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81174b10>] do_vfs_ioctl+0x49e/0x4e4
 [<ffffffff81174bb0>] sys_ioctl+0x5a/0x7c
 [<ffffffff81500e02>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffff81072d13>] gup_huge_pud+0xf2/0x159

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |    1 +
 mm/page_alloc.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~thp-set-compound-tail-page-_count-to-zero mm/hugetlb.c
--- a/mm/hugetlb.c~thp-set-compound-tail-page-_count-to-zero
+++ a/mm/hugetlb.c
@@ -576,6 +576,7 @@ static void prep_compound_gigantic_page(
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		__SetPageTail(p);
+		set_page_count(p, 0);
 		p->first_page = page;
 	}
 }
diff -puN mm/page_alloc.c~thp-set-compound-tail-page-_count-to-zero mm/page_alloc.c
--- a/mm/page_alloc.c~thp-set-compound-tail-page-_count-to-zero
+++ a/mm/page_alloc.c
@@ -356,8 +356,8 @@ void prep_compound_page(struct page *pag
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
