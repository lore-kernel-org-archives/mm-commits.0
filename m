From: akpm@linux-foundation.org
Subject: - uml-dont-try-to-handle-signals-on-initial-process-stack.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:21 -0700
Message-ID: <200705080007.l4807LJq009275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967412AbXEHAHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: don't try to handle signals on initial process stack
has been removed from the -mm tree.  Its filename was
     uml-dont-try-to-handle-signals-on-initial-process-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: don't try to handle signals on initial process stack
From: Jeff Dike <jdike@addtoit.com>

Code running on the initial UML stack can't receive or process signals since
current must be valid when IRQs are handled, and there is no current for this
stack.

So, instead of using UML_LONGJMP and UML_SETJMP, which are careful to save and
restore signal state, and, as a side-effect, handle any deferred signals,
start_idle_thread must use the bare equivalents, which don't do anything with
signals.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-dont-try-to-handle-signals-on-initial-process-stack arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-dont-try-to-handle-signals-on-initial-process-stack
+++ a/arch/um/os-Linux/skas/process.c
@@ -494,7 +494,15 @@ int start_idle_thread(void *stack, jmp_b
 		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGALRM,
 		    SIGVTALRM, -1);
 
-	n = UML_SETJMP(&initial_jmpbuf);
+	/*
+	 * Can't use UML_SETJMP or UML_LONGJMP here because they save
+	 * and restore signals, with the possible side-effect of
+	 * trying to handle any signals which came when they were
+	 * blocked, which can't be done on this stack.
+	 * Signals must be blocked when jumping back here and restored
+	 * after returning to the jumper.
+	 */
+	n = setjmp(initial_jmpbuf);
 	switch(n){
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
@@ -504,7 +512,7 @@ int start_idle_thread(void *stack, jmp_b
 		break;
 	case INIT_JMP_CALLBACK:
 		(*cb_proc)(cb_arg);
-		UML_LONGJMP(cb_back, 1);
+		longjmp(*cb_back, 1);
 		break;
 	case INIT_JMP_HALT:
 		kmalloc_ok = 0;
@@ -515,7 +523,7 @@ int start_idle_thread(void *stack, jmp_b
 	default:
 		panic("Bad sigsetjmp return in start_idle_thread - %d\n", n);
 	}
-	UML_LONGJMP(switch_buf, 1);
+	longjmp(*switch_buf, 1);
 }
 
 void initial_thread_cb_skas(void (*proc)(void *), void *arg)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
