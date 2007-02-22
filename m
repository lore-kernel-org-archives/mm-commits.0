From: akpm@linux-foundation.org
Subject: + uml-host_info-tidying.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:34:11 -0800
Message-ID: <200702220234.l1M2YBTm001929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXBVCeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:34:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: host_info tidying
has been added to the -mm tree.  Its filename is
     uml-host_info-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: host_info tidying
From: Jeff Dike <jdike@addtoit.com>

Move the host_info string from util.c to um_arch.c, where it is
actually initialized and used.  Also document its lack of locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h        |    2 +-
 arch/um/include/user_util.h |    2 --
 arch/um/kernel/um_arch.c    |    6 +++++-
 arch/um/os-Linux/util.c     |    8 +++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/um/include/os.h~uml-host_info-tidying arch/um/include/os.h
--- a/arch/um/include/os.h~uml-host_info-tidying
+++ a/arch/um/include/os.h
@@ -272,7 +272,7 @@ extern void stack_protections(unsigned l
 extern void task_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
-extern void setup_hostinfo(void);
+extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
 
 /* time.c */
diff -puN arch/um/include/user_util.h~uml-host_info-tidying arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-host_info-tidying
+++ a/arch/um/include/user_util.h
@@ -36,8 +36,6 @@ extern unsigned long end_vm;
 extern unsigned long start_vm;
 extern unsigned long long highmem;
 
-extern char host_info[];
-
 extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
diff -puN arch/um/kernel/um_arch.c~uml-host_info-tidying arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-host_info-tidying
+++ a/arch/um/kernel/um_arch.c
@@ -17,6 +17,7 @@
 #include "linux/seq_file.h"
 #include "linux/delay.h"
 #include "linux/module.h"
+#include "linux/utsname.h"
 #include "asm/page.h"
 #include "asm/pgtable.h"
 #include "asm/ptrace.h"
@@ -67,6 +68,9 @@ unsigned long thread_saved_pc(struct tas
 					      task));
 }
 
+/* Changed in setup_arch, which is called in early boot */
+static char host_info[(__NEW_UTS_LEN + 1) * 5];
+
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	int index = 0;
@@ -482,7 +486,7 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
-	setup_hostinfo();
+	setup_hostinfo(host_info, sizeof host_info);
 }
 
 void __init check_bugs(void)
diff -puN arch/um/os-Linux/util.c~uml-host_info-tidying arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-host_info-tidying
+++ a/arch/um/os-Linux/util.c
@@ -96,15 +96,13 @@ void setup_machinename(char *machine_out
 	strcpy(machine_out, host.machine);
 }
 
-char host_info[(_UTSNAME_LENGTH + 1) * 4 + _UTSNAME_NODENAME_LENGTH + 1];
-
-void setup_hostinfo(void)
+void setup_hostinfo(char *buf, int len)
 {
 	struct utsname host;
 
 	uname(&host);
-	sprintf(host_info, "%s %s %s %s %s", host.sysname, host.nodename,
-		host.release, host.version, host.machine);
+	snprintf(buf, len, "%s %s %s %s %s", host.sysname, host.nodename,
+		 host.release, host.version, host.machine);
 }
 
 int setjmp_wrapper(void (*proc)(void *, void *), ...)
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
