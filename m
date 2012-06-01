From: akpm@linux-foundation.org
Subject: [merged] um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:45 -0700
Message-ID: <20120601193245.79204A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37055 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2FATcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:32:46 -0400
Received: by qabg24 with SMTP id g24so93176qab.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um/kernel/trap.c: port OOM changes to handle_page_fault()
has been removed from the -mm tree.  Its filename was
     um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: um/kernel/trap.c: port OOM changes to handle_page_fault()

Commit d065bd810b6deb6 ("mm: retry page fault when blocking on disk
transfer") and commit 37b23e0525 ("x86,mm: make pagefault killable")

The above commits introduced changes into the x86 pagefault handler
for making the page fault handler retryable as well as killable.

These changes reduce the mmap_sem hold time, which is crucial
during OOM killer invocation.

Port these changes to um.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN arch/um/kernel/trap.c~um-kernel-trapc-port-oom-changes-to-handle_page_fault arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~um-kernel-trapc-port-oom-changes-to-handle_page_fault
+++ a/arch/um/kernel/trap.c
@@ -30,6 +30,8 @@ int handle_page_fault(unsigned long addr
 	pmd_t *pmd;
 	pte_t *pte;
 	int err = -EFAULT;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				 (is_write ? FAULT_FLAG_WRITE : 0);
 
 	*code_out = SEGV_MAPERR;
 
@@ -40,6 +42,7 @@ int handle_page_fault(unsigned long addr
 	if (in_atomic())
 		goto out_nosemaphore;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -65,7 +68,11 @@ good_area:
 	do {
 		int fault;
 
-		fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
+		fault = handle_mm_fault(mm, vma, address, flags);
+
+		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+			goto out_nosemaphore;
+
 		if (unlikely(fault & VM_FAULT_ERROR)) {
 			if (fault & VM_FAULT_OOM) {
 				goto out_of_memory;
@@ -75,10 +82,17 @@ good_area:
 			}
 			BUG();
 		}
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
+		if (flags & FAULT_FLAG_ALLOW_RETRY) {
+			if (fault & VM_FAULT_MAJOR)
+				current->maj_flt++;
+			else
+				current->min_flt++;
+			if (fault & VM_FAULT_RETRY) {
+				flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+				goto retry;
+			}
+		}
 
 		pgd = pgd_offset(mm, address);
 		pud = pud_offset(pgd, address);
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

origin.patch

