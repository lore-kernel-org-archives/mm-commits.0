From: akpm@linux-foundation.org
Subject: [merged] thp-add-compound-tail-page-_mapcount-when-mapped.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:19 -0800
Message-ID: <201112092008.pB9K8J4W014507@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38322 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1LIUI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: youquan.song@intel.com, aarcange@redhat.com, andi@firstfloor.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: add compound tail page _mapcount when mapped
has been removed from the -mm tree.  Its filename was
     thp-add-compound-tail-page-_mapcount-when-mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Youquan Song <youquan.song@intel.com>
Subject: thp: add compound tail page _mapcount when mapped

With the 3.2-rc kernel, the IOMMU 2M page in KVM works.  While I try to us
IOMMU 1GB page in KVM, I encounter a oops and 1GB page total fail to be
used.  The root cause is that 1GB page allocation calls gup_huge_pud()
while 2M page calls gup_huge_pmd.  If compound pages are used and the page
is tail page, gup_huge_pmd increase _mapcount to record tail page are
mapped while gup_huge_pud does not include this process.  So when the
mapped page is relesed, it will result in kernel oops because the page
does not mark mapped.

This patch add tail process for compound page in 1GB huge page which keeps
the same process as 2M page.

Reproduce like:
1. Add grub boot option: hugepagesz=1G hugepages=8
2. mount -t hugetlbfs -o pagesize=1G hugetlbfs /dev/hugepages
3.qemu-kvm -m 2048 -hda os-kvm.img -cpu kvm64 -smp 4 -mem-path /dev/hugepages
 -net none -device pci-assign,host=07:00.1

kernel BUG at mm/swap.c:114!
invalid opcode: 0000 [#1] SMP
Call Trace:
 [<ffffffff81127482>] put_page+0x15/0x37
 [<ffffffff810067c4>] kvm_release_pfn_clean+0x31/0x36
 [<ffffffff8100b69c>] kvm_iommu_put_pages+0x94/0xb1
 [<ffffffff8100b739>] kvm_iommu_unmap_memslots+0x80/0xb6
 [<ffffffff8100b6b9>] ? kvm_iommu_put_pages+0xb1/0xb1
 [<ffffffff81425cf3>] ? intel_iommu_attach_device+0x13b/0x144
 [<ffffffff8100bc03>] kvm_assign_device+0xba/0x117
 [<ffffffff8100aec2>] kvm_vm_ioctl_assigned_device+0x301/0xa47
 [<ffffffff8100ac6d>] ? kvm_vm_ioctl_assigned_device+0xac/0xa47
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff810b0be2>] ? sched_clock_cpu+0x45/0xd4
 [<ffffffff810bc430>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810b0cb2>] ? local_clock+0x41/0x5a
 [<ffffffff810bc881>] ? lock_release_holdtime+0x2c/0x129
 [<ffffffff8115760d>] ? cmpxchg_double_slab+0xd0/0x12b
 [<ffffffff81248f27>] ? avc_has_perm_noaudit+0x388/0x399
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81007dcb>] kvm_vm_ioctl+0x36c/0x3a2
 [<ffffffff8104f2a6>] ? native_sched_clock+0x32/0x6b
 [<ffffffff8104f2e8>] ? sched_clock+0x9/0xd
 [<ffffffff81174af0>] do_vfs_ioctl+0x49e/0x4e4
 [<ffffffff81174b90>] sys_ioctl+0x5a/0x7c
 [<ffffffff81500dc2>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffff811273d9>] put_compound_page+0xd4/0x168

Signed-off-by: Youquan Song <youquan.song@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/gup.c~thp-add-compound-tail-page-_mapcount-when-mapped arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~thp-add-compound-tail-page-_mapcount-when-mapped
+++ a/arch/x86/mm/gup.c
@@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t p
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
_

Patches currently in -mm which might be from youquan.song@intel.com are

origin.patch

