From: akpm@linux-foundation.org
Subject: - remove-final-fastcall-users-fix.patch removed from -mm tree
Date: Wed, 13 Feb 2008 14:25:39 -0800
Message-ID: <200802132234.m1DMYdOm017181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098AbYBMWer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 17:34:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: Remove references to FASTCALL/fastcall
has been removed from the -mm tree.  Its filename was
     remove-final-fastcall-users-fix.patch

This patch was dropped because it was folded into remove-final-fastcall-users.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: Remove references to FASTCALL/fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>

An example function prototype and description of options that
modify how arguments are passed had references to fastcall.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/NMI-RCU.txt |    2 +-
 Documentation/kprobes.txt     |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN Documentation/RCU/NMI-RCU.txt~remove-final-fastcall-users-fix Documentation/RCU/NMI-RCU.txt
--- a/Documentation/RCU/NMI-RCU.txt~remove-final-fastcall-users-fix
+++ a/Documentation/RCU/NMI-RCU.txt
@@ -25,7 +25,7 @@ the NMI handler to take the default mach
 This nmi_callback variable is a global function pointer to the current
 NMI handler.
 
-	fastcall void do_nmi(struct pt_regs * regs, long error_code)
+	void do_nmi(struct pt_regs * regs, long error_code)
 	{
 		int cpu;
 
diff -puN Documentation/kprobes.txt~remove-final-fastcall-users-fix Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~remove-final-fastcall-users-fix
+++ a/Documentation/kprobes.txt
@@ -92,9 +92,8 @@ handler has run.  Up to MAX_STACK_SIZE b
 64 bytes on i386.
 
 Note that the probed function's args may be passed on the stack
-or in registers (e.g., for x86_64 or for an i386 fastcall function).
-The jprobe will work in either case, so long as the handler's
-prototype matches that of the probed function.
+or in registers.  The jprobe will work in either case, so long as the
+handler's prototype matches that of the probed function.
 
 1.3 Return Probes
 
@@ -270,9 +269,9 @@ Kprobes runs the handler whose address i
 The handler should have the same arg list and return type as the probed
 function; and just before it returns, it must call jprobe_return().
 (The handler never actually returns, since jprobe_return() returns
-control to Kprobes.)  If the probed function is declared asmlinkage,
-fastcall, or anything else that affects how args are passed, the
-handler's declaration must match.
+control to Kprobes.)  If the probed function is declared asmlinkage
+or anything else that affects how args are passed, the handler's
+declaration must match.
 
 register_jprobe() returns 0 on success, or a negative errno otherwise.
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
remove-final-fastcall-users-fix.patch
final-removal-of-fastcall-fastcall.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
