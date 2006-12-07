From: akpm@osdl.org
Subject: - uml-size-register-files-correctly.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:11 -0800
Message-ID: <200612072300.kB7N0Bp0029616@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163709AbWLGXAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: size register files correctly
has been removed from the -mm tree.  Its filename was
     uml-size-register-files-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: size register files correctly
From: Jeff Dike <jdike@addtoit.com>

We were using the wrong symbol to size register files.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/include/sysdep-i386/ptrace.h   |    2 +-
 arch/um/include/sysdep-x86_64/ptrace.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-size-register-files-correctly arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-size-register-files-correctly
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -75,7 +75,7 @@ union uml_pt_regs {
 #endif
 #ifdef UML_CONFIG_MODE_SKAS
 	struct skas_regs {
-		unsigned long regs[HOST_FRAME_SIZE];
+		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
 		unsigned long xfp[HOST_XFP_SIZE];
                 struct faultinfo faultinfo;
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-size-register-files-correctly arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-size-register-files-correctly
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -108,7 +108,7 @@ union uml_pt_regs {
 		 * file size, while i386 uses FRAME_SIZE.  Therefore, we need
 		 * to use UM_FRAME_SIZE here instead of HOST_FRAME_SIZE.
 		 */
-		unsigned long regs[UM_FRAME_SIZE];
+		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
                 struct faultinfo faultinfo;
 		long syscall;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch
tty-switch-to-ktermios-uml-fix.patch

