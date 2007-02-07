From: akpm@linux-foundation.org
Subject: + add-nopfn_refault-result-from-vm_ops-nopfn.patch added to -mm tree
Date: Wed, 07 Feb 2007 14:21:26 -0800
Message-ID: <200702072221.l17MLQTm029059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40861 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030662AbXBGWVi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 17:21:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, arnd.bergmann@de.ibm.com, hch@lst.de, hugh@veritas.com


The patch titled
     Add NOPFN_REFAULT result from vm_ops->nopfn()
has been added to the -mm tree.  Its filename is
     add-nopfn_refault-result-from-vm_ops-nopfn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add NOPFN_REFAULT result from vm_ops->nopfn()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Add a NOPFN_REFAULT return code for vm_ops->nopfn() equivalent to
NOPAGE_REFAULT for vmops->nopage() indicating that the handler requests a
re-execution of the faulting instruction

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/memory.c        |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~add-nopfn_refault-result-from-vm_ops-nopfn include/linux/mm.h
--- a/include/linux/mm.h~add-nopfn_refault-result-from-vm_ops-nopfn
+++ a/include/linux/mm.h
@@ -638,6 +638,7 @@ static inline int page_mapped(struct pag
  */
 #define NOPFN_SIGBUS	((unsigned long) -1)
 #define NOPFN_OOM	((unsigned long) -2)
+#define NOPFN_REFAULT	((unsigned long) -3)
 
 /*
  * Different kinds of faults, as returned by handle_mm_fault().
diff -puN mm/memory.c~add-nopfn_refault-result-from-vm_ops-nopfn mm/memory.c
--- a/mm/memory.c~add-nopfn_refault-result-from-vm_ops-nopfn
+++ a/mm/memory.c
@@ -2357,10 +2357,12 @@ static noinline int do_no_pfn(struct mm_
 	BUG_ON(is_cow_mapping(vma->vm_flags));
 
 	pfn = vma->vm_ops->nopfn(vma, address & PAGE_MASK);
-	if (pfn == NOPFN_OOM)
+	if (unlikely(pfn == NOPFN_OOM))
 		return VM_FAULT_OOM;
-	if (pfn == NOPFN_SIGBUS)
+	else if (unlikely(pfn == NOPFN_SIGBUS))
 		return VM_FAULT_SIGBUS;
+	else if (unlikely(pfn == NOPFN_REFAULT))
+		return VM_FAULT_MINOR;
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

enable-mouse-button-23-emulation-for-x86-macs.patch
x86-fix-vdso-mapping-for-aout-executables.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-powerpc.patch
fix-ppc64s-writing-to-struct-file_operations.patch
powerpc-rtas-msi-support.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
windfarm-dont-die-on-suspend-thread-signal.patch
driver-core-per-subsystem-multithreaded-probing.patch
powerpc-make-it-compile.patch
add-vm_insert_pfn.patch
add-nopfn_refault-result-from-vm_ops-nopfn.patch
mm-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
