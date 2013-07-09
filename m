From: akpm@linux-foundation.org
Subject: [merged] ptrace-x86-cleanup-ptrace_set_debugreg.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:21 -0700
Message-ID: <51dc9af1.gNX4TVjCwAWZptFZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3GIXVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-cleanup-ptrace_set_debugreg.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:21 -0700


The patch titled
     Subject: ptrace/x86: cleanup ptrace_set_debugreg()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-cleanup-ptrace_set_debugreg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/x86: cleanup ptrace_set_debugreg()

ptrace_set_debugreg() is trivial but looks horrible.  Kill the unnecessary
goto's and return's to cleanup the code.

This matches ptrace_get_debugreg() which also needs the trivial whitespace
cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-cleanup-ptrace_set_debugreg arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-cleanup-ptrace_set_debugreg
+++ a/arch/x86/kernel/ptrace.c
@@ -703,7 +703,7 @@ restore:
  */
 static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 {
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
@@ -713,7 +713,7 @@ static unsigned long ptrace_get_debugreg
 			val = bp->hw.info.address;
 	} else if (n == 6) {
 		val = thread->debugreg6;
-	 } else if (n == 7) {
+	} else if (n == 7) {
 		val = thread->ptrace_dr7;
 	}
 	return val;
@@ -761,30 +761,20 @@ static int ptrace_set_breakpoint_addr(st
 static int ptrace_set_debugreg(struct task_struct *tsk, int n,
 			       unsigned long val)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int rc = 0;
-
+	struct thread_struct *thread = &tsk->thread;
 	/* There are no DR4 or DR5 registers */
-	if (n == 4 || n == 5)
-		return -EIO;
+	int rc = -EIO;
 
-	if (n == 6) {
-		thread->debugreg6 = val;
-		goto ret_path;
-	}
 	if (n < HBP_NUM) {
 		rc = ptrace_set_breakpoint_addr(tsk, n, val);
-		if (rc)
-			return rc;
-	}
-	/* All that's left is DR7 */
-	if (n == 7) {
+	} else if (n == 6) {
+		thread->debugreg6 = val;
+		rc = 0;
+	} else if (n == 7) {
 		rc = ptrace_write_dr7(tsk, val);
 		if (!rc)
 			thread->ptrace_dr7 = val;
 	}
