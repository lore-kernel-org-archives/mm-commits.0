From: akpm@linux-foundation.org
Subject: + remove-unsafe-from-module-struct.patch added to -mm tree
Date: Tue, 24 Jul 2007 16:54:18 -0700
Message-ID: <200707242354.l6ONsIrV007439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbXGXXyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:54:46 -0400
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

(Vlad Yasevich says SCTP is now safe to unload, so just remove the
__unsafe there).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat.c     |    3 ---
 drivers/dma/iop-adma.c |    9 ++++-----
 include/linux/module.h |   15 ---------------
 kernel/module.c        |   21 +++++----------------
 net/sctp/protocol.c    |    1 -
 5 files changed, 9 insertions(+), 40 deletions(-)

diff -puN drivers/dma/ioat.c~remove-unsafe-from-module-struct drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~remove-unsafe-from-module-struct
+++ a/drivers/dma/ioat.c
@@ -182,9 +182,6 @@ static void __devexit ioat_remove(struct
 
 static int __init ioat_init_module(void)
 {
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
 	return pci_register_driver(&ioat_pci_drv);
 }
 module_init(ioat_init_module);
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
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
lguest-documentation-i-preparation.patch
lguest-documentation-ii-guest.patch
lguest-documentation-iii-drivers.patch
lguest-documentation-iv-launcher.patch
lguest-documentation-v-host.patch
lguest-documentation-vi-switcher.patch
lguest-documentation-vii-fixmes.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
