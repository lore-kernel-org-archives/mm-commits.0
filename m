From: akpm@linux-foundation.org
Subject: + uml-redo-host-capability-detection-and-disabling.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:01 -0700
Message-ID: <200805062049.m46Kn2as026534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759423AbYEFUtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: redo host capability detection and disabling
has been added to the -mm tree.  Its filename is
     uml-redo-host-capability-detection-and-disabling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: redo host capability detection and disabling
From: Jeff Dike <jdike@addtoit.com>

Redo how host capabilities are recorded at startup and disabled on the
command line.

There are now explicit variables saying what's been disabled by the
command line rather than the implicitness of the have_* variable being
zero.  The capability variables now start at zero and are set to one
as their capabilities are found to be present on the host.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   81 +++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-redo-host-capability-detection-and-disabling arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-redo-host-capability-detection-and-disabling
+++ a/arch/um/os-Linux/start_up.c
@@ -23,6 +23,7 @@
 #include "mem_user.h"
 #include "ptrace_user.h"
 #include "registers.h"
+#include "skas.h"
 #include "skas_ptrace.h"
 
 static void ptrace_child(void)
@@ -140,14 +141,27 @@ static int stop_ptraced_child(int pid, i
 }
 
 /* Changed only during early boot */
-int ptrace_faultinfo = 1;
-int ptrace_ldt = 1;
-int proc_mm = 1;
-int skas_needs_stub = 0;
+int ptrace_faultinfo;
+static int disable_ptrace_faultinfo;
+
+int ptrace_ldt;
+static int disable_ptrace_ldt;
+
+int proc_mm;
+static int disable_proc_mm;
+
+int have_switch_mm;
+static int disable_switch_mm;
+
+int skas_needs_stub;
 
 static int __init skas0_cmd_param(char *str, int* add)
 {
-	ptrace_faultinfo = proc_mm = 0;
+	disable_ptrace_faultinfo = 1;
+	disable_ptrace_ldt = 1;
+	disable_proc_mm = 1;
+	disable_switch_mm = 1;
+
 	return 0;
 }
 
@@ -157,15 +171,12 @@ static int __init mode_skas0_cmd_param(c
 	__attribute__((alias("skas0_cmd_param")));
 
 __uml_setup("skas0", skas0_cmd_param,
-		"skas0\n"
-		"    Disables SKAS3 usage, so that SKAS0 is used, unless \n"
-	        "    you specify mode=tt.\n\n");
+"skas0\n"
+"    Disables SKAS3 and SKAS4 usage, so that SKAS0 is used\n\n");
 
 __uml_setup("mode=skas0", mode_skas0_cmd_param,
-		"mode=skas0\n"
-		"    Disables SKAS3 usage, so that SKAS0 is used, unless you \n"
-		"    specify mode=tt. Note that this was recently added - on \n"
-		"    older kernels you must use simply \"skas0\".\n\n");
+"mode=skas0\n"
+"    Disables SKAS3 and SKAS4 usage, so that SKAS0 is used.\n\n");
 
 /* Changed only during early boot */
 static int force_sysemu_disabled = 0;
@@ -360,7 +371,7 @@ void __init os_early_checks(void)
 
 static int __init noprocmm_cmd_param(char *str, int* add)
 {
-	proc_mm = 0;
+	disable_proc_mm = 1;
 	return 0;
 }
 
@@ -372,7 +383,7 @@ __uml_setup("noprocmm", noprocmm_cmd_par
 
 static int __init noptracefaultinfo_cmd_param(char *str, int* add)
 {
-	ptrace_faultinfo = 0;
+	disable_ptrace_faultinfo = 1;
 	return 0;
 }
 
@@ -384,7 +395,7 @@ __uml_setup("noptracefaultinfo", noptrac
 
 static int __init noptraceldt_cmd_param(char *str, int* add)
 {
-	ptrace_ldt = 0;
+	disable_ptrace_ldt = 1;
 	return 0;
 }
 
@@ -404,17 +415,15 @@ static inline void check_skas3_ptrace_fa
 
 	n = ptrace(PTRACE_FAULTINFO, pid, 0, &fi);
 	if (n < 0) {
-		ptrace_faultinfo = 0;
 		if (errno == EIO)
 			non_fatal("not found\n");
 		else
 			perror("not found");
-	}
+	} else if (disable_ptrace_faultinfo)
+		non_fatal("found but disabled on command line\n");
 	else {
-		if (!ptrace_faultinfo)
-			non_fatal("found but disabled on command line\n");
-		else
-			non_fatal("found\n");
+		ptrace_faultinfo = 1;
+		non_fatal("found\n");
 	}
 
 	stop_ptraced_child(pid, 1, 1);
@@ -437,38 +446,30 @@ static inline void check_skas3_ptrace_ld
 	if (n < 0) {
 		if (errno == EIO)
 			non_fatal("not found\n");
-		else {
+		else
 			perror("not found");
-		}
-		ptrace_ldt = 0;
-	}
+	} else if (disable_ptrace_ldt)
+		non_fatal("found, but use is disabled\n");
 	else {
-		if (ptrace_ldt)
-			non_fatal("found\n");
-		else
-			non_fatal("found, but use is disabled\n");
+		ptrace_ldt = 1;
+		non_fatal("found\n");
 	}
 
 	stop_ptraced_child(pid, 1, 1);
-#else
-	/* PTRACE_LDT might be disabled via cmdline option.
-	 * We want to override this, else we might use the stub
-	 * without real need
-	 */
-	ptrace_ldt = 1;
 #endif
 }
 
 static inline void check_skas3_proc_mm(void)
 {
 	non_fatal("  - /proc/mm...");
-	if (access("/proc/mm", W_OK) < 0) {
-		proc_mm = 0;
+	if (access("/proc/mm", W_OK) < 0)
 		perror("not found");
-	}
-	else if (!proc_mm)
+	else if (disable_proc_mm)
 		non_fatal("found but disabled on command line\n");
-	else non_fatal("found\n");
+	else {
+		proc_mm = 1;
+		non_fatal("found\n");
+	}
 }
 
 void can_do_skas(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

