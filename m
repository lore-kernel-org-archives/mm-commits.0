From: akpm@linux-foundation.org
Subject: - i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:04 -0700
Message-ID: <200706231927.l5NJR4j9022027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbXFWT1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, rientjes@google.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386 mm: use pte_update() in ptep_test_and_clear_dirty()
has been removed from the -mm tree.  Its filename was
     i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 mm: use pte_update() in ptep_test_and_clear_dirty()
From: Hugh Dickins <hugh@veritas.com>

It is not safe to use pte_update_defer() in ptep_test_and_clear_young():
its only user, /proc/<pid>/clear_refs, drops pte lock before flushing TLB.
Use the safe though less efficient pte_update() paravirtop in its place.
Likewise in ptep_test_and_clear_dirty(), though that has no current use.

These are macros (header file dependency stops them from becoming inline
functions), so be more liberal with the underscores and parentheses.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable.h |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN include/asm-i386/pgtable.h~i386-mm-use-pte_update-in-ptep_test_and_clear_dirty include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-mm-use-pte_update-in-ptep_test_and_clear_dirty
+++ a/include/asm-i386/pgtable.h
@@ -295,22 +295,24 @@ do {									\
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define ptep_test_and_clear_dirty(vma, addr, ptep) ({			\
-	int ret = 0;							\
-	if (pte_dirty(*ptep))						\
-		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low); \
-	if (ret)							\
-		pte_update_defer(vma->vm_mm, addr, ptep);		\
-	ret;								\
+	int __ret = 0;							\
+	if (pte_dirty(*(ptep)))						\
+		__ret = test_and_clear_bit(_PAGE_BIT_DIRTY,		\
+						&(ptep)->pte_low);	\
+	if (__ret)							\
+		pte_update((vma)->vm_mm, addr, ptep);			\
+	__ret;								\
 })
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define ptep_test_and_clear_young(vma, addr, ptep) ({			\
-	int ret = 0;							\
-	if (pte_young(*ptep))						\
-		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low); \
-	if (ret)							\
-		pte_update_defer(vma->vm_mm, addr, ptep);		\
-	ret;								\
+	int __ret = 0;							\
+	if (pte_young(*(ptep)))						\
+		__ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,		\
+						&(ptep)->pte_low);	\
+	if (__ret)							\
+		pte_update((vma)->vm_mm, addr, ptep);			\
+	__ret;								\
 })
 
 /*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
hugetlbfs-use-lib-parser-fix-docs.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch
