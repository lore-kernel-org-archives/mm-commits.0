From: akpm@linux-foundation.org
Subject: - uml-work-around-broken-host-ptrace_sysemu.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:36 -0700
Message-ID: <200806160603.m5G63aAN010609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYFPGDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: work around broken host PTRACE_SYSEMU
has been removed from the -mm tree.  Its filename was
     uml-work-around-broken-host-ptrace_sysemu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: work around broken host PTRACE_SYSEMU
From: Jeff Dike <jdike@addtoit.com>

Fedora broke PTRACE_SYSEMU again, and UML crashes as a result when it
doesn't need to.  This patch makes the PTRACE_SYSEMU check fail gracefully
and makes UML fall back to PTRACE_SYSCALL.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-work-around-broken-host-ptrace_sysemu arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-work-around-broken-host-ptrace_sysemu
+++ a/arch/um/os-Linux/start_up.c
@@ -121,8 +121,10 @@ static int stop_ptraced_child(int pid, i
 {
 	int status, n, ret = 0;
 
-	if (ptrace(PTRACE_CONT, pid, 0, 0) < 0)
-		fatal_perror("stop_ptraced_child : ptrace failed");
+	if (ptrace(PTRACE_CONT, pid, 0, 0) < 0) {
+		perror("stop_ptraced_child : ptrace failed");
+		return -1;
+	}
 	CATCH_EINTR(n = waitpid(pid, &status, 0));
 	if (!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
 		int exit_with = WEXITSTATUS(status);
@@ -212,7 +214,7 @@ static void __init check_sysemu(void)
 	if (n < 0)
 		fatal_perror("check_sysemu : wait failed");
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
-		fatal("check_sysemu : expected SIGTRAP, got status = %d",
+		fatal("check_sysemu : expected SIGTRAP, got status = %d\n",
 		      status);
 
 	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
@@ -254,9 +256,11 @@ static void __init check_sysemu(void)
 
 		if (WIFSTOPPED(status) &&
 		    (WSTOPSIG(status) == (SIGTRAP|0x80))) {
-			if (!count)
-				fatal("check_ptrace : SYSEMU_SINGLESTEP "
-				      "doesn't singlestep");
+			if (!count) {
+				non_fatal("check_ptrace : SYSEMU_SINGLESTEP "
+					  "doesn't singlestep");
+				goto fail;
+			}
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
 				   os_getpid());
 			if (n < 0)
@@ -266,9 +270,12 @@ static void __init check_sysemu(void)
 		}
 		else if (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
-		else
-			fatal("check_ptrace : expected SIGTRAP or "
-			      "(SIGTRAP | 0x80), got status = %d", status);
+		else {
+			non_fatal("check_ptrace : expected SIGTRAP or "
+				  "(SIGTRAP | 0x80), got status = %d\n",
+				  status);
+			goto fail;
+		}
 	}
 	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch

