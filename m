From: akpm@linux-foundation.org
Subject: + uml-add-missing-__init-declarations.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:44:42 -0700
Message-ID: <200703222144.l2MLigQV031105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161108AbXCVVoq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: mdd missing __init declarations
has been added to the -mm tree.  Its filename is
     uml-add-missing-__init-declarations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mdd missing __init declarations
From: Jeff Dike <jdike@addtoit.com>

The build started finding calls from non-init to init functions.  These are
just cases of init functions not being properly marked, so this patch fixes
that.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c        |    2 +-
 arch/um/os-Linux/main.c     |    2 +-
 arch/um/os-Linux/mem.c      |    9 +++++----
 arch/um/os-Linux/process.c  |    5 +++--
 arch/um/os-Linux/start_up.c |    4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-add-missing-__init-declarations arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-add-missing-__init-declarations
+++ a/arch/um/kernel/mem.c
@@ -217,7 +217,7 @@ static void __init fixaddr_user_init( vo
 #endif
 }
 
-void paging_init(void)
+void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES], vaddr;
 	int i;
diff -puN arch/um/os-Linux/main.c~uml-add-missing-__init-declarations arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-add-missing-__init-declarations
+++ a/arch/um/os-Linux/main.c
@@ -120,7 +120,7 @@ extern int uml_exitcode;
 
 extern void scan_elf_aux( char **envp);
 
-int main(int argc, char **argv, char **envp)
+int __init main(int argc, char **argv, char **envp)
 {
 	char **new_argv;
 	int ret, i, err;
diff -puN arch/um/os-Linux/mem.c~uml-add-missing-__init-declarations arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~uml-add-missing-__init-declarations
+++ a/arch/um/os-Linux/mem.c
@@ -164,7 +164,8 @@ found:
  * (file: kernel/tt/ptproxy/proxy.c, proc: start_debugger).
  * So it isn't 'static' yet.
  */
-int make_tempfile(const char *template, char **out_tempname, int do_unlink)
+int __init make_tempfile(const char *template, char **out_tempname,
+			 int do_unlink)
 {
 	char *tempname;
 	int fd;
@@ -205,7 +206,7 @@ out:
  * This proc is used in start_up.c
  * So it isn't 'static'.
  */
-int create_tmp_file(unsigned long long len)
+int __init create_tmp_file(unsigned long long len)
 {
 	int fd, err;
 	char zero;
@@ -241,7 +242,7 @@ int create_tmp_file(unsigned long long l
 	return fd;
 }
 
-int create_mem_file(unsigned long long len)
+int __init create_mem_file(unsigned long long len)
 {
 	int err, fd;
 
@@ -256,7 +257,7 @@ int create_mem_file(unsigned long long l
 }
 
 
-void check_tmpexec(void)
+void __init check_tmpexec(void)
 {
 	void *addr;
 	int err, fd = create_tmp_file(UM_KERN_PAGE_SIZE);
diff -puN arch/um/os-Linux/process.c~uml-add-missing-__init-declarations arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-add-missing-__init-declarations
+++ a/arch/um/os-Linux/process.c
@@ -21,6 +21,7 @@
 #include "skas_ptrace.h"
 #include "kern_constants.h"
 #include "uml-config.h"
+#include "init.h"
 
 #define ARBITRARY_ADDR -1
 #define FAILURE_PID    -1
@@ -192,7 +193,7 @@ int os_unmap_memory(void *addr, int len)
 #define MADV_REMOVE KERNEL_MADV_REMOVE
 #endif
 
-int os_drop_memory(void *addr, int length)
+int __init os_drop_memory(void *addr, int length)
 {
 	int err;
 
@@ -202,7 +203,7 @@ int os_drop_memory(void *addr, int lengt
 	return err;
 }
 
-int can_drop_memory(void)
+int __init can_drop_memory(void)
 {
 	void *addr;
 	int fd, ok = 0;
diff -puN arch/um/os-Linux/start_up.c~uml-add-missing-__init-declarations arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-add-missing-__init-declarations
+++ a/arch/um/os-Linux/start_up.c
@@ -329,7 +329,7 @@ static void __init check_ptrace(void)
 
 extern void check_tmpexec(void);
 
-static void check_coredump_limit(void)
+static void __init check_coredump_limit(void)
 {
 	struct rlimit lim;
 	int err = getrlimit(RLIMIT_CORE, &lim);
@@ -350,7 +350,7 @@ static void check_coredump_limit(void)
 	else printf("%lu\n", lim.rlim_max);
 }
 
-void os_early_checks(void)
+void __init os_early_checks(void)
 {
 	/* Print out the core dump limits early */
 	check_coredump_limit();
_

Patches currently in -mm which might be from jdike@addtoit.com are

div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
