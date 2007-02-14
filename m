From: akpm@linux-foundation.org
Subject: + build-errors-uevent-with-config_sysfs=n.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:37:32 -0800
Message-ID: <200702142237.l1EMbWgO011494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbXBNWhi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:37:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     build errors: uevent with CONFIG_SYSFS=n
has been added to the -mm tree.  Its filename is
     build-errors-uevent-with-config_sysfs=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: build errors: uevent with CONFIG_SYSFS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix source files to build with CONFIG_SYSFS=n.  module_subsys is not
available.

SYSFS=n, MODULES=y:	T:y
SYSFS=n, MODULES=n:	T:y

SYSFS=y, MODULES=y:	T:y
SYSFS=y, MODULES=n:	T:y

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h      |   53 ++++++++++++++++++++++++++++------
 include/linux/moduleparam.h |   12 +++++++
 kernel/module.c             |   14 ++++++--
 kernel/params.c             |   28 +++++++++--------
 4 files changed, 81 insertions(+), 26 deletions(-)

diff -puN include/linux/module.h~build-errors-uevent-with-config_sysfs=n include/linux/module.h
--- a/include/linux/module.h~build-errors-uevent-with-config_sysfs=n
+++ a/include/linux/module.h
@@ -76,8 +76,6 @@ void sort_extable(struct exception_table
 		  struct exception_table_entry *finish);
 void sort_main_extable(void);
 
-extern struct subsystem module_subsys;
-
 #ifdef MODULE
 #define MODULE_GENERIC_TABLE(gtype,name)			\
 extern const struct gtype##_id __mod_##gtype##_table		\
@@ -467,10 +465,6 @@ int unregister_module_notifier(struct no
 
 extern void print_modules(void);
 
-struct device_driver;
-void module_add_driver(struct module *, struct device_driver *);
-void module_remove_driver(struct device_driver *);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -568,18 +562,59 @@ static inline void print_modules(void)
 {
 }
 
+#endif /* CONFIG_MODULES */
+
 struct device_driver;
+#ifdef CONFIG_SYSFS
 struct module;
 
-static inline void module_add_driver(struct module *module, struct device_driver *driver)
+extern struct subsystem module_subsys;
+
+int mod_sysfs_init(struct module *mod);
+int mod_sysfs_setup(struct module *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params);
+int module_add_modinfo_attrs(struct module *mod);
+void module_remove_modinfo_attrs(struct module *mod);
+
+#else /* !CONFIG_SYSFS */
+
+static inline int mod_sysfs_init(struct module *mod)
 {
+	return 0;
 }
 
-static inline void module_remove_driver(struct device_driver *driver)
+static inline int mod_sysfs_setup(struct module *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params)
 {
+	return 0;
 }
 
-#endif /* CONFIG_MODULES */
+static inline int module_add_modinfo_attrs(struct module *mod)
+{
+	return 0;
+}
+
+static inline void module_remove_modinfo_attrs(struct module *mod)
+{ }
+
+#endif /* CONFIG_SYSFS */
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
+
+void module_add_driver(struct module *mod, struct device_driver *drv);
+void module_remove_driver(struct device_driver *drv);
+
+#else /* not both CONFIG_SYSFS && CONFIG_MODULES */
+
+static inline void module_add_driver(struct module *mod, struct device_driver *drv)
+{ }
+
+static inline void module_remove_driver(struct device_driver *drv)
+{ }
+
+#endif
 
 #define symbol_request(x) try_then_request_module(symbol_get(x), "symbol:" #x)
 
diff -puN include/linux/moduleparam.h~build-errors-uevent-with-config_sysfs=n include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~build-errors-uevent-with-config_sysfs=n
+++ a/include/linux/moduleparam.h
@@ -169,10 +169,22 @@ extern int param_get_string(char *buffer
 
 struct module;
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
 extern int module_param_sysfs_setup(struct module *mod,
 				    struct kernel_param *kparam,
 				    unsigned int num_params);
 
 extern void module_param_sysfs_remove(struct module *mod);
+#else
+static inline int module_param_sysfs_setup(struct module *mod,
+			     struct kernel_param *kparam,
+			     unsigned int num_params)
+{
+	return 0;
+}
+
+static inline void module_param_sysfs_remove(struct module *mod)
+{ }
+#endif
 
 #endif /* _LINUX_MODULE_PARAMS_H */
diff -puN kernel/module.c~build-errors-uevent-with-config_sysfs=n kernel/module.c
--- a/kernel/module.c~build-errors-uevent-with-config_sysfs=n
+++ a/kernel/module.c
@@ -1068,7 +1068,8 @@ static inline void remove_sect_attrs(str
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int module_add_modinfo_attrs(struct module *mod)
+#ifdef CONFIG_SYSFS
+int module_add_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
 	struct module_attribute *temp_attr;
@@ -1094,7 +1095,7 @@ static int module_add_modinfo_attrs(stru
 	return error;
 }
 
-static void module_remove_modinfo_attrs(struct module *mod)
+void module_remove_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
 	int i;
@@ -1109,8 +1110,10 @@ static void module_remove_modinfo_attrs(
 	}
 	kfree(mod->modinfo_attrs);
 }
+#endif
 
-static int mod_sysfs_init(struct module *mod)
+#ifdef CONFIG_SYSFS
+int mod_sysfs_init(struct module *mod)
 {
 	int err;
 
@@ -1133,7 +1136,7 @@ out:
 	return err;
 }
 
-static int mod_sysfs_setup(struct module *mod,
+int mod_sysfs_setup(struct module *mod,
 			   struct kernel_param *kparam,
 			   unsigned int num_params)
 {
@@ -1169,6 +1172,7 @@ out_unreg:
 out:
 	return err;
 }
+#endif
 
 static void mod_kobject_remove(struct module *mod)
 {
@@ -2345,6 +2349,7 @@ void print_modules(void)
 	printk("\n");
 }
 
+#ifdef CONFIG_SYSFS
 static char *make_driver_name(struct device_driver *drv)
 {
 	char *driver_name;
@@ -2419,6 +2424,7 @@ void module_remove_driver(struct device_
 	}
 }
 EXPORT_SYMBOL(module_remove_driver);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 /* Generate the signature for struct module here, too, for modversions. */
diff -puN kernel/params.c~build-errors-uevent-with-config_sysfs=n kernel/params.c
--- a/kernel/params.c~build-errors-uevent-with-config_sysfs=n
+++ a/kernel/params.c
@@ -30,8 +30,6 @@
 #define DEBUGP(fmt, a...)
 #endif
 
-static struct kobj_type module_ktype;
-
 static inline char dash2underscore(char c)
 {
 	if (c == '-')
@@ -391,6 +389,7 @@ struct module_param_attrs
 	struct param_attribute attrs[0];
 };
 
+#ifdef CONFIG_SYSFS
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr);
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
@@ -426,6 +425,7 @@ static ssize_t param_attr_store(struct m
 		return len;
 	return err;
 }
+#endif
 
 #ifdef CONFIG_MODULES
 #define __modinit
@@ -433,6 +433,7 @@ static ssize_t param_attr_store(struct m
 #define __modinit __init
 #endif
 
+#ifdef CONFIG_SYSFS
 /*
  * param_sysfs_setup - setup sysfs support for one module or KBUILD_MODNAME
  * @mk: struct module_kobject (contains parent kobject)
@@ -500,9 +501,7 @@ param_sysfs_setup(struct module_kobject 
 	return mp;
 }
 
-
 #ifdef CONFIG_MODULES
-
 /*
  * module_param_sysfs_setup - setup sysfs support for one module
  * @mod: module
@@ -625,7 +624,6 @@ static void __init param_sysfs_builtin(v
 
 
 /* module-related sysfs stuff */
-#ifdef CONFIG_SYSFS
 
 #define to_module_attr(n) container_of(n, struct module_attribute, attr);
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
@@ -673,6 +671,8 @@ static struct sysfs_ops module_sysfs_ops
 	.store = module_attr_store,
 };
 
+static struct kobj_type module_ktype;
+
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
 {
 	struct kobj_type *ktype = get_ktype(kobj);
@@ -686,19 +686,12 @@ static struct kset_uevent_ops module_uev
 	.filter = uevent_filter,
 };
 
-#else
-static struct sysfs_ops module_sysfs_ops = {
-	.show = NULL,
-	.store = NULL,
-};
-#endif
+decl_subsys(module, &module_ktype, &module_uevent_ops);
 
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
 };
 
-decl_subsys(module, &module_ktype, &module_uevent_ops);
-
 /*
  * param_sysfs_init - wrapper for built-in params support
  */
@@ -719,6 +712,15 @@ static int __init param_sysfs_init(void)
 }
 subsys_initcall(param_sysfs_init);
 
+#else
+#if 0
+static struct sysfs_ops module_sysfs_ops = {
+	.show = NULL,
+	.store = NULL,
+};
+#endif
+#endif
+
 EXPORT_SYMBOL(param_set_byte);
 EXPORT_SYMBOL(param_get_byte);
 EXPORT_SYMBOL(param_set_short);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
build-errors-uevent-with-config_sysfs=n.patch
git-drm.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
