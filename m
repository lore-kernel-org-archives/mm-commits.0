From: akpm@linux-foundation.org
Subject: - modules-extend-initcall_debug-functionality-to-the-module-loader.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:55:56 -0700
Message-ID: <200808062055.m76KtufB014621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYHFVA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     modules: extend initcall_debug functionality to the module loader
has been removed from the -mm tree.  Its filename was
     modules-extend-initcall_debug-functionality-to-the-module-loader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: extend initcall_debug functionality to the module loader
From: Arjan van de Ven <arjan@linux.intel.com>

The kernel has this really nice facility where if you put "initcall_debug"
on the kernel commandline, it'll print which function it's going to
execute just before calling an initcall, and then after the call completes
it will

1) print if it had an error code

2) checks for a few simple bugs (like leaving irqs off)
and

3) print how long the init call took in milliseconds.

While trying to optimize the boot speed of my laptop, I have been loving
number 3 to figure out what to optimize...  ...  and then I wished that
the same thing was done for module loading.

This patch makes the module loader use this exact same functionality; it's
a logical extension in my view (since modules are just sort of late
binding initcalls anyway) and so far I've found it quite useful in finding
where things are too slow in my boot.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    1 +
 init/main.c          |    6 ++++--
 kernel/module.c      |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/init.h~modules-extend-initcall_debug-functionality-to-the-module-loader include/linux/init.h
--- a/include/linux/init.h~modules-extend-initcall_debug-functionality-to-the-module-loader
+++ a/include/linux/init.h
@@ -139,6 +139,7 @@ extern initcall_t __con_initcall_start[]
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
 /* Defined in init/main.c */
+extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
diff -puN init/main.c~modules-extend-initcall_debug-functionality-to-the-module-loader init/main.c
--- a/init/main.c~modules-extend-initcall_debug-functionality-to-the-module-loader
+++ a/init/main.c
@@ -699,7 +699,7 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
-static int __initdata initcall_debug;
+static int initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
 {
@@ -708,7 +708,7 @@ static int __init initcall_debug_setup(c
 }
 __setup("initcall_debug", initcall_debug_setup);
 
-static void __init do_one_initcall(initcall_t fn)
+int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t t0, t1, delta;
@@ -748,6 +748,8 @@ static void __init do_one_initcall(initc
 		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
 		printk(" returned with %s\n", msgbuf);
 	}
+
+	return result;
 }
 
 
diff -puN kernel/module.c~modules-extend-initcall_debug-functionality-to-the-module-loader kernel/module.c
--- a/kernel/module.c~modules-extend-initcall_debug-functionality-to-the-module-loader
+++ a/kernel/module.c
@@ -2289,7 +2289,7 @@ sys_init_module(void __user *umod,
 
 	/* Start the module */
 	if (mod->init != NULL)
-		ret = mod->init();
+		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
use-warn-in-kernel-lockdepc.patch

