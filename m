From: akpm@linux-foundation.org
Subject: + uml-convert-functions-to-void.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:15:36 -0800
Message-ID: <200711160015.lAG0FagN023226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934201AbXKPAPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:15:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: convert functions to void
has been added to the -mm tree.  Its filename is
     uml-convert-functions-to-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: convert functions to void
From: Karol Swietlicki <magotari@gmail.com>

This patch changes a few functions into returning void.  The return values
were not used anyway, so I think it should not be a problem.  Also removed a
little leftover bit from TT mode.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h        |    6 +-----
 arch/um/kernel/um_arch.c    |    5 ++---
 arch/um/os-Linux/start_up.c |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff -puN arch/um/include/os.h~uml-convert-functions-to-void arch/um/include/os.h
--- a/arch/um/include/os.h~uml-convert-functions-to-void
+++ a/arch/um/include/os.h
@@ -167,14 +167,10 @@ extern int os_fchange_dir(int fd);
 
 /* start_up.c */
 extern void os_early_checks(void);
-extern int can_do_skas(void);
+extern void can_do_skas(void);
 extern void os_check_bugs(void);
 extern void check_host_supports_tls(int *supports_tls, int *tls_min);
 
-/* Make sure they are clear when running in TT mode. Required by
- * SEGV_MAYBE_FIXABLE */
-#define clear_can_do_skas() do { ptrace_faultinfo = proc_mm = 0; } while (0)
-
 /* mem.c */
 extern int create_mem_file(unsigned long long len);
 
diff -puN arch/um/kernel/um_arch.c~uml-convert-functions-to-void arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-convert-functions-to-void
+++ a/arch/um/kernel/um_arch.c
@@ -198,7 +198,7 @@ __uml_setup("--help", Usage,
 "    Prints this message.\n\n"
 );
 
-static int __init uml_checksetup(char *line, int *add)
+static void __init uml_checksetup(char *line, int *add)
 {
 	struct uml_param *p;
 
@@ -208,10 +208,9 @@ static int __init uml_checksetup(char *l
 
 		n = strlen(p->str);
 		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
-			return 1;
+			return;
 		p++;
 	}
-	return 0;
 }
 
 static void __init uml_postsetup(void)
diff -puN arch/um/os-Linux/start_up.c~uml-convert-functions-to-void arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-convert-functions-to-void
+++ a/arch/um/os-Linux/start_up.c
@@ -466,7 +466,7 @@ static inline void check_skas3_proc_mm(v
 	else non_fatal("found\n");
 }
 
-int can_do_skas(void)
+void can_do_skas(void)
 {
 	non_fatal("Checking for the skas3 patch in the host:\n");
 
@@ -476,8 +476,6 @@ int can_do_skas(void)
 
 	if (!proc_mm || !ptrace_faultinfo || !ptrace_ldt)
 		skas_needs_stub = 1;
-
-	return 1;
 }
 
 int __init parse_iomem(char *str, int *add)
_

Patches currently in -mm which might be from magotari@gmail.com are

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
uml-remove-now-unused-code.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch
uml-remove-unused-variables-in-the-context-switcher.patch
uml-convert-functions-to-void.patch
