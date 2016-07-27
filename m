From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:12 -0700
Message-ID: <57990534.6BpEOpE8NlbWevID%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not pass mm_struct into handle_mm_fault
has been removed from the -mm tree.  Its filename was
     mm-do-not-pass-mm_struct-into-handle_mm_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do not pass mm_struct into handle_mm_fault

We always have vma->vm_mm around.

Link: http://lkml.kernel.org/r/1466021202-61880-8-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c         |    2 +-
 arch/arc/mm/fault.c           |    2 +-
 arch/arm/mm/fault.c           |    2 +-
 arch/arm64/mm/fault.c         |    2 +-
 arch/avr32/mm/fault.c         |    2 +-
 arch/cris/mm/fault.c          |    2 +-
 arch/frv/mm/fault.c           |    2 +-
 arch/hexagon/mm/vm_fault.c    |    2 +-
 arch/ia64/mm/fault.c          |    2 +-
 arch/m32r/mm/fault.c          |    2 +-
 arch/m68k/mm/fault.c          |    2 +-
 arch/metag/mm/fault.c         |    2 +-
 arch/microblaze/mm/fault.c    |    2 +-
 arch/mips/mm/fault.c          |    2 +-
 arch/mn10300/mm/fault.c       |    2 +-
 arch/nios2/mm/fault.c         |    2 +-
 arch/openrisc/mm/fault.c      |    2 +-
 arch/parisc/mm/fault.c        |    2 +-
 arch/powerpc/mm/copro_fault.c |    2 +-
 arch/powerpc/mm/fault.c       |    2 +-
 arch/s390/mm/fault.c          |    2 +-
 arch/score/mm/fault.c         |    2 +-
 arch/sh/mm/fault.c            |    2 +-
 arch/sparc/mm/fault_32.c      |    4 ++--
 arch/sparc/mm/fault_64.c      |    2 +-
 arch/tile/mm/fault.c          |    2 +-
 arch/um/kernel/trap.c         |    2 +-
 arch/unicore32/mm/fault.c     |    2 +-
 arch/x86/mm/fault.c           |    2 +-
 arch/xtensa/mm/fault.c        |    2 +-
 drivers/iommu/amd_iommu_v2.c  |    3 +--
 drivers/iommu/intel-svm.c     |    2 +-
 include/linux/mm.h            |    9 ++++-----
 mm/gup.c                      |    5 ++---
 mm/ksm.c                      |    5 ++---
 mm/memory.c                   |   13 +++++++------
 36 files changed, 48 insertions(+), 51 deletions(-)

diff -puN arch/alpha/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/alpha/mm/fault.c
@@ -147,7 +147,7 @@ retry:
 	/* If for any reason at all we couldn't handle the fault,
 	   make sure we exit gracefully rather than endlessly redo
 	   the fault.  */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/arc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/arc/mm/fault.c
--- a/arch/arc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/arc/mm/fault.c
@@ -137,7 +137,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	/* If Pagefault was interrupted by SIGKILL, exit page fault "early" */
 	if (unlikely(fatal_signal_pending(current))) {
diff -puN arch/arm/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/arm/mm/fault.c
@@ -243,7 +243,7 @@ good_area:
 		goto out;
 	}
 
-	return handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
+	return handle_mm_fault(vma, addr & PAGE_MASK, flags);
 
 check_stack:
 	/* Don't allow expansion below FIRST_USER_ADDRESS */
diff -puN arch/arm64/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/arm64/mm/fault.c
--- a/arch/arm64/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/arm64/mm/fault.c
@@ -233,7 +233,7 @@ good_area:
 		goto out;
 	}
 
-	return handle_mm_fault(mm, vma, addr & PAGE_MASK, mm_flags);
+	return handle_mm_fault(vma, addr & PAGE_MASK, mm_flags);
 
 check_stack:
 	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
diff -puN arch/avr32/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/avr32/mm/fault.c
@@ -134,7 +134,7 @@ good_area:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/cris/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/cris/mm/fault.c
--- a/arch/cris/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/cris/mm/fault.c
@@ -168,7 +168,7 @@ retry:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/frv/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/frv/mm/fault.c
--- a/arch/frv/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/frv/mm/fault.c
@@ -164,7 +164,7 @@ asmlinkage void do_page_fault(int datamm
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, ear0, flags);
+	fault = handle_mm_fault(vma, ear0, flags);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff -puN arch/hexagon/mm/vm_fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/hexagon/mm/vm_fault.c
--- a/arch/hexagon/mm/vm_fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/hexagon/mm/vm_fault.c
@@ -101,7 +101,7 @@ good_area:
 		break;
 	}
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/ia64/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/ia64/mm/fault.c
@@ -159,7 +159,7 @@ retry:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/m32r/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/m32r/mm/fault.c
@@ -196,7 +196,7 @@ good_area:
 	 */
 	addr = (address & PAGE_MASK);
 	set_thread_fault_code(error_code);
-	fault = handle_mm_fault(mm, vma, addr, flags);
+	fault = handle_mm_fault(vma, addr, flags);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff -puN arch/m68k/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/m68k/mm/fault.c
--- a/arch/m68k/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/m68k/mm/fault.c
@@ -136,7 +136,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 	pr_debug("handle_mm_fault returns %d\n", fault);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
diff -puN arch/metag/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/metag/mm/fault.c
--- a/arch/metag/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/metag/mm/fault.c
@@ -133,7 +133,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return 0;
diff -puN arch/microblaze/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/microblaze/mm/fault.c
--- a/arch/microblaze/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/microblaze/mm/fault.c
@@ -216,7 +216,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/mips/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/mips/mm/fault.c
@@ -153,7 +153,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/mn10300/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/mn10300/mm/fault.c
--- a/arch/mn10300/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/mn10300/mm/fault.c
@@ -254,7 +254,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/nios2/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/nios2/mm/fault.c
--- a/arch/nios2/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/nios2/mm/fault.c
@@ -131,7 +131,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/openrisc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/openrisc/mm/fault.c
--- a/arch/openrisc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/openrisc/mm/fault.c
@@ -163,7 +163,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/parisc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/parisc/mm/fault.c
--- a/arch/parisc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/parisc/mm/fault.c
@@ -239,7 +239,7 @@ good_area:
 	 * fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN arch/powerpc/mm/copro_fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/powerpc/mm/copro_fault.c
--- a/arch/powerpc/mm/copro_fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/powerpc/mm/copro_fault.c
@@ -75,7 +75,7 @@ int copro_handle_mm_fault(struct mm_stru
 	}
 
 	ret = 0;
-	*flt = handle_mm_fault(mm, vma, ea, is_write ? FAULT_FLAG_WRITE : 0);
+	*flt = handle_mm_fault(vma, ea, is_write ? FAULT_FLAG_WRITE : 0);
 	if (unlikely(*flt & VM_FAULT_ERROR)) {
 		if (*flt & VM_FAULT_OOM) {
 			ret = -ENOMEM;
diff -puN arch/powerpc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/powerpc/mm/fault.c
@@ -429,7 +429,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
 		if (fault & VM_FAULT_SIGSEGV)
 			goto bad_area;
diff -puN arch/s390/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/s390/mm/fault.c
@@ -456,7 +456,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 	/* No reason to continue if interrupted by SIGKILL. */
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
 		fault = VM_FAULT_SIGNAL;
diff -puN arch/score/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/score/mm/fault.c
--- a/arch/score/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/score/mm/fault.c
@@ -111,7 +111,7 @@ good_area:
 	* make sure we exit gracefully rather than endlessly redo
 	* the fault.
 	*/
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
diff -puN arch/sh/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/sh/mm/fault.c
@@ -487,7 +487,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if (unlikely(fault & (VM_FAULT_RETRY | VM_FAULT_ERROR)))
 		if (mm_fault_error(regs, error_code, address, fault))
diff -puN arch/sparc/mm/fault_32.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/sparc/mm/fault_32.c
--- a/arch/sparc/mm/fault_32.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/sparc/mm/fault_32.c
@@ -241,7 +241,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
@@ -411,7 +411,7 @@ good_area:
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
 			goto bad_area;
 	}
-	switch (handle_mm_fault(mm, vma, address, flags)) {
+	switch (handle_mm_fault(vma, address, flags)) {
 	case VM_FAULT_SIGBUS:
 	case VM_FAULT_OOM:
 		goto do_sigbus;
diff -puN arch/sparc/mm/fault_64.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/sparc/mm/fault_64.c
--- a/arch/sparc/mm/fault_64.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/sparc/mm/fault_64.c
@@ -436,7 +436,7 @@ good_area:
 			goto bad_area;
 	}
 
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		goto exit_exception;
diff -puN arch/tile/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/tile/mm/fault.c
--- a/arch/tile/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/tile/mm/fault.c
@@ -434,7 +434,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return 0;
diff -puN arch/um/kernel/trap.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/um/kernel/trap.c
@@ -73,7 +73,7 @@ good_area:
 	do {
 		int fault;
 
-		fault = handle_mm_fault(mm, vma, address, flags);
+		fault = handle_mm_fault(vma, address, flags);
 
 		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 			goto out_nosemaphore;
diff -puN arch/unicore32/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/unicore32/mm/fault.c
--- a/arch/unicore32/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/unicore32/mm/fault.c
@@ -194,7 +194,7 @@ good_area:
 	 * If for any reason at all we couldn't handle the fault, make
 	 * sure we exit gracefully rather than endlessly redo the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, addr & PAGE_MASK, flags);
+	fault = handle_mm_fault(vma, addr & PAGE_MASK, flags);
 	return fault;
 
 check_stack:
diff -puN arch/x86/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/x86/mm/fault.c
@@ -1353,7 +1353,7 @@ good_area:
 	 * the fault.  Since we never set FAULT_FLAG_RETRY_NOWAIT, if
 	 * we get VM_FAULT_RETRY back, the mmap_sem has been unlocked.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 	major |= fault & VM_FAULT_MAJOR;
 
 	/*
diff -puN arch/xtensa/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/arch/xtensa/mm/fault.c
@@ -110,7 +110,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return;
diff -puN drivers/iommu/amd_iommu_v2.c~mm-do-not-pass-mm_struct-into-handle_mm_fault drivers/iommu/amd_iommu_v2.c
--- a/drivers/iommu/amd_iommu_v2.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/drivers/iommu/amd_iommu_v2.c
@@ -538,8 +538,7 @@ static void do_fault(struct work_struct
 	if (access_error(vma, fault))
 		goto out;
 
-	ret = handle_mm_fault(mm, vma, address, flags);
-
+	ret = handle_mm_fault(vma, address, flags);
 out:
 	up_read(&mm->mmap_sem);
 
diff -puN drivers/iommu/intel-svm.c~mm-do-not-pass-mm_struct-into-handle_mm_fault drivers/iommu/intel-svm.c
--- a/drivers/iommu/intel-svm.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/drivers/iommu/intel-svm.c
@@ -583,7 +583,7 @@ static irqreturn_t prq_event_thread(int
 		if (access_error(vma, req))
 			goto invalid;
 
-		ret = handle_mm_fault(svm->mm, vma, address,
+		ret = handle_mm_fault(vma, address,
 				      req->wr_req ? FAULT_FLAG_WRITE : 0);
 		if (ret & VM_FAULT_ERROR)
 			goto invalid;
diff -puN include/linux/mm.h~mm-do-not-pass-mm_struct-into-handle_mm_fault include/linux/mm.h
--- a/include/linux/mm.h~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/include/linux/mm.h
@@ -1215,15 +1215,14 @@ int generic_error_remove_page(struct add
 int invalidate_inode_page(struct page *page);
 
 #ifdef CONFIG_MMU
-extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, unsigned int flags);
+extern int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
+		unsigned int flags);
 extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
 #else
-static inline int handle_mm_fault(struct mm_struct *mm,
-			struct vm_area_struct *vma, unsigned long address,
-			unsigned int flags)
+static inline int handle_mm_fault(struct vm_area_struct *vma,
+		unsigned long address, unsigned int flags)
 {
 	/* should never happen if there's no MMU */
 	BUG();
diff -puN mm/gup.c~mm-do-not-pass-mm_struct-into-handle_mm_fault mm/gup.c
--- a/mm/gup.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/mm/gup.c
@@ -352,7 +352,6 @@ unmap:
 static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
 		unsigned long address, unsigned int *flags, int *nonblocking)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned int fault_flags = 0;
 	int ret;
 
@@ -377,7 +376,7 @@ static int faultin_page(struct task_stru
 		fault_flags |= FAULT_FLAG_TRIED;
 	}
 
-	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	ret = handle_mm_fault(vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
 			return -ENOMEM;
@@ -692,7 +691,7 @@ retry:
 	if (!vma_permits_fault(vma, fault_flags))
 		return -EFAULT;
 
-	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	ret = handle_mm_fault(vma, address, fault_flags);
 	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
diff -puN mm/ksm.c~mm-do-not-pass-mm_struct-into-handle_mm_fault mm/ksm.c
--- a/mm/ksm.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/mm/ksm.c
@@ -376,9 +376,8 @@ static int break_ksm(struct vm_area_stru
 		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
-			ret = handle_mm_fault(vma->vm_mm, vma, addr,
-							FAULT_FLAG_WRITE |
-							FAULT_FLAG_REMOTE);
+			ret = handle_mm_fault(vma, addr,
+					FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE);
 		else
 			ret = VM_FAULT_WRITE;
 		put_page(page);
diff -puN mm/memory.c~mm-do-not-pass-mm_struct-into-handle_mm_fault mm/memory.c
--- a/mm/memory.c~mm-do-not-pass-mm_struct-into-handle_mm_fault
+++ a/mm/memory.c
@@ -3420,9 +3420,10 @@ unlock:
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-			     unsigned long address, unsigned int flags)
+static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
+		unsigned int flags)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -3509,15 +3510,15 @@ static int __handle_mm_fault(struct mm_s
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		    unsigned long address, unsigned int flags)
+int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
+		unsigned int flags)
 {
 	int ret;
 
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
-	mem_cgroup_count_vm_event(mm, PGFAULT);
+	mem_cgroup_count_vm_event(vma->vm_mm, PGFAULT);
 
 	/* do counter updates before entering really critical section. */
 	check_sync_rss_stat(current);
@@ -3529,7 +3530,7 @@ int handle_mm_fault(struct mm_struct *mm
 	if (flags & FAULT_FLAG_USER)
 		mem_cgroup_oom_enable();
 
-	ret = __handle_mm_fault(mm, vma, address, flags);
+	ret = __handle_mm_fault(vma, address, flags);
 
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_oom_disable();
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


