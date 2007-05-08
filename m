From: akpm@linux-foundation.org
Subject: - uml-dump-registers-on-ptrace-or-wait-failure.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:59 -0700
Message-ID: <200705080006.l4806x37009242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967258AbXEHAHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: dump registers on ptrace or wait failure
has been removed from the -mm tree.  Its filename was
     uml-dump-registers-on-ptrace-or-wait-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: dump registers on ptrace or wait failure
From: Jeff Dike <jdike@addtoit.com>

Provide a register dump if handle_trap fails.  Abstract out ptrace_dump_regs
since it now has two callers.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |   37 ++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-dump-registers-on-ptrace-or-wait-failure arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-dump-registers-on-ptrace-or-wait-failure
+++ a/arch/um/os-Linux/skas/process.c
@@ -44,6 +44,22 @@ int is_skas_winch(int pid, int fd, void 
 	return(1);
 }
 
+static int ptrace_dump_regs(int pid)
+{
+        unsigned long regs[MAX_REG_NR];
+        int i;
+
+        if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+                return -errno;
+        else {
+                printk("Stub registers -\n");
+                for(i = 0; i < ARRAY_SIZE(regs); i++)
+                        printk("\t%d - %lx\n", i, regs[i]);
+        }
+
+        return 0;
+}
+
 void wait_stub_done(int pid, int sig, char * fname)
 {
 	int n, status, err;
@@ -67,18 +83,10 @@ void wait_stub_done(int pid, int sig, ch
 
 	if((n < 0) || !WIFSTOPPED(status) ||
 	   (WSTOPSIG(status) != SIGUSR1 && WSTOPSIG(status) != SIGTRAP)){
-		unsigned long regs[MAX_REG_NR];
-
-		if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+		err = ptrace_dump_regs(pid);
+		if(err)
 			printk("Failed to get registers from stub, "
-			       "errno = %d\n", errno);
-		else {
-			int i;
-
-			printk("Stub registers -\n");
-			for(i = 0; i < ARRAY_SIZE(regs); i++)
-				printk("\t%d - %lx\n", i, regs[i]);
-		}
+			       "errno = %d\n", -err);
 		panic("%s : failed to wait for SIGUSR1/SIGTRAP, "
 		      "pid = %d, n = %d, errno = %d, status = 0x%x\n",
 		      fname, pid, n, errno, status);
@@ -142,9 +150,14 @@ static void handle_trap(int pid, union u
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
 		if((err < 0) || !WIFSTOPPED(status) ||
-		   (WSTOPSIG(status) != SIGTRAP + 0x80))
+		   (WSTOPSIG(status) != SIGTRAP + 0x80)){
+                        err = ptrace_dump_regs(pid);
+                        if(err)
+                                printk("Failed to get registers from process, "
+                                       "errno = %d\n", -err);
 			panic("handle_trap - failed to wait at end of syscall, "
 			      "errno = %d, status = %d\n", errno, status);
+                }
 	}
 
 	handle_syscall(regs);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
