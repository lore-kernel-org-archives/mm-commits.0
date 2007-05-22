From: akpm@linux-foundation.org
Subject: - clean-up-the-contents-of-moduleh-and-moduleparamh.patch removed from -mm tree
Date: Tue, 22 May 2007 00:09:49 -0700
Message-ID: <200705220709.l4M79pdv029429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42372 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763832AbXEVHLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 03:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Clean up the contents of module.h and moduleparam.h
has been removed from the -mm tree.  Its filename was
     clean-up-the-contents-of-moduleh-and-moduleparamh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Clean up the contents of module.h and moduleparam.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Shift the contents of module.h and moduleparam.h so that generic
module content is exclusively in module.h, while parameter-specific
content is in moduleparam.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h      |   19 +++++++++++++------
 include/linux/moduleparam.h |   16 +++++-----------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/module.h~clean-up-the-contents-of-moduleh-and-moduleparamh include/linux/module.h
--- a/include/linux/module.h~clean-up-the-contents-of-moduleh-and-moduleparamh
+++ a/include/linux/module.h
@@ -14,7 +14,7 @@
 #include <linux/elf.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
-#include <linux/moduleparam.h>
+#include <linux/moduleparam.h>	/* In a perfect world, this wouldn't be here. */
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -87,6 +87,17 @@ extern struct module __this_module;
 #define THIS_MODULE ((struct module *)0)
 #endif
 
+#ifdef MODULE
+#define ___module_cat(a,b) __mod_ ## a ## b
+#define __module_cat(a,b) ___module_cat(a,b)
+#define __MODULE_INFO(tag, name, info)					\
+static const char __module_cat(name,__LINE__)[]				\
+  __maybe_unused							\
+  __attribute__((section(".modinfo"))) = __stringify(tag) "=" info
+#else  /* !MODULE */
+#define __MODULE_INFO(tag, name, info)
+#endif
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
@@ -129,11 +140,6 @@ extern struct module __this_module;
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 
-/* One for each parameter, describing how to use it.  Some files do
-   multiple of these per line, so can't just use MODULE_INFO. */
-#define MODULE_PARM_DESC(_parm, desc) \
-	__MODULE_INFO(parm, _parm, #_parm ":" desc)
-
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)
 
@@ -575,6 +581,7 @@ struct device_driver;
 struct module;
 
 extern struct kset module_subsys;
+struct kernel_param;
 
 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff -puN include/linux/moduleparam.h~clean-up-the-contents-of-moduleh-and-moduleparamh include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~clean-up-the-contents-of-moduleh-and-moduleparamh
+++ a/include/linux/moduleparam.h
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 /* You can override this manually, but generally this should match the
    module name. */
@@ -13,19 +14,12 @@
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif
 
-#ifdef MODULE
-#define ___module_cat(a,b) __mod_ ## a ## b
-#define __module_cat(a,b) ___module_cat(a,b)
-#define __MODULE_INFO(tag, name, info)					  \
-static const char __module_cat(name,__LINE__)[]				  \
-  __attribute_used__							  \
-  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
-#else  /* !MODULE */
-#define __MODULE_INFO(tag, name, info)
-#endif
-#define __MODULE_PARM_TYPE(name, _type)					  \
+#define __MODULE_PARM_TYPE(name, _type)			\
   __MODULE_INFO(parmtype, name##type, #name ":" _type)
 
+#define MODULE_PARM_DESC(_parm, desc)			\
+  __MODULE_INFO(parm, _parm, #_parm ":" desc)
+
 struct kernel_param;
 
 /* Returns 0, or -errno.  arg is in kp->arg. */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
documentation-fix-the-explanation-of-kconfig-files.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
clean-up-the-contents-of-moduleh-and-moduleparamh.patch
