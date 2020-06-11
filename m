From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug_vm_pgtable-fix-kernel-crash-by-checking-for-thp-support.patch
 removed from -mm tree
Date: Thu, 11 Jun 2020 15:23:01 -0700
Message-ID: <20200611222301.Z8FVMmd2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 18:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: fix kernel crash by checking for THP support
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-fix-kernel-crash-by-checking-for-thp-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable: fix kernel crash by checking for THP support

Architectures can have CONFIG_TRANSPARENT_HUGEPAGE enabled but no THP
support enabled based on platforms.  For ex: with 4K PAGE_SIZE ppc64
supports THP only with radix translation.

This results in below crash when running with hash translation and 4K
PAGE_SIZE.

kernel BUG at arch/powerpc/include/asm/book3s/64/hash-4k.h:140!
cpu 0x61: Vector: 700 (Program Check) at [c000000ff948f860]
    pc: c0000000018810f8: debug_vm_pgtable+0x480/0x8b0
    lr: c0000000018810ec: debug_vm_pgtable+0x474/0x8b0
...
[c000000ff948faf0] c000000001880fec debug_vm_pgtable+0x374/0x8b0 (unreliable)
[c000000ff948fbf0] c000000000011648 do_one_initcall+0x98/0x4f0
[c000000ff948fcd0] c000000001843928 kernel_init_freeable+0x330/0x3fc
[c000000ff948fdb0] c0000000000122ac kernel_init+0x24/0x148
[c000000ff948fe20] c00000000000cc44 ret_from_kernel_thread+0x5c/0x78

Check for THP support correctly

Link: http://lkml.kernel.org/r/20200608125252.407659-1-aneesh.kumar@linux.ibm.com
Fixes: 399145f9eb6c ("mm/debug: add tests validating architecture page table helpers")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-fix-kernel-crash-by-checking-for-thp-support
+++ a/mm/debug_vm_pgtable.c
@@ -60,6 +60,9 @@ static void __init pmd_basic_tests(unsig
 {
 	pmd_t pmd = pfn_pmd(pfn, prot);
 
+	if (!has_transparent_hugepage())
+		return;
+
 	WARN_ON(!pmd_same(pmd, pmd));
 	WARN_ON(!pmd_young(pmd_mkyoung(pmd_mkold(pmd))));
 	WARN_ON(!pmd_dirty(pmd_mkdirty(pmd_mkclean(pmd))));
@@ -79,6 +82,9 @@ static void __init pud_basic_tests(unsig
 {
 	pud_t pud = pfn_pud(pfn, prot);
 
+	if (!has_transparent_hugepage())
+		return;
+
 	WARN_ON(!pud_same(pud, pud));
 	WARN_ON(!pud_young(pud_mkyoung(pud_mkold(pud))));
 	WARN_ON(!pud_write(pud_mkwrite(pud_wrprotect(pud))));
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are
