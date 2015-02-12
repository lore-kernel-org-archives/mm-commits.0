From: akpm@linux-foundation.org
Subject: [merged]
 mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:26 -0800
Message-ID: <54dd00f6.TCwoGYbrA7Xp9dnc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbBLTh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, asm-generic: define PUD_SHIFT in <asm-generic/4level-fixup.h>
has been removed from the -mm tree.  Its filename was
     mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, asm-generic: define PUD_SHIFT in <asm-generic/4level-fixup.h>

If an architecure uses <asm-generic/4level-fixup.h>, build fails if we
try to use PUD_SHIFT in generic code:

   In file included from arch/microblaze/include/asm/bug.h:1:0,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from include/asm-generic/preempt.h:4,
                    from arch/microblaze/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from mm/mmap.c:12:
   mm/mmap.c: In function 'exit_mmap':
>> mm/mmap.c:2858:46: error: 'PUD_SHIFT' undeclared (first use in this function)
       round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
                                                 ^
   include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^
   mm/mmap.c:2858:46: note: each undeclared identifier is reported only once for each function it appears in
       round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
                                                 ^
   include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^
As with <asm-generic/pgtable-nopud.h>, let's define PUD_SHIFT to
PGDIR_SHIFT.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/4level-fixup.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/4level-fixup.h~mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph include/asm-generic/4level-fixup.h
--- a/include/asm-generic/4level-fixup.h~mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph
+++ a/include/asm-generic/4level-fixup.h
@@ -4,6 +4,7 @@
 #define __ARCH_HAS_4LEVEL_HACK
 #define __PAGETABLE_PUD_FOLDED
 
+#define PUD_SHIFT			PGDIR_SHIFT
 #define PUD_SIZE			PGDIR_SIZE
 #define PUD_MASK			PGDIR_MASK
 #define PTRS_PER_PUD			1
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

