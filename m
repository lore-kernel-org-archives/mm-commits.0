From: akpm@linux-foundation.org
Subject: + uml-further-bugsc-tidying.patch added to -mm tree
Date: Fri, 02 Nov 2007 11:43:22 -0700
Message-ID: <200711021843.lA2IhMhQ005932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786AbXKBSnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 14:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: further bugs.c tidying
has been added to the -mm tree.  Its filename is
     uml-further-bugsc-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: further bugs.c tidying
From: Jeff Dike <jdike@addtoit.com>

bugs.c, for both i386 and x86_64, can undergo further cleaning -
	The i386 arch_check_bugs only does one thing, so we might as
well inline the cmov checking.
	The i386 includes can be trimmed down a bit.
	arch_init_thread wasn't used, so it is deleted.
	The panics in arch_handle_signal are turned into printks
because the process is about to get segfaulted anyway, so something is
dying no matter what happens here.  Also, the return value was always
the same, so it contained no information, so it can be void instead.
The name is changed to arch_examine_signal because it doesn't handle
anything.
	The caller of arch_handle_signal, relay_signal, does things in
a different order.  The kernel-mode signal check is now first, which
puts everything else together, making things a bit clearer conceptually.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/arch.h    |    2 -
 arch/um/kernel/trap.c     |    5 +---
 arch/um/sys-i386/bugs.c   |   45 +++++++++++++++---------------------
 arch/um/sys-x86_64/bugs.c |    7 -----
 4 files changed, 23 insertions(+), 36 deletions(-)

diff -puN arch/um/include/arch.h~uml-further-bugsc-tidying arch/um/include/arch.h
--- a/arch/um/include/arch.h~uml-further-bugsc-tidying
+++ a/arch/um/include/arch.h
@@ -10,6 +10,6 @@
 
 extern void arch_check_bugs(void);
 extern int arch_fixup(unsigned long address, struct uml_pt_regs *regs);
-extern int arch_handle_signal(int sig, struct uml_pt_regs *regs);
+extern void arch_examine_signal(int sig, struct uml_pt_regs *regs);
 
 #endif
diff -puN arch/um/kernel/trap.c~uml-further-bugsc-tidying arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-further-bugsc-tidying
+++ a/arch/um/kernel/trap.c
@@ -216,9 +216,6 @@ unsigned long segv(struct faultinfo fi, 
 
 void relay_signal(int sig, struct uml_pt_regs *regs)
 {
-	if (arch_handle_signal(sig, regs))
-		return;
-
 	if (!UPT_IS_USER(regs)) {
 		if (sig == SIGBUS)
 			printk(KERN_ERR "Bus error - the host /dev/shm or /tmp "
@@ -226,6 +223,8 @@ void relay_signal(int sig, struct uml_pt
 		panic("Kernel mode signal %d", sig);
 	}
 
+	arch_examine_signal(sig, regs);
+
 	current->thread.arch.faultinfo = *UPT_FAULTINFO(regs);
 	force_sig(sig, current);
 }
diff -puN arch/um/sys-i386/bugs.c~uml-further-bugsc-tidying arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-further-bugsc-tidying
+++ a/arch/um/sys-i386/bugs.c
@@ -3,14 +3,12 @@
  * Licensed under the GPL
  */
 
-#include <errno.h>
 #include <signal.h>
-#include <string.h>
 #include "kern_constants.h"
-#include "os.h"
+#include "longjmp.h"
 #include "task.h"
 #include "user.h"
-#include "sysdep/archsetjmp.h"
+#include "sysdep/ptrace.h"
 
 /* Set during early boot */
 int host_has_cmov = 1;
@@ -22,7 +20,7 @@ static void cmov_sigill_test_handler(int
 	longjmp(cmov_test_return, 1);
 }
 
-static void test_for_host_cmov(void)
+void arch_check_bugs(void)
 {
 	struct sigaction old, new;
 
@@ -44,16 +42,7 @@ static void test_for_host_cmov(void)
 	sigaction(SIGILL, &old, &new);
 }
 
-void arch_init_thread(void)
-{
-}
-
-void arch_check_bugs(void)
-{
-	test_for_host_cmov();
-}
-
-int arch_handle_signal(int sig, struct uml_pt_regs *regs)
+void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 {
 	unsigned char tmp[2];
 
@@ -62,20 +51,24 @@ int arch_handle_signal(int sig, struct u
 	 * SIGILL in init.
 	 */
 	if ((sig != SIGILL) || (TASK_PID(get_current()) != 1))
-		return 0;
+		return;
+
+	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2)) {
+		printk(UM_KERN_ERR "SIGILL in init, could not read "
+		       "instructions!\n");
+		return;
+	}
 
-	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2))
-		panic("SIGILL in init, could not read instructions!\n");
 	if ((tmp[0] != 0x0f) || ((tmp[1] & 0xf0) != 0x40))
-		return 0;
+		return;
 
 	if (host_has_cmov == 0)
-		panic("SIGILL caused by cmov, which this processor doesn't "
-		      "implement, boot a filesystem compiled for older "
-		      "processors");
+		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		       "processor doesn't implement.  Boot a filesystem "
+		       "compiled for older processors");
 	else if (host_has_cmov == 1)
-		panic("SIGILL caused by cmov, which this processor claims to "
-		      "implement");
-	else panic("Bad value for host_has_cmov (%d)", host_has_cmov);
-	return 0;
+		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		       "processor claims to implement");
+	else printk(UM_KERN_ERR "Bad value for host_has_cmov (%d)",
+		    host_has_cmov);
 }
diff -puN arch/um/sys-x86_64/bugs.c~uml-further-bugsc-tidying arch/um/sys-x86_64/bugs.c
--- a/arch/um/sys-x86_64/bugs.c~uml-further-bugsc-tidying
+++ a/arch/um/sys-x86_64/bugs.c
@@ -6,15 +6,10 @@
 
 #include "sysdep/ptrace.h"
 
-void arch_init_thread(void)
-{
-}
-
 void arch_check_bugs(void)
 {
 }
 
-int arch_handle_signal(int sig, struct uml_pt_regs *regs)
+void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 {
-	return 0;
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
