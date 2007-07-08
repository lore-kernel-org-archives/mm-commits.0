From: akpm@linux-foundation.org
Subject: - i386-fix-regression-endless-loop-in-ptrace-singlestep.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:11 -0700
Message-ID: <200707080811.l688BB3R014747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbXGHILe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, 76306.1226@compuserve.com, ak@suse.de, jeremy@goop.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     i386: fix regression, endless loop in ptrace singlestep over an int80
has been removed from the -mm tree.  Its filename was
     i386-fix-regression-endless-loop-in-ptrace-singlestep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix regression, endless loop in ptrace singlestep over an int80
From: Jason Wessel <jason.wessel@windriver.com>

The commit 635cf99a80f4ebee59d70eb64bb85ce829e4591f introduced a
regression.  Executing a ptrace single step after certain int80
accesses will infinitely loop and never advance the PC.

The TIF_SINGLESTEP check should be done on the return from the syscall
and not before it.

I loops on each single step on the pop right after the int80 which writes out
to the console.  At that point you can issue as many single steps as you want
and it will not advance any further.


The test case is below:

/* Test whether singlestep through an int80 syscall works.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <asm/user.h>
#include <string.h>

static int child, status;
static struct user_regs_struct regs;

static void do_child()
{
	char str[80] = "child: int80 test\n";

	ptrace(PTRACE_TRACEME, 0, 0, 0);
	kill(getpid(), SIGUSR1);
	write(fileno(stdout),str,strlen(str));
	asm ("int $0x80" : : "a" (20)); /* getpid */
}

static void do_parent()
{
	unsigned long eip, expected = 0;
again:
	waitpid(child, &status, 0);
	if (WIFEXITED(status) || WIFSIGNALED(status))
		return;

	if (WIFSTOPPED(status)) {
		ptrace(PTRACE_GETREGS, child, 0, &regs);
		eip = regs.eip;
		if (expected)
			fprintf(stderr, "child stop @ %08lx, expected %08lx %s\n",
					eip, expected,
					eip == expected ? "" : " <== ERROR");

		if (*(unsigned short *)eip == 0x80cd) {
			fprintf(stderr, "int 0x80 at %08x\n", (unsigned int)eip);
			expected = eip + 2;
		} else
			expected = 0;

		ptrace(PTRACE_SINGLESTEP, child, NULL, NULL);
	}
	goto again;
}

int main(int argc, char * const argv[])
{
	child = fork();
	if (child)
		do_parent();
	else
		do_child();
	return 0;
}

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: <stable@kernel.org>
Cc: Chuck Ebbert <76306.1226@compuserve.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/entry.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/entry.S~i386-fix-regression-endless-loop-in-ptrace-singlestep arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~i386-fix-regression-endless-loop-in-ptrace-singlestep
+++ a/arch/i386/kernel/entry.S
@@ -367,10 +367,6 @@ ENTRY(system_call)
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
-	testl $TF_MASK,PT_EFLAGS(%esp)
-	jz no_singlestep
-	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
-no_singlestep:
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
@@ -385,6 +381,10 @@ syscall_exit:
 					# setting need_resched or sigpending
 					# between sampling and the iret
 	TRACE_IRQS_OFF
+	testl $TF_MASK,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
+	jz no_singlestep
+	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
+no_singlestep:
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx	# current->work
 	jne syscall_exit_work
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

origin.patch
git-kgdb.patch
kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
kgdb-section-fix.patch
kgdb_skipexception-warning-fix.patch
kgdb-ia64-fixes.patch
kgdb-bust-on-ia64.patch
