From: akpm@linux-foundation.org
Subject: - uml-add-missing-__init-declarations.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:25 -0700
Message-ID: <200705080006.l4806PiC009188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967389AbXEHAG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add missing __init declarations
has been removed from the -mm tree.  Its filename was
     uml-add-missing-__init-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: add missing __init declarations
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
@@ -216,7 +216,7 @@ static void __init fixaddr_user_init( vo
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

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
