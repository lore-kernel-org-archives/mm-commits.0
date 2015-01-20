From: akpm@linux-foundation.org
Subject: +
 mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch added to -mm tree
Date: Tue, 20 Jan 2015 14:02:39 -0800
Message-ID: <54bed07f.SOK0OOijhh88NHRJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbATWCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:02:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, asm-generic: define PUD_SHIFT in <asm-generic/4level-fixup.h>
has been added to the -mm tree.  Its filename is
     mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers-fix.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
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
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
mm-account-pmd-page-tables-to-the-process.patch
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

