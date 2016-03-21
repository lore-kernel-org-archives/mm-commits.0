From: akpm@linux-foundation.org
Subject: [merged] mm-remove-vm_fault_minor.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:39:59 -0700
Message-ID: <56f03fff.m9JQlf2549Okocjb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbcCUT4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove VM_FAULT_MINOR
has been removed from the -mm tree.  Its filename was
     mm-remove-vm_fault_minor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: remove VM_FAULT_MINOR

The define has a comment from Nick Piggin from 2007:

/* For backwards compat. Remove me quickly. */

I guess 9 years should not be too hurried sense of 'quickly' even for
kernel measures.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c       |    2 +-
 arch/arm64/mm/fault.c     |    2 +-
 arch/unicore32/mm/fault.c |    2 +-
 arch/xtensa/mm/fault.c    |    2 +-
 include/linux/mm.h        |    2 --
 5 files changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/arm/mm/fault.c~mm-remove-vm_fault_minor arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~mm-remove-vm_fault_minor
+++ a/arch/arm/mm/fault.c
@@ -346,7 +346,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
diff -puN arch/arm64/mm/fault.c~mm-remove-vm_fault_minor arch/arm64/mm/fault.c
--- a/arch/arm64/mm/fault.c~mm-remove-vm_fault_minor
+++ a/arch/arm64/mm/fault.c
@@ -295,7 +295,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
 			      VM_FAULT_BADACCESS))))
diff -puN arch/unicore32/mm/fault.c~mm-remove-vm_fault_minor arch/unicore32/mm/fault.c
--- a/arch/unicore32/mm/fault.c~mm-remove-vm_fault_minor
+++ a/arch/unicore32/mm/fault.c
@@ -276,7 +276,7 @@ retry:
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Handle the "normal" case first - VM_FAULT_MAJOR / VM_FAULT_MINOR
+	 * Handle the "normal" case first - VM_FAULT_MAJOR
 	 */
 	if (likely(!(fault &
 	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
diff -puN arch/xtensa/mm/fault.c~mm-remove-vm_fault_minor arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~mm-remove-vm_fault_minor
+++ a/arch/xtensa/mm/fault.c
@@ -146,7 +146,7 @@ good_area:
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (flags & VM_FAULT_MAJOR)
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	else if (flags & VM_FAULT_MINOR)
+	else
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 
 	return;
diff -puN include/linux/mm.h~mm-remove-vm_fault_minor include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-vm_fault_minor
+++ a/include/linux/mm.h
@@ -1052,8 +1052,6 @@ static inline void clear_page_pfmemalloc
  * just gets major/minor fault counters bumped up.
  */
 
-#define VM_FAULT_MINOR	0 /* For backwards compat. Remove me quickly. */
