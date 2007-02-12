From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-fixups.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:25 -0800
Message-ID: <200702122248.l1CMmPhI014011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030343AbXBLWs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: fixups
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-fixups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: fixups
From: Alon Bar-Lev <alon.barlev@gmail.com>

Remove in-source externs, linux/init.h is included in all cases.
This is a fixups for "Dynamic kernel command-line" patch.

It also includes some uml __init fixups so that we can __initdata also its
command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c      |    2 --
 arch/ia64/kernel/sal.c      |    2 --
 arch/parisc/mm/init.c       |    1 -
 arch/um/include/user_util.h |    2 --
 arch/um/kernel/um_arch.c    |    6 +++---
 arch/x86_64/kernel/head64.c |    2 --
 6 files changed, 3 insertions(+), 12 deletions(-)

diff -puN arch/ia64/kernel/efi.c~dynamic-kernel-command-line-fixups arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~dynamic-kernel-command-line-fixups
+++ a/arch/ia64/kernel/efi.c
@@ -405,8 +405,6 @@ efi_map_pal_code (void)
 	ia64_srlz_i();
 }
 
-extern char __initdata boot_command_line[];
-
 void __init
 efi_init (void)
 {
diff -puN arch/ia64/kernel/sal.c~dynamic-kernel-command-line-fixups arch/ia64/kernel/sal.c
--- a/arch/ia64/kernel/sal.c~dynamic-kernel-command-line-fixups
+++ a/arch/ia64/kernel/sal.c
@@ -190,8 +190,6 @@ sal_desc_ap_wakeup (void *p)
 	}
 }
 
-extern char __initdata boot_command_line[];
-
 static void __init
 chk_nointroute_opt(void)
 {
diff -puN arch/parisc/mm/init.c~dynamic-kernel-command-line-fixups arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~dynamic-kernel-command-line-fixups
+++ a/arch/parisc/mm/init.c
@@ -77,7 +77,6 @@ static void __init mem_limit_func(void)
 {
 	char *cp, *end;
 	unsigned long limit;
-	extern char __initdata boot_command_line[];
 
 	/* We need this before __setup() functions are called */
 
diff -puN arch/um/include/user_util.h~dynamic-kernel-command-line-fixups arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~dynamic-kernel-command-line-fixups
+++ a/arch/um/include/user_util.h
@@ -38,8 +38,6 @@ extern unsigned long long highmem;
 
 extern char host_info[];
 
-extern char __initdata boot_command_line[];
-
 extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
diff -puN arch/um/kernel/um_arch.c~dynamic-kernel-command-line-fixups arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~dynamic-kernel-command-line-fixups
+++ a/arch/um/kernel/um_arch.c
@@ -43,9 +43,9 @@
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
 /* Changed in linux_main and setup_arch, which run before SMP is started */
-static char command_line[COMMAND_LINE_SIZE] = { 0 };
+static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
 
-static void add_arg(char *arg)
+static void __init add_arg(char *arg)
 {
 	if (strlen(command_line) + strlen(arg) + 1 > COMMAND_LINE_SIZE) {
 		printf("add_arg: Too many command line arguments!\n");
@@ -330,7 +330,7 @@ EXPORT_SYMBOL(end_iomem);
 
 extern char __binary_start;
 
-int linux_main(int argc, char **argv)
+int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
diff -puN arch/x86_64/kernel/head64.c~dynamic-kernel-command-line-fixups arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~dynamic-kernel-command-line-fixups
+++ a/arch/x86_64/kernel/head64.c
@@ -34,8 +34,6 @@ static void __init clear_bss(void)
 #define OLD_CL_BASE_ADDR        0x90000
 #define OLD_CL_OFFSET           0x90022
 
-extern char __initdata boot_command_line[];
-
 static void __init copy_bootdata(char *real_mode_data)
 {
 	int new_data;
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
