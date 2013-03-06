From: akpm@linux-foundation.org
Subject: + xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:10:13 -0800
Message-ID: <20130306211013.ED66831C241@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:62556 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3CFVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:10:18 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so916011ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:10:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.magenheimer@oracle.com, andor.daam@googlemail.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org


The patch titled
     Subject: xen: tmem: enable Xen tmem shim to be built/loaded as a module
has been added to the -mm tree.  Its filename is
     xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: xen: tmem: enable Xen tmem shim to be built/loaded as a module

Allow Xen tmem shim to be built/loaded as a module.  Xen self-ballooning
and frontswap-selfshrinking are now also "lazily" initialized when the Xen
tmem shim is loaded as a module, unless explicitly disabled by module
parameters.

Note runtime dependency disallows loading if cleancache/frontswap lazy
initialization patches are not present.

If built-in (not built as a module), the original mechanism of enabling via
a kernel boot parameter is retained, but this should be considered deprecated.

Note that module unload is explicitly not yet supported.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
[v1: Removed the [CLEANCACHE|FRONTSWAP]_HAS_LAZY_INIT ifdef]
[v2: Squashed the xen/tmem: Remove the subsys call patch in]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/Kconfig           |    4 +--
 drivers/xen/tmem.c            |   38 ++++++++++++++++++++++++--------
 drivers/xen/xen-selfballoon.c |   13 ++++------
 include/xen/tmem.h            |    8 ++++++
 4 files changed, 44 insertions(+), 19 deletions(-)

diff -puN drivers/xen/Kconfig~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module
+++ a/drivers/xen/Kconfig
@@ -145,9 +145,9 @@ config SWIOTLB_XEN
 	select SWIOTLB
 
 config XEN_TMEM
-	bool
+	tristate
 	depends on !ARM
-	default y if (CLEANCACHE || FRONTSWAP)
+	default m if (CLEANCACHE || FRONTSWAP)
 	help
 	  Shim to interface in-kernel Transcendent Memory hooks
 	  (e.g. cleancache and frontswap) to Xen tmem hypercalls.
diff -puN drivers/xen/tmem.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module
+++ a/drivers/xen/tmem.c
@@ -5,6 +5,7 @@
  * Author: Dan Magenheimer
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -128,6 +129,7 @@ static int xen_tmem_flush_object(u32 poo
 	return xen_tmem_op(TMEM_FLUSH_OBJECT, pool_id, oid, 0, 0, 0, 0, 0);
 }
 
+#ifndef CONFIG_XEN_TMEM_MODULE
 bool __read_mostly tmem_enabled = false;
 
 static int __init enable_tmem(char *s)
@@ -136,6 +138,7 @@ static int __init enable_tmem(char *s)
 	return 1;
 }
 __setup("tmem", enable_tmem);
+#endif
 
 #ifdef CONFIG_CLEANCACHE
 static int xen_tmem_destroy_pool(u32 pool_id)
@@ -227,14 +230,19 @@ static int tmem_cleancache_init_shared_f
 	return xen_tmem_new_pool(shared_uuid, TMEM_POOL_SHARED, pagesize);
 }
 
-static bool __initdata use_cleancache = true;
-
+static bool disable_cleancache __read_mostly;
+static bool disable_selfballooning __read_mostly;
+#ifdef CONFIG_XEN_TMEM_MODULE
+module_param(disable_cleancache, bool, S_IRUGO);
+module_param(disable_selfballooning, bool, S_IRUGO);
+#else
 static int __init no_cleancache(char *s)
 {
-	use_cleancache = false;
+	disable_cleancache = true;
 	return 1;
 }
 __setup("nocleancache", no_cleancache);
+#endif
 
 static struct cleancache_ops tmem_cleancache_ops = {
 	.put_page = tmem_cleancache_put_page,
@@ -353,14 +361,19 @@ static void tmem_frontswap_init(unsigned
 		    xen_tmem_new_pool(private, TMEM_POOL_PERSIST, PAGE_SIZE);
 }
 
-static bool __initdata use_frontswap = true;
-
+static bool disable_frontswap __read_mostly;
+static bool disable_frontswap_selfshrinking __read_mostly;
+#ifdef CONFIG_XEN_TMEM_MODULE
+module_param(disable_frontswap, bool, S_IRUGO);
+module_param(disable_frontswap_selfshrinking, bool, S_IRUGO);
+#else
 static int __init no_frontswap(char *s)
 {
-	use_frontswap = false;
+	disable_frontswap = true;
 	return 1;
 }
 __setup("nofrontswap", no_frontswap);
+#endif
 
 static struct frontswap_ops tmem_frontswap_ops = {
 	.store = tmem_frontswap_store,
@@ -371,12 +384,12 @@ static struct frontswap_ops tmem_frontsw
 };
 #endif
 
-static int __init xen_tmem_init(void)
+static int xen_tmem_init(void)
 {
 	if (!xen_domain())
 		return 0;
 #ifdef CONFIG_FRONTSWAP
-	if (tmem_enabled && use_frontswap) {
+	if (tmem_enabled && !disable_frontswap) {
 		char *s = "";
 		struct frontswap_ops *old_ops =
 			frontswap_register_ops(&tmem_frontswap_ops);
@@ -390,7 +403,7 @@ static int __init xen_tmem_init(void)
 #endif
 #ifdef CONFIG_CLEANCACHE
 	BUG_ON(sizeof(struct cleancache_filekey) != sizeof(struct tmem_oid));
-	if (tmem_enabled && use_cleancache) {
+	if (tmem_enabled && !disable_cleancache) {
 		char *s = "";
 		struct cleancache_ops *old_ops =
 			cleancache_register_ops(&tmem_cleancache_ops);
@@ -400,7 +413,14 @@ static int __init xen_tmem_init(void)
 				 "Xen Transcendent Memory%s\n", s);
 	}
 #endif
+#ifdef CONFIG_XEN_SELFBALLOONING
+	xen_selfballoon_init(!disable_selfballooning,
+				!disable_frontswap_selfshrinking);
+#endif
 	return 0;
 }
 
 module_init(xen_tmem_init)
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Magenheimer <dan.magenheimer@oracle.com>");
+MODULE_DESCRIPTION("Shim to Xen transcendent memory");
diff -puN drivers/xen/xen-selfballoon.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module drivers/xen/xen-selfballoon.c
--- a/drivers/xen/xen-selfballoon.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module
+++ a/drivers/xen/xen-selfballoon.c
@@ -121,7 +121,7 @@ static DECLARE_DELAYED_WORK(selfballoon_
 static bool frontswap_selfshrinking __read_mostly;
 
 /* Enable/disable with kernel boot option. */
-static bool use_frontswap_selfshrink __initdata = true;
+static bool use_frontswap_selfshrink = true;
 
 /*
  * The default values for the following parameters were deemed reasonable
@@ -185,7 +185,7 @@ static int __init xen_nofrontswap_selfsh
 __setup("noselfshrink", xen_nofrontswap_selfshrink_setup);
 
 /* Disable with kernel boot option. */
-static bool use_selfballooning __initdata = true;
+static bool use_selfballooning = true;
 
 static int __init xen_noselfballooning_setup(char *s)
 {
@@ -196,7 +196,7 @@ static int __init xen_noselfballooning_s
 __setup("noselfballooning", xen_noselfballooning_setup);
 #else /* !CONFIG_FRONTSWAP */
 /* Enable with kernel boot option. */
-static bool use_selfballooning __initdata = false;
+static bool use_selfballooning;
 
 static int __init xen_selfballooning_setup(char *s)
 {
@@ -537,7 +537,7 @@ int register_xen_selfballooning(struct d
 }
 EXPORT_SYMBOL(register_xen_selfballooning);
 
-static int __init xen_selfballoon_init(void)
+int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 {
 	bool enable = false;
 
@@ -571,7 +571,4 @@ static int __init xen_selfballoon_init(v
 
 	return 0;
 }
-
-subsys_initcall(xen_selfballoon_init);
-
-MODULE_LICENSE("GPL");
+EXPORT_SYMBOL(xen_selfballoon_init);
diff -puN include/xen/tmem.h~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module include/xen/tmem.h
--- a/include/xen/tmem.h~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module
+++ a/include/xen/tmem.h
@@ -3,7 +3,15 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_XEN_TMEM_MODULE
+#define tmem_enabled true
+#else
 /* defined in drivers/xen/tmem.c */
 extern bool tmem_enabled;
+#endif
+
+#ifdef CONFIG_XEN_SELFBALLOONING
+extern int xen_selfballoon_init(bool, bool);
+#endif
 
 #endif /* _XEN_TMEM_H */
_

Patches currently in -mm which might be from dan.magenheimer@oracle.com are

linux-next.patch
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
frontswap-get-rid-of-swap_lock-dependency.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
zcache-convert-to-idr_alloc.patch

