From: akpm@linux-foundation.org
Subject: + uml-improve-detection-of-host-cmov.patch added to -mm tree
Date: Fri, 02 Nov 2007 11:42:12 -0700
Message-ID: <200711021842.lA2IgCBS005881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbXKBSmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 14:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: improve detection of host cmov
has been added to the -mm tree.  Its filename is
     uml-improve-detection-of-host-cmov.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: improve detection of host cmov
From: Karol Swietlicki <magotari@gmail.com>

This patch introduces a new way of checking for the cmov instruction.  I use
signal handling instead of reading /proc/cpuinfo.

[ jdike - Fiddled the asm to make it obvious that it didn't mess with
any in-use registers and made test_for_host_cmov void ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/bugs.c |   41 +++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff -puN arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-improve-detection-of-host-cmov
+++ a/arch/um/sys-i386/bugs.c
@@ -10,11 +10,42 @@
 #include "os.h"
 #include "task.h"
 #include "user.h"
+#include "sysdep/archsetjmp.h"
 
 #define MAXTOKEN 64
 
 /* Set during early boot */
 int host_has_cmov = 1;
+static jmp_buf cmov_test_return;
+
+static void cmov_sigill_test_handler(int sig)
+{
+	host_has_cmov = 0;
+	longjmp(cmov_test_return, 1);
+}
+
+static void test_for_host_cmov(void)
+{
+	struct sigaction old, new;
+
+	printk(UM_KERN_INFO "Checking for host processor cmov support...");
+	new.sa_handler = cmov_sigill_test_handler;
+
+	/* Make sure that SIGILL is enabled after the handler longjmps back */
+	new.sa_flags = SA_NODEFER;
+	sigemptyset(&new.sa_mask);
+	sigaction(SIGILL, &new, &old);
+
+	if (setjmp(cmov_test_return) == 0) {
+		unsigned long foo = 0;
+		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
+		printk("Yes\n");
+	}
+	else
+		printk("No\n");
+
+	sigaction(SIGILL, &old, &new);
+}
 
 static char token(int fd, char *buf, int len, char stop)
 {
@@ -153,15 +184,7 @@ void arch_init_thread(void)
 
 void arch_check_bugs(void)
 {
-	int have_it;
-
-	if (os_access("/proc/cpuinfo", OS_ACC_R_OK) < 0) {
-		printk(UM_KERN_ERR "/proc/cpuinfo not available - skipping CPU "
-		       "capability checks\n");
-		return;
-	}
-	if (check_cpu_flag("cmov", &have_it))
-		host_has_cmov = have_it;
+	test_for_host_cmov();
 }
 
 int arch_handle_signal(int sig, struct uml_pt_regs *regs)
_

Patches currently in -mm which might be from magotari@gmail.com are

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-remove-now-unused-code.patch
