From: akpm@linux-foundation.org
Subject: [merged] microblaze-define-__pagetable_pmd_folded.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:22 -0800
Message-ID: <54dd00f2.UmOxBeQP6jO13fbO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbbBLThX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: define __PAGETABLE_PMD_FOLDED
has been removed from the -mm tree.  Its filename was
     microblaze-define-__pagetable_pmd_folded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: microblaze: define __PAGETABLE_PMD_FOLDED

Microblaze uses custom implementation of PMD folding, but doesn't define
__PAGETABLE_PMD_FOLDED, which generic code expects to see.  Let's fix it.

Defining __PAGETABLE_PMD_FOLDED will drop out unused __pmd_alloc().  It
also fixes problems with recently-introduced pmd accounting.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/microblaze/include/asm/pgtable.h~microblaze-define-__pagetable_pmd_folded arch/microblaze/include/asm/pgtable.h
--- a/arch/microblaze/include/asm/pgtable.h~microblaze-define-__pagetable_pmd_folded
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -61,6 +61,8 @@ extern int mem_init_done;
 
 #include <asm-generic/4level-fixup.h>
 
+#define __PAGETABLE_PMD_FOLDED
+
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
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

