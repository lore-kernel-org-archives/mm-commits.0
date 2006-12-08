From: akpm@osdl.org
Subject: - fix-linux-banner-utsname-information.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:41 -0800
Message-ID: <200612081959.kB8JxfYc001645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426181AbWLHT7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 14:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@13thfloor.at, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Fix linux banner utsname information
has been removed from the -mm tree.  Its filename was
     fix-linux-banner-utsname-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix linux banner utsname information
From: Herbert Poetzl <herbert@13thfloor.at>

utsname information is shown in the linux banner, which also is used for
/proc/version (which can have different utsname values inside a uts
namespaces).  this patch makes the varying data arguments and changes the
string to a format string, using those arguments.

Signed-off-by: Herbert Poetzl <herbert@13thfloor.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c |    4 ++--
 init/Makefile       |    1 +
 init/main.c         |    4 +++-
 init/version.c      |    5 +++--
 4 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_misc.c~fix-linux-banner-utsname-information fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~fix-linux-banner-utsname-information
+++ a/fs/proc/proc_misc.c
@@ -252,8 +252,8 @@ static int version_read_proc(char *page,
 {
 	int len;
 
-	strcpy(page, linux_banner);
-	len = strlen(page);
+	len = sprintf(page, linux_banner,
+		utsname()->release, utsname()->version);
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
diff -puN init/Makefile~fix-linux-banner-utsname-information init/Makefile
--- a/init/Makefile~fix-linux-banner-utsname-information
+++ a/init/Makefile
@@ -15,6 +15,7 @@ clean-files := ../include/linux/compile.
 
 # dependencies on generated files need to be listed explicitly
 
+$(obj)/main.o: include/linux/compile.h
 $(obj)/version.o: include/linux/compile.h
 
 # compile.h changes depending on hostname, generation number, etc,
diff -puN init/main.c~fix-linux-banner-utsname-information init/main.c
--- a/init/main.c~fix-linux-banner-utsname-information
+++ a/init/main.c
@@ -50,6 +50,8 @@
 #include <linux/buffer_head.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/utsrelease.h>
+#include <linux/compile.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -506,7 +508,7 @@ asmlinkage void __init start_kernel(void
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk(linux_banner, UTS_RELEASE, UTS_VERSION);
 	setup_arch(&command_line);
 	unwind_setup();
 	setup_per_cpu_areas();
diff -puN init/version.c~fix-linux-banner-utsname-information init/version.c
--- a/init/version.c~fix-linux-banner-utsname-information
+++ a/init/version.c
@@ -35,5 +35,6 @@ struct uts_namespace init_uts_ns = {
 EXPORT_SYMBOL_GPL(init_uts_ns);
 
 const char linux_banner[] =
-	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+	"Linux version %s (" LINUX_COMPILE_BY "@"
+	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") %s\n";
+
_

Patches currently in -mm which might be from herbert@13thfloor.at are

fix-linux-banner-utsname-information.patch
add-process_session-helper-routine.patch
rename-struct-namespace-to-struct-mnt_namespace.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch

