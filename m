From: akpm@linux-foundation.org
Subject: + x86-enable-interrupts-in-user-path-of-page-fault.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:59:14 -0700
Message-ID: <200706080159.l581xEc7015578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764777AbXFHB70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, ak@suse.de, mingo@elte.hu


The patch titled
     x86: enable interrupts in user path of page fault
has been added to the -mm tree.  Its filename is
     x86-enable-interrupts-in-user-path-of-page-fault.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: enable interrupts in user path of page fault
From: Steven Rostedt <rostedt@goodmis.org>

This is a minor fix, but what is currently there is essentially wrong.  In
do_page_fault, if the faulting address from user code happens to be in
kernel address space (int *p = (int*)-1; p = 0xbed;) then the do_page_fault
handler will jump over the local_irq_enable with the

  goto bad_area_nosemaphore;

But the first line there sees this is user code and goes through the
process of sending a signal to send SIGSEGV to the user task.  This whole
time interrupts are disabled and the task can not be preempted by a higher
priority task.

This patch always enables interrupts in the user path of the
bad_area_nosemaphore.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c   |    5 +++++
 arch/x86_64/mm/fault.c |    6 ++++++
 2 files changed, 11 insertions(+)

diff -puN arch/i386/mm/fault.c~x86-enable-interrupts-in-user-path-of-page-fault arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~x86-enable-interrupts-in-user-path-of-page-fault
+++ a/arch/i386/mm/fault.c
@@ -458,6 +458,11 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & 4) {
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
 		/* 
 		 * Valid to do another page fault here because this one came 
 		 * from user space.
diff -puN arch/x86_64/mm/fault.c~x86-enable-interrupts-in-user-path-of-page-fault arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86-enable-interrupts-in-user-path-of-page-fault
+++ a/arch/x86_64/mm/fault.c
@@ -476,6 +476,12 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & PF_USER) {
+
+		/*
+		 * It's possible to have interrupts off here.
+		 */
+		local_irq_enable();
+
 		if (is_prefetch(regs, address, error_code))
 			return;
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

rt-mutex-fix-stale-return-value.patch
rt-mutex-fix-chain-walk-early-wakeup-bug.patch
pi-futex-fix-exit-races-and-locking-problems.patch
x86-enable-interrupts-in-user-path-of-page-fault.patch
futex-tidy-up-the-code.patch
