From: akpm@linux-foundation.org
Subject: + x86-fatal-kernel-faults-should-update-thread-struct.patch added to -mm tree
Date: Wed, 14 Feb 2007 12:52:31 -0800
Message-ID: <200702142052.l1EKqVFA008741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575AbXBNUwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 15:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, ak@suse.de, jbeulich@novell.com


The patch titled
     x86: fatal kernel faults should update thread struct
has been added to the -mm tree.  Its filename is
     x86-fatal-kernel-faults-should-update-thread-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fatal kernel faults should update thread struct
From: Jeff Dike <jdike@addtoit.com>

Fix a bug introduced in my earlier fault information pollution prevention
patch.  That patch assumed that no kernel fault information should ever be
put in thread.error_code and .trap_no.  It turns out that die() reads those
fields, so fatal kernel faults, as well as userspace faults, need those
fields set.  The case where they aren't set is kernelspace faults which are
fixed up.

Thanks to Jan Beulich for his review and spotting this bug.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c   |   11 +++++++++++
 arch/x86_64/kernel/traps.c |   14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/traps.c~x86-fatal-kernel-faults-should-update-thread-struct arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~x86-fatal-kernel-faults-should-update-thread-struct
+++ a/arch/i386/kernel/traps.c
@@ -611,6 +611,15 @@ fastcall void __kprobes do_general_prote
 	if (!user_mode(regs))
 		goto gp_in_kernel;
 
+	/*
+	 * We want error_code and trap_no set for userspace faults and
+	 * kernelspace faults which result in die(), but not
+	 * kernelspace faults which are fixed up.  die() gives the
+	 * process no chance to handle the signal and notice the
+	 * kernel fault information, so that won't result in polluting
+	 * the information about previously queued, but not yet
+	 * delivered, fault.
+	 */
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
 	force_sig(SIGSEGV, current);
@@ -623,6 +632,8 @@ gp_in_vm86:
 
 gp_in_kernel:
 	if (!fixup_exception(regs)) {
+		current->thread.error_code = error_code;
+		current->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
diff -puN arch/x86_64/kernel/traps.c~x86-fatal-kernel-faults-should-update-thread-struct arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~x86-fatal-kernel-faults-should-update-thread-struct
+++ a/arch/x86_64/kernel/traps.c
@@ -583,6 +583,15 @@ static void __kprobes do_trap(int trapnr
 	struct task_struct *tsk = current;
 
 	if (user_mode(regs)) {
+		/*
+		 * We want error_code and trap_no set for userspace faults
+		 * and kernelspace faults which result in die(), but
+		 * not kernelspace faults which are fixed up.  die()
+		 * gives the process no chance to handle the signal
+		 * and notice the kernel fault information, so that
+		 * won't result in polluting the information about
+		 * previously queued, but not yet delivered, fault.
+		 */
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
@@ -606,8 +615,11 @@ static void __kprobes do_trap(int trapnr
 		fixup = search_exception_tables(regs->rip);
 		if (fixup)
 			regs->rip = fixup->fixup;
-		else	
+		else {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86-fatal-kernel-faults-should-update-thread-struct.patch
uml-fix-prototypes.patch
