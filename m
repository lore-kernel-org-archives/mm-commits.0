Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D164DA0F
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473444; cv=none; b=W16hsnB4tT1I0v4bMYF84vcVEYzS5yO6+sM1f6vAj4OgSmEwYXiFyLSm61Ufufjn0m1gNJT1d6DGxMJeXJgsFKdgFw76oHXR3aEOaodCfml1mmoDJOCWpWYcsruBkO4UaHqn39DQUd2xWBbucaSaKyt+kC5kczyXqK2pQHBU8Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473444; c=relaxed/simple;
	bh=IRqCp7LqktIcIKvlGUdveGWMEg8WKubdI0bD3naQPk4=;
	h=Date:To:From:Subject:Message-Id; b=UhBkrR2/Y4IgHUBUT9tbfFvKcv90arvsNSzOSBFQyBJHhdQ/cDLZ2nhiTiQCNmtuvPLXvrDKhFuubVD85loxsx9RfIZ58L/UZK+9OWJ0O3JcF+Tjd/Vue/AOJ/diACMFt1CE9eXEKtyP4s0cclzD45ZeeOyg4Eaw1ZzaJQu/qWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irV2F2tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irV2F2tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE6BC116B1;
	Sat, 15 Jun 2024 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473444;
	bh=IRqCp7LqktIcIKvlGUdveGWMEg8WKubdI0bD3naQPk4=;
	h=Date:To:From:Subject:From;
	b=irV2F2tOjwWR67FUqS8AMHzWau3JSXk42VZL1IeD4G4a5K2xWuNOyHXLehEQTCbYF
	 XVbKBCjk897gH687bWPDcnqpuctVzaaJRXHbWH4ENzR/cZNMbR405EPBUxMS47wxVb
	 eddgeKNgUAf525E1QRZmfwFrnWk3MyEMWgVR0YB4=
Date: Sat, 15 Jun 2024 10:44:03 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,mgorman@techsingularity.net,liushixin2@huawei.com,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-possible-oob-in-numa_rebuild_large_mapping.patch removed from -mm tree
Message-Id: <20240615174404.0AE6BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix possible OOB in numa_rebuild_large_mapping()
has been removed from the -mm tree.  Its filename was
     mm-fix-possible-oob-in-numa_rebuild_large_mapping.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: fix possible OOB in numa_rebuild_large_mapping()
Date: Wed, 12 Jun 2024 20:28:22 +0800

The large folio is mapped with folio size(not greater PMD_SIZE) aligned
virtual address during the pagefault, ie, 'addr = ALIGN_DOWN(vmf->address,
nr_pages * PAGE_SIZE)' in do_anonymous_page().  But after the mremap(),
the virtual address only requires PAGE_SIZE alignment.  Also pte is moved
to new in move_page_tables(), then traversal of the new pte in the
numa_rebuild_large_mapping() could hit the following issue,

   Unable to handle kernel paging request at virtual address 00000a80c021a788
   Mem abort info:
     ESR = 0x0000000096000004
     EC = 0x25: DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 0, S1PTW = 0
     FSC = 0x04: level 0 translation fault
   Data abort info:
     ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
     CM = 0, WnR = 0, TnD = 0, TagAccess = 0
     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
   user pgtable: 4k pages, 48-bit VAs, pgdp=00002040341a6000
   [00000a80c021a788] pgd=0000000000000000, p4d=0000000000000000
   Internal error: Oops: 0000000096000004 [#1] SMP
   ...
   CPU: 76 PID: 15187 Comm: git Kdump: loaded Tainted: G        W          6.10.0-rc2+ #209
   Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 1.79 08/21/2021
   pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : numa_rebuild_large_mapping+0x338/0x638
   lr : numa_rebuild_large_mapping+0x320/0x638
   sp : ffff8000b41c3b00
   x29: ffff8000b41c3b30 x28: ffff8000812a0000 x27: 00000000000a8000
   x26: 00000000000000a8 x25: 0010000000000001 x24: ffff20401c7170f0
   x23: 0000ffff33a1e000 x22: 0000ffff33a76000 x21: ffff20400869eca0
   x20: 0000ffff33976000 x19: 00000000000000a8 x18: ffffffffffffffff
   x17: 0000000000000000 x16: 0000000000000020 x15: ffff8000b41c36a8
   x14: 0000000000000000 x13: 205d373831353154 x12: 5b5d333331363732
   x11: 000000000011ff78 x10: 000000000011ff10 x9 : ffff800080273f30
   x8 : 000000320400869e x7 : c0000000ffffd87f x6 : 00000000001e6ba8
   x5 : ffff206f3fb5af88 x4 : 0000000000000000 x3 : 0000000000000000
   x2 : 0000000000000000 x1 : fffffdffc0000000 x0 : 00000a80c021a780
   Call trace:
    numa_rebuild_large_mapping+0x338/0x638
    do_numa_page+0x3e4/0x4e0
    handle_pte_fault+0x1bc/0x238
    __handle_mm_fault+0x20c/0x400
    handle_mm_fault+0xa8/0x288
    do_page_fault+0x124/0x498
    do_translation_fault+0x54/0x80
    do_mem_abort+0x4c/0xa8
    el0_da+0x40/0x110
    el0t_64_sync_handler+0xe4/0x158
    el0t_64_sync+0x188/0x190

Fix it by making the start and end not only within the vma range, but also
within the page table range.

Link: https://lkml.kernel.org/r/20240612122822.4033433-1-wangkefeng.wang@huawei.com
Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-fix-possible-oob-in-numa_rebuild_large_mapping
+++ a/mm/memory.c
@@ -5100,10 +5100,16 @@ static void numa_rebuild_large_mapping(s
 				       bool ignore_writable, bool pte_write_upgrade)
 {
 	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
-	unsigned long start = max(vmf->address - nr * PAGE_SIZE, vma->vm_start);
-	unsigned long end = min(vmf->address + (folio_nr_pages(folio) - nr) * PAGE_SIZE, vma->vm_end);
-	pte_t *start_ptep = vmf->pte - (vmf->address - start) / PAGE_SIZE;
-	unsigned long addr;
+	unsigned long start, end, addr = vmf->address;
+	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
+	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
+	pte_t *start_ptep;
+
+	/* Stay within the VMA and within the page table. */
+	start = max3(addr_start, pt_start, vma->vm_start);
+	end = min3(addr_start + folio_size(folio), pt_start + PMD_SIZE,
+		   vma->vm_end);
+	start_ptep = vmf->pte - ((addr - start) >> PAGE_SHIFT);
 
 	/* Restore all PTEs' mapping of the large folio */
 	for (addr = start; addr != end; start_ptep++, addr += PAGE_SIZE) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

