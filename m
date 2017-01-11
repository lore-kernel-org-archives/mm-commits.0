From: akpm@linux-foundation.org
Subject: [merged] mm-pmd-dirty-emulation-in-page-fault-handler.patch
 removed from -mm tree
Date: Wed, 11 Jan 2017 14:28:12 -0800
Message-ID: <5876b17c.q2otbUNqj+fb2oiS%akpm__3962.16309532083$1484173769$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdAKW2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, catalin.marinas@arm.com, je@fb.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, schwab@suse.de, stable@vger.kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pmd dirty emulation in page fault handler
has been removed from the -mm tree.  Its filename was
     mm-pmd-dirty-emulation-in-page-fault-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: pmd dirty emulation in page fault handler

Andreas reported [1] made a test in jemalloc hang in THP mode in arm64. 
http://lkml.kernel.org/r/mvmmvfy37g1.fsf@hawking.suse.de

The problem is currently page fault handler doesn't supports dirty bit
emulation of pmd for non-HW dirty-bit architecture so that application
stucks until VM marked the pmd dirty.

How the emulation work depends on the architecture.  In case of arm64,
when it set up pte firstly, it sets pte PTE_RDONLY to get a chance to mark
the pte dirty via triggering page fault when store access happens.  Once
the page fault occurs, VM marks the pmd dirty and arch code for setting
pmd will clear PTE_RDONLY for application to proceed.

IOW, if VM doesn't mark the pmd dirty, application hangs forever by
repeated fault(i.e., store op but the pmd is PTE_RDONLY).

This patch enables pmd dirty-bit emulation for those architectures.

[1] b8d3c4c3009d, mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called

Fixes: b8d3c4c3009d ("mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called")
Link: http://lkml.kernel.org/r/1482506098-6149-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Andreas Schwab <schwab@suse.de>
Tested-by: Andreas Schwab <schwab@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jason Evans <je@fb.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org> [4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-pmd-dirty-emulation-in-page-fault-handler mm/huge_memory.c
--- a/mm/huge_memory.c~mm-pmd-dirty-emulation-in-page-fault-handler
+++ a/mm/huge_memory.c
@@ -883,15 +883,17 @@ void huge_pmd_set_accessed(struct vm_fau
 {
 	pmd_t entry;
 	unsigned long haddr;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
 		goto unlock;
 
 	entry = pmd_mkyoung(orig_pmd);
+	if (write)
+		entry = pmd_mkdirty(entry);
 	haddr = vmf->address & HPAGE_PMD_MASK;
-	if (pmdp_set_access_flags(vmf->vma, haddr, vmf->pmd, entry,
-				vmf->flags & FAULT_FLAG_WRITE))
+	if (pmdp_set_access_flags(vmf->vma, haddr, vmf->pmd, entry, write))
 		update_mmu_cache_pmd(vmf->vma, vmf->address, vmf->pmd);
 
 unlock:
_

Patches currently in -mm which might be from minchan@kernel.org are


