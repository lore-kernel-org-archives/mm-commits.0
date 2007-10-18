From: akpm@linux-foundation.org
Subject: - remove-unsafe-from-module-struct.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:59 -0700
Message-ID: <200710180653.l9I6rxAa030486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761717AbXJRHsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, bunk@stusta.de, dan.j.williams@intel.com, shannon.nelson@intel.com, sri@us.ibm.com, vladislav.yasevich@hp.com, mm-commits@vger.kernel.org


The patch titled
     Remove "unsafe" from module struct
has been removed from the -mm tree.  Its filename was
     remove-unsafe-from-module-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove "unsafe" from module struct
From: Rusty Russell <rusty@rustcorp.com.au>

Adrian Bunk points out that "unsafe" was used to mark modules touched by
the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's time
to remove the member from the module structure, as well.

If you want a module which can't unload, don't register an exit function.

(Vlad Yasevich says SCTP is now safe to unload, so just remove the
__unsafe there).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/iop-adma.c |    9 ++++-----
 include/linux/module.h |   15 ---------------
 kernel/module.c        |   21 +++++----------------
 net/sctp/protocol.c    |    1 -
 4 files changed, 9 insertions(+), 37 deletions(-)

diff -puN drivers/dma/iop-adma.c~remove-unsafe-from-module-struct drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~remove-unsafe-from-module-struct
+++ a/drivers/dma/iop-adma.c
@@ -1446,21 +1446,20 @@ static struct platform_driver iop_adma_d
 
 static int __init iop_adma_init (void)
 {
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
-
 	return platform_driver_register(&iop_adma_driver);
 }
 
+/* it's currently unsafe to unload this module */
+#if 0
 static void __exit iop_adma_exit (void)
 {
 	platform_driver_unregister(&iop_adma_driver);
 	return;
 }
+module_exit(iop_adma_exit);
+#endif
 
 module_init(iop_adma_init);
-module_exit(iop_adma_exit);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("IOP ADMA Engine Driver");
diff -puN include/linux/module.h~remove-unsafe-from-module-struct include/linux/module.h
--- a/include/linux/module.h~remove-unsafe-from-module-struct
+++ a/include/linux/module.h
@@ -312,9 +312,6 @@ struct module
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
-	/* Am I unsafe to unload? */
-	int unsafe;
-
 	unsigned int taints;	/* same bits as kernel:tainted */
 
 #ifdef CONFIG_GENERIC_BUG
@@ -441,16 +438,6 @@ static inline void __module_get(struct m
 	__mod ? __mod->name : "kernel";		\
 })
 
-#define __unsafe(mod)							     \
-do {									     \
-	if (mod && !(mod)->unsafe) {					     \
-		printk(KERN_WARNING					     \
-		       "Module %s cannot be unloaded due to unsafe usage in" \
-		       " %s:%u\n", (mod)->name, __FILE__, __LINE__);	     \
-		(mod)->unsafe = 1;					     \
-	}								     \
-} while(0)
-
 /* For kallsyms to ask for address resolution.  NULL means not found. */
 const char *module_address_lookup(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -518,8 +505,6 @@ static inline void module_put(struct mod
 
 #define module_name(mod) "kernel"
 
-#define __unsafe(mod)
-
 /* For kallsyms to ask for address resolution.  NULL means not found. */
 static inline const char *module_address_lookup(unsigned long addr,
 						unsigned long *symbolsize,
diff -puN kernel/module.c~remove-unsafe-from-module-struct kernel/module.c
--- a/kernel/module.c~remove-unsafe-from-module-struct
+++ a/kernel/module.c
@@ -692,8 +692,7 @@ sys_delete_module(const char __user *nam
 	}
 
 	/* If it has an init func, it must have an exit func to unload */
-	if ((mod->init != NULL && mod->exit == NULL)
-	    || mod->unsafe) {
+	if (mod->init && !mod->exit) {
 		forced = try_force_unload(flags);
 		if (!forced) {
 			/* This module can't be removed */
@@ -741,11 +740,6 @@ static void print_unload_info(struct seq
 		seq_printf(m, "%s,", use->module_which_uses->name);
 	}
 
-	if (mod->unsafe) {
-		printed_something = 1;
-		seq_printf(m, "[unsafe],");
-	}
-
 	if (mod->init != NULL && mod->exit == NULL) {
 		printed_something = 1;
 		seq_printf(m, "[permanent],");
@@ -2011,15 +2005,10 @@ sys_init_module(void __user *umod,
                    buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
 		synchronize_sched();
-		if (mod->unsafe)
-			printk(KERN_ERR "%s: module is now stuck!\n",
-			       mod->name);
-		else {
-			module_put(mod);
-			mutex_lock(&module_mutex);
-			free_module(mod);
-			mutex_unlock(&module_mutex);
-		}
+		module_put(mod);
+		mutex_lock(&module_mutex);
+		free_module(mod);
+		mutex_unlock(&module_mutex);
 		return ret;
 	}
 
diff -puN net/sctp/protocol.c~remove-unsafe-from-module-struct net/sctp/protocol.c
--- a/net/sctp/protocol.c~remove-unsafe-from-module-struct
+++ a/net/sctp/protocol.c
@@ -1228,7 +1228,6 @@ SCTP_STATIC __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;
 
-	__unsafe(THIS_MODULE);
 	status = 0;
 out:
 	return status;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-x86.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
