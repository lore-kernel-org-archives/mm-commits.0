From: akpm@linux-foundation.org
Subject: + uml-delete-unused-code.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:34:07 -0800
Message-ID: <200702220234.l1M2Y7cn001923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXBVCeL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:34:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: delete unused code
has been added to the -mm tree.  Its filename is
     uml-delete-unused-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: delete unused code
From: Jeff Dike <jdike@addtoit.com>

Get rid of a bunch of unused stuff -
	cpu_feature had no users
	linux_prog is little-used, so its declaration is moved to the
user for easy deletion when the whole file goes away
	a long-unused debugging aid in helper.c is gone

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    1 -
 arch/um/include/user_util.h |    1 -
 arch/um/kernel/tt/gdb.c     |    2 ++
 arch/um/os-Linux/helper.c   |   11 -----------
 arch/um/os-Linux/main.c     |    8 +-------
 arch/um/sys-i386/bugs.c     |   23 -----------------------
 arch/um/sys-x86_64/bugs.c   |   23 -----------------------
 7 files changed, 3 insertions(+), 66 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-delete-unused-code arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-delete-unused-code
+++ a/arch/um/include/kern_util.h
@@ -23,7 +23,6 @@ struct kern_handlers {
 extern const struct kern_handlers handlinfo_kern;
 
 extern int ncpus;
-extern char *linux_prog;
 extern char *gdb_init;
 extern int kmalloc_ok;
 extern int jail;
diff -puN arch/um/include/user_util.h~uml-delete-unused-code arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-delete-unused-code
+++ a/arch/um/include/user_util.h
@@ -60,7 +60,6 @@ extern void kill_child_dead(int pid);
 extern int cont(int pid);
 extern void check_sigio(void);
 extern void arch_check_bugs(void);
-extern int cpu_feature(char *what, char *buf, int len);
 extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
 extern int arch_fixup(unsigned long address, void *sc_ptr);
 extern void arch_init_thread(void);
diff -puN arch/um/kernel/tt/gdb.c~uml-delete-unused-code arch/um/kernel/tt/gdb.c
--- a/arch/um/kernel/tt/gdb.c~uml-delete-unused-code
+++ a/arch/um/kernel/tt/gdb.c
@@ -115,6 +115,8 @@ struct gdb_data {
 	int err;
 };
 
+extern char *linux_prog;
+
 static void config_gdb_cb(void *arg)
 {
 	struct gdb_data *data = arg;
diff -puN arch/um/os-Linux/helper.c~uml-delete-unused-code arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-delete-unused-code
+++ a/arch/um/os-Linux/helper.c
@@ -25,23 +25,12 @@ struct helper_data {
 	char *buf;
 };
 
-/* Debugging aid, changed only from gdb */
-int helper_pause = 0;
-
-static void helper_hup(int sig)
-{
-}
-
 static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
 	int errval;
 
-	if (helper_pause){
-		signal(SIGHUP, helper_hup);
-		pause();
-	}
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	errval = execvp_noalloc(data->buf, argv[0], argv);
diff -puN arch/um/os-Linux/main.c~uml-delete-unused-code arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-delete-unused-code
+++ a/arch/um/os-Linux/main.c
@@ -25,12 +25,7 @@
 #include "os.h"
 #include "um_malloc.h"
 
-/* Set in set_stklim, which is called from main and __wrap_malloc.
- * __wrap_malloc only calls it if main hasn't started.
- */
-unsigned long stacksizelim;
-
-/* Set in main */
+/* Set in main, unchanged thereafter */
 char *linux_prog;
 
 #define PGD_BOUND (4 * 1024 * 1024)
@@ -52,7 +47,6 @@ static void set_stklim(void)
 			exit(1);
 		}
 	}
-	stacksizelim = (lim.rlim_cur + PGD_BOUND - 1) & ~(PGD_BOUND - 1);
 }
 
 static __init void do_uml_initcalls(void)
diff -puN arch/um/sys-i386/bugs.c~uml-delete-unused-code arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-delete-unused-code
+++ a/arch/um/sys-i386/bugs.c
@@ -79,29 +79,6 @@ static int find_cpuinfo_line(int fd, cha
 	return(0);
 }
 
-int cpu_feature(char *what, char *buf, int len)
-{
-	int fd, ret = 0;
-
-	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open /proc/cpuinfo, err = %d\n", -fd);
-		return(0);
-	}
-
-	if(!find_cpuinfo_line(fd, what, buf, len)){
-		printk("Couldn't find '%s' line in /proc/cpuinfo\n", what);
-		goto out_close;
-	}
-
-	token(fd, buf, len, '\n');
-	ret = 1;
-
- out_close:
-	os_close_file(fd);
-	return(ret);
-}
-
 static int check_cpu_flag(char *feature, int *have_it)
 {
 	char buf[MAXTOKEN], c;
diff -puN arch/um/sys-x86_64/bugs.c~uml-delete-unused-code arch/um/sys-x86_64/bugs.c
--- a/arch/um/sys-x86_64/bugs.c~uml-delete-unused-code
+++ a/arch/um/sys-x86_64/bugs.c
@@ -88,29 +88,6 @@ static int find_cpuinfo_line(int fd, cha
 	return(0);
 }
 
-int cpu_feature(char *what, char *buf, int len)
-{
-	int fd, ret = 0;
-
-	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open /proc/cpuinfo, err = %d\n", -fd);
-		return(0);
-	}
-
-	if(!find_cpuinfo_line(fd, what, buf, len)){
-		printk("Couldn't find '%s' line in /proc/cpuinfo\n", what);
-		goto out_close;
-	}
-
-	token(fd, buf, len, '\n');
-	ret = 1;
-
- out_close:
-	os_close_file(fd);
-	return(ret);
-}
-
 /* Overrides for Emacs so that we follow Linus's tabbing style.
  * Emacs will notice this stuff at the end of the file and automatically
  * adjust the settings for this buffer only.  This must remain at the end
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
