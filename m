From: akpm@linux-foundation.org
Subject: + avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:00:37 -0700
Message-ID: <20120613210038.57F38A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45837 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2FMVAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:00:40 -0400
Received: by vcbfl13 with SMTP id fl13so93311vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:00:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mohdfarisq2010@gmail.com


The patch titled
     Subject: avr32/mm/fault.c: port OOM changes to do_page_fault
has been added to the -mm tree.  Its filename is
     avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch

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
Subject: avr32/mm/fault.c: port OOM changes to do_page_fault

Commits d065bd810b6de ("mm: retry page fault when blocking on disk
transfer") and 37b23e0525d3 ("x86,mm: make pagefault killable") introduced
changes into the x86 pagefault handler for making the page fault handler
retryable as well as killable.

These changes reduce the mmap_sem hold time, which is crucial during OOM
killer invocation.

Port these changes to AVR32.

Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/fault.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff -puN arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~avr32-mm-faultc-port-oom-changes-to-do_page_fault
+++ a/arch/avr32/mm/fault.c
@@ -61,10 +61,10 @@ asmlinkage void do_page_fault(unsigned l
 	const struct exception_table_entry *fixup;
 	unsigned long address;
 	unsigned long page;
-	int writeaccess;
 	long signr;
 	int code;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	if (notify_page_fault(regs, ecr))
 		return;
@@ -86,6 +86,7 @@ asmlinkage void do_page_fault(unsigned l
 
 	local_irq_enable();
 
+retry:
 	down_read(&mm->mmap_sem);
 
 	vma = find_vma(mm, address);
@@ -104,7 +105,6 @@ asmlinkage void do_page_fault(unsigned l
 	 */
 good_area:
 	code = SEGV_ACCERR;
-	writeaccess = 0;
 
 	switch (ecr) {
 	case ECR_PROTECTION_X:
@@ -121,7 +121,7 @@ good_area:
 	case ECR_TLB_MISS_W:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
-		writeaccess = 1;
+		flags |= FAULT_FLAG_WRITE;
 		break;
 	default:
 		panic("Unhandled case %lu in do_page_fault!", ecr);
@@ -132,7 +132,11 @@ good_area:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(mm, vma, address, writeaccess ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -140,10 +144,23 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
-	else
-		tsk->min_flt++;
+
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
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
Subject: Subject: avr32/mm/fault.c: port OOM changes to do_page_fault

Patches currently in -mm which might be from consul.kautuk@gmail.com are

avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch

