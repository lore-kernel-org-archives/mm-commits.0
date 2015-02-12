From: akpm@linux-foundation.org
Subject: [merged] sparc32-fix-broken-set_pte.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:29 -0800
Message-ID: <54dd00bd.iyvgV6JHD19sybxp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbbBLTga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, davem@davemloft.net, iamjoonsoo.kim@lge.com, linux@roeck-us.net, pmoore@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: fix broken set_pte()
has been removed from the -mm tree.  Its filename was
     sparc32-fix-broken-set_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sparc32: fix broken set_pte()

32-bit sparc uses swap instruction to implement set_pte().  It called
using GCC inline assembler.  But it misses the "memory" clobber to
indicate that pte value will be updated in memory.

As result GCC doesn't know that it cannot postpone pte pointer dereference
which occurs before set_pte() to post-set_pte() time.

It leads to real-world bugs -- [1]. In this situation we have code:

	ptent = ptep_modify_prot_start(mm, addr, pte);
	ptent = pte_modify(ptent, newprot);
	...
	ptep_modify_prot_commit(mm, addr, pte, ptent);

ptep_modify_prot_start() in sparc case is just 'pte' dereference plus
pte_clear().  pte_clear() calls broken set_pte().  GCC thinks it's valid
to dereference 'pte' again on pte_modify() and gets cleared pte. 
ptep_modify_prot_commit() puts 'pteent' with pfn==0 back to page table,
which eventually leads to the crash.

[1] http://lkml.kernel.org/r/54C06B19.8060305@roeck-us.net

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/pgtable_32.h~sparc32-fix-broken-set_pte arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~sparc32-fix-broken-set_pte
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -102,7 +102,8 @@ extern unsigned long empty_zero_page;
  */
 static inline unsigned long srmmu_swap(unsigned long *addr, unsigned long value)
 {
-	__asm__ __volatile__("swap [%2], %0" : "=&r" (value) : "0" (value), "r" (addr));
+	__asm__ __volatile__("swap [%2], %0" :
+			"=&r" (value) : "0" (value), "r" (addr) : "memory");
 	return value;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

