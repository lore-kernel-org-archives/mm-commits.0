From: akpm@linux-foundation.org
Subject: - mm-fault-feedback-2-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:50:13 -0700
Message-ID: <200707190550.l6J5oEAm016425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbXGSFuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-fault-feedback-2-fix
has been removed from the -mm tree.  Its filename was
     mm-fault-feedback-2-fix.patch

This patch was dropped because it was folded into mm-fault-feedback-2.patch

------------------------------------------------------
Subject: mm-fault-feedback-2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c      |    4 ++--
 arch/s390/lib/uaccess_pt.c |    2 +-
 arch/sparc/mm/fault.c      |    1 +
 arch/sparc64/mm/fault.c    |    4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/alpha/mm/fault.c~mm-fault-feedback-2-fix arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~mm-fault-feedback-2-fix
+++ a/arch/alpha/mm/fault.c
@@ -156,9 +156,9 @@ do_page_fault(unsigned long address, uns
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
+		current->maj_flt++;
 	else
-		tsk->min_flt++;
+		current->min_flt++;
 	return;
 
 	/* Something tried to access memory that isn't in our memory map.
diff -puN arch/s390/lib/uaccess_pt.c~mm-fault-feedback-2-fix arch/s390/lib/uaccess_pt.c
--- a/arch/s390/lib/uaccess_pt.c~mm-fault-feedback-2-fix
+++ a/arch/s390/lib/uaccess_pt.c
@@ -50,7 +50,7 @@ survive:
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
 		else if (fault & VM_FAULT_SIGBUS)
-			goto do_sigbus;
+			goto out_sigbus;
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
diff -puN arch/sparc/mm/fault.c~mm-fault-feedback-2-fix arch/sparc/mm/fault.c
--- a/arch/sparc/mm/fault.c~mm-fault-feedback-2-fix
+++ a/arch/sparc/mm/fault.c
@@ -226,6 +226,7 @@ asmlinkage void do_sparc_fault(struct pt
 	unsigned long g2;
 	siginfo_t info;
 	int from_user = !(regs->psr & PSR_PS);
+	int fault;
 
 	if(text_fault)
 		address = regs->pc;
diff -puN arch/sparc64/mm/fault.c~mm-fault-feedback-2-fix arch/sparc64/mm/fault.c
--- a/arch/sparc64/mm/fault.c~mm-fault-feedback-2-fix
+++ a/arch/sparc64/mm/fault.c
@@ -424,9 +424,9 @@ good_area:
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
+		current->maj_flt++;
 	else
-		tsk->min_flt++;
+		current->min_flt++;
 
 	up_read(&mm->mmap_sem);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
mm-fault-feedback-2-fix.patch
mm-fault-feedback-2-fix-2.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
