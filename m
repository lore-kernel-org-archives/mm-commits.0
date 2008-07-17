From: akpm@linux-foundation.org
Subject: + modules-extend-initcall_debug-functionality-to-the-module-loader.patch added to -mm tree
Date: Thu, 17 Jul 2008 16:32:14 -0700
Message-ID: <200807172332.m6HNWHDh012713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759526AbYGQXc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 19:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, rusty@rustcorp.com.au


The patch titled
     modules: extend initcall_debug functionality to the module loader
has been added to the -mm tree.  Its filename is
     modules-extend-initcall_debug-functionality-to-the-module-loader.patch

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
Subject: modules: extend initcall_debug functionality to the module loader
From: Arjan van de Ven <arjan@infradead.org>

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
@@ -143,6 +143,7 @@ extern char __initdata boot_command_line
 extern char *saved_command_line;
 extern unsigned int reset_devices;
 extern int initmem_now_dynamic;
+extern int do_one_initcall(initcall_t fn);
 
 /* used by init/main.c */
 void setup_arch(char **);
diff -puN init/main.c~modules-extend-initcall_debug-functionality-to-the-module-loader init/main.c
--- a/init/main.c~modules-extend-initcall_debug-functionality-to-the-module-loader
+++ a/init/main.c
@@ -694,7 +694,7 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
-static int __initdata initcall_debug;
+static int initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
 {
@@ -703,7 +703,7 @@ static int __init initcall_debug_setup(c
 }
 __setup("initcall_debug", initcall_debug_setup);
 
-static void __init do_one_initcall(initcall_t fn)
+int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t t0, t1, delta;
@@ -743,6 +743,8 @@ static void __init do_one_initcall(initc
 		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
 		printk(" returned with %s\n", msgbuf);
 	}
+
+	return result;
 }
 
 
diff -puN kernel/module.c~modules-extend-initcall_debug-functionality-to-the-module-loader kernel/module.c
--- a/kernel/module.c~modules-extend-initcall_debug-functionality-to-the-module-loader
+++ a/kernel/module.c
@@ -2288,7 +2288,7 @@ sys_init_module(void __user *umod,
 
 	/* Start the module */
 	if (mod->init != NULL)
-		ret = mod->init();
+		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
git-unionfs.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
list-debugging-use-warn_on-instead-of-bug.patch
kallsyms-unify-32-and-64-bit-code.patch

