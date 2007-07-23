From: akpm@linux-foundation.org
Subject: + remove-unsafe-from-module-struct.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:30:51 -0700
Message-ID: <200707232330.l6NNUpXZ017660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbXGWXbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, bunk@stusta.de, dan.j.williams@intel.com, shannon.nelson@intel.com, sri@us.ibm.com, vladislav.yasevich@hp.com


The patch titled
     Remove "unsafe" from module struct
has been added to the -mm tree.  Its filename is
     remove-unsafe-from-module-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove "unsafe" from module struct
From: Rusty Russell <rusty@rustcorp.com.au>

Adrian Bunk points out that "unsafe" was used to mark modules touched by
the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's time
to remove the member from the module structure, as well.

If you want a module which can't unload, don't register an exit function.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c  |    7 +++----
 drivers/dma/iop-adma.c |    9 ++++-----
 include/linux/module.h |   15 ---------------
 kernel/module.c        |   21 +++++----------------
 net/sctp/protocol.c    |    5 +++--
 5 files changed, 15 insertions(+), 42 deletions(-)

diff -puN drivers/dma/ioatdma.c~remove-unsafe-from-module-struct drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~remove-unsafe-from-module-struct
+++ a/drivers/dma/ioatdma.c
@@ -811,18 +811,17 @@ MODULE_AUTHOR("Intel Corporation");
 
 static int __init ioat_init_module(void)
 {
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
-
 	return pci_register_driver(&ioat_pci_driver);
 }
 
 module_init(ioat_init_module);
 
+/* it's currently unsafe to unload this module */
+#if 0
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
 }
 
 module_exit(ioat_exit_module);
+#endif
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
@@ -328,9 +328,6 @@ struct module
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
-	/* Am I unsafe to unload? */
-	int unsafe;
-
 	unsigned int taints;	/* same bits as kernel:tainted */
 
 #ifdef CONFIG_GENERIC_BUG
@@ -457,16 +454,6 @@ static inline void __module_get(struct m
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
@@ -534,8 +521,6 @@ static inline void module_put(struct mod
 
 #define module_name(mod) "kernel"
 
-#define __unsafe(mod)
-
 /* For kallsyms to ask for address resolution.  NULL means not found. */
 static inline const char *module_address_lookup(unsigned long addr,
 						unsigned long *symbolsize,
diff -puN kernel/module.c~remove-unsafe-from-module-struct kernel/module.c
--- a/kernel/module.c~remove-unsafe-from-module-struct
+++ a/kernel/module.c
@@ -693,8 +693,7 @@ sys_delete_module(const char __user *nam
 	}
 
 	/* If it has an init func, it must have an exit func to unload */
-	if ((mod->init != NULL && mod->exit == NULL)
-	    || mod->unsafe) {
+	if (mod->init && !mod->exit) {
 		forced = try_force_unload(flags);
 		if (!forced) {
 			/* This module can't be removed */
@@ -753,11 +752,6 @@ static void print_unload_info(struct seq
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
@@ -2074,15 +2068,10 @@ sys_init_module(void __user *umod,
 				mod);
 		up(&notify_mutex);
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
@@ -1176,7 +1176,6 @@ SCTP_STATIC __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;
 
-	__unsafe(THIS_MODULE);
 	status = 0;
 out:
 	return status;
@@ -1216,6 +1215,7 @@ err_chunk_cachep:
 	goto out;
 }
 
+#if 0
 /* Exit handler for the SCTP protocol.  */
 SCTP_STATIC __exit void sctp_exit(void)
 {
@@ -1263,9 +1263,10 @@ SCTP_STATIC __exit void sctp_exit(void)
 
 	proto_unregister(&sctp_prot);
 }
+module_exit(sctp_exit);
+#endif
 
 module_init(sctp_init);
-module_exit(sctp_exit);
 
 /*
  * __stringify doesn't likes enums, so use IPPROTO_SCTP value (132) directly.
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

resend-link-lguest-example-launcher-non-static.patch
git-kvm.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
