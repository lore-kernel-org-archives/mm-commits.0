From: akpm@linux-foundation.org
Subject: [failures]
 mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
 removed from -mm tree
Date: Wed, 20 May 2015 12:44:58 -0700
Message-ID: <555ce43a.vfr4PS+/5c/2V0bd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbETTo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 15:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix

fix up pmdp_collapse_flush defining

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc64.h |    2 +-
 include/asm-generic/pgtable.h            |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -576,9 +576,9 @@ static inline void pmdp_set_wrprotect(st
 extern void pmdp_splitting_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
 
-#define pmdp_collapse_flush pmdp_collapse_flush
 extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
+#define pmdp_collapse_flush pmdp_collapse_flush
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
diff -puN include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix
+++ a/include/asm-generic/pgtable.h
@@ -197,6 +197,7 @@ static inline pmd_t pmdp_collapse_flush(
 {
 	return pmdp_clear_flush(vma, address, pmdp);
 }
+#define pmdp_collapse_flush pmdp_collapse_flush
 #else
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 					unsigned long address,
@@ -205,6 +206,7 @@ static inline pmd_t pmdp_collapse_flush(
 	BUILD_BUG();
 	return __pmd(0);
 }
+#define pmdp_collapse_flush pmdp_collapse_flush
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

