From: akpm@linux-foundation.org
Subject: + i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch added to -mm tree
Date: Mon, 11 Jun 2007 10:54:03 -0700
Message-ID: <200706111754.l5BHs3cS025281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbXFKRyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 13:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, rientjes@google.com, zach@vmware.com


The patch titled
     i386 mm: use pte_update() in ptep_test_and_clear_dirty()
has been added to the -mm tree.  Its filename is
     i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 14 insertions(+), 12 deletions(-)

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

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
i386-mm-use-pte_update-in-ptep_test_and_clear_dirty.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
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
