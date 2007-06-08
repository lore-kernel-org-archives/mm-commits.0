From: akpm@linux-foundation.org
Subject: - x86-enable-interrupts-in-user-path-of-page-fault.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:46 -0700
Message-ID: <200706081735.l58HZkF3006388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672AbXFHRo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: enable interrupts in user path of page fault
has been removed from the -mm tree.  Its filename was
     x86-enable-interrupts-in-user-path-of-page-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
rt-mutex-fix-stale-return-value.patch
rt-mutex-fix-chain-walk-early-wakeup-bug.patch
pi-futex-fix-exit-races-and-locking-problems.patch
futex-tidy-up-the-code.patch
