From: akpm@linux-foundation.org
Subject: + xtensa-mm-faultc-port-oom-changes-to-do_page_fault.patch added to -mm tree
Date: Tue, 26 Jun 2012 15:10:46 -0700
Message-ID: <20120626221046.A3857A0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49676 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2FZWKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 18:10:48 -0400
Received: by qabg24 with SMTP id g24so62994qab.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 15:10:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, chris@zankel.net


The patch titled
     Subject: xtensa/mm/fault.c: port OOM changes to do_page_fault
has been added to the -mm tree.  Its filename is
     xtensa-mm-faultc-port-oom-changes-to-do_page_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: xtensa/mm/fault.c: port OOM changes to do_page_fault

d065bd810b6de ("mm: retry page fault when blocking on disk transfer") and
37b23e0525d393d ("x86,mm: make pagefault killable")

The above commits introduced changes into the x86 pagefault handler for
making the page fault handler retryable as well as killable.

These changes reduce the mmap_sem hold time, which is crucial during OOM
killer invocation.

Port these changes to xtensa.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/fault.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN arch/xtensa/mm/fault.c~xtensa-mm-faultc-port-oom-changes-to-do_page_fault arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~xtensa-mm-faultc-port-oom-changes-to-do_page_fault
+++ a/arch/xtensa/mm/fault.c
@@ -44,6 +44,7 @@ void do_page_fault(struct pt_regs *regs)
 
 	int is_write, is_exec;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	info.si_code = SEGV_MAPERR;
 
@@ -71,6 +72,7 @@ void do_page_fault(struct pt_regs *regs)
 	       address, exccause, regs->pc, is_write? "w":"", is_exec? "x":"");
 #endif
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 
@@ -93,6 +95,7 @@ good_area:
 	if (is_write) {
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
+		flags |= FAULT_FLAG_WRITE;
 	} else if (is_exec) {
 		if (!(vma->vm_flags & VM_EXEC))
 			goto bad_area;
@@ -104,7 +107,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -112,10 +119,22 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		current->maj_flt++;
-	else
-		current->min_flt++;
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			current->maj_flt++;
+		else
+			current->min_flt++;
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+			 /* No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
+	}
 
 	up_read(&mm->mmap_sem);
 	return;
_
Subject: Subject: xtensa/mm/fault.c: port OOM changes to do_page_fault

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch
xtensa-mm-faultc-port-oom-changes-to-do_page_fault.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch

