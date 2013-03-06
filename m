From: akpm@linux-foundation.org
Subject: + staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:10:22 -0800
Message-ID: <20130306211022.EFD8131C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51787 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3CFVKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:10:24 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so915981ggi.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:10:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.magenheimer@oracle.com, andor.daam@googlemail.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org


The patch titled
     Subject: staging: zcache: enable zcache to be built/loaded as a module
has been added to the -mm tree.  Its filename is
     staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch

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
Subject: staging: zcache: enable zcache to be built/loaded as a module

Allow zcache to be built/loaded as a module.  Note runtime dependency
disallows loading if cleancache/frontswap lazy initialization patches are
not present.  Zsmalloc support has not yet been merged into zcache but,
once merged, could now easily be selected via a module_param.

If built-in (not built as a module), the original mechanism of enabling via
a kernel boot parameter is retained, but this should be considered deprecated.

Note that module unload is explicitly not yet supported.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
[v1: Rebased with different order of patches]
[v2: Removed [CLEANCACHE|FRONTSWAP]_HAS_LAZY_INIT ifdef]
[v3: Rebased on top of ramster->zcache move]
[v4: Redid the Makefile]
[v5: s/ZCACHE2/ZCACHE/]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/Kconfig       |    6 +--
 drivers/staging/zcache/tmem.c        |    6 ++-
 drivers/staging/zcache/tmem.h        |    8 ++--
 drivers/staging/zcache/zcache-main.c |   45 +++++++++++++++++++++++--
 drivers/staging/zcache/zcache.h      |    2 -
 5 files changed, 55 insertions(+), 12 deletions(-)

diff -puN drivers/staging/zcache/Kconfig~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module drivers/staging/zcache/Kconfig
--- a/drivers/staging/zcache/Kconfig~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/Kconfig
@@ -1,5 +1,5 @@
 config ZCACHE
-	bool "Dynamic compression of swap pages and clean pagecache pages"
+	tristate "Dynamic compression of swap pages and clean pagecache pages"
 	depends on CRYPTO=y && SWAP=y && CLEANCACHE && FRONTSWAP
 	select CRYPTO_LZO
 	default n
@@ -19,8 +19,8 @@ config ZCACHE_DEBUG
 	  how zcache is doing. You probably want to set this to 'N'.
 
 config RAMSTER
-	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE=y
+	tristate "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
+	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE
 	depends on NET
 	# must ensure struct page is 8-byte aligned
 	select HAVE_ALIGNED_STRUCT_PAGE if !64_BIT
diff -puN drivers/staging/zcache/tmem.c~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module drivers/staging/zcache/tmem.c
--- a/drivers/staging/zcache/tmem.c~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/tmem.c
@@ -35,7 +35,8 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
-#ifdef CONFIG_RAMSTER
+#include <linux/export.h>
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 #include <linux/delay.h>
 #endif
 
@@ -641,6 +642,7 @@ void *tmem_localify_get_pampd(struct tme
 	/* note, hashbucket remains locked */
 	return pampd;
 }
+EXPORT_SYMBOL_GPL(tmem_localify_get_pampd);
 
 void tmem_localify_finish(struct tmem_obj *obj, uint32_t index,
 			  void *pampd, void *saved_hb, bool delete)
@@ -658,6 +660,7 @@ void tmem_localify_finish(struct tmem_ob
 	}
 	spin_unlock(&hb->lock);
 }
+EXPORT_SYMBOL_GPL(tmem_localify_finish);
 
 /*
  * For ramster only.  Helper function to support asynchronous tmem_get.
@@ -719,6 +722,7 @@ out:
 	spin_unlock(&hb->lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(tmem_replace);
 #endif
 
 /*
diff -puN drivers/staging/zcache/tmem.h~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module drivers/staging/zcache/tmem.h
--- a/drivers/staging/zcache/tmem.h~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/tmem.h
@@ -126,7 +126,7 @@ static inline unsigned tmem_oid_hash(str
 				TMEM_HASH_BUCKET_BITS);
 }
 
-#ifdef CONFIG_RAMSTER
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 struct tmem_xhandle {
 	uint8_t client_id;
 	uint8_t xh_data_cksum;
@@ -171,7 +171,7 @@ struct tmem_obj {
 	unsigned int objnode_tree_height;
 	unsigned long objnode_count;
 	long pampd_count;
-#ifdef CONFIG_RAMSTER
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 	/*
 	 * for current design of ramster, all pages belonging to
 	 * an object reside on the same remotenode and extra is
@@ -215,7 +215,7 @@ struct tmem_pamops {
 				uint32_t);
 	void (*free)(void *, struct tmem_pool *,
 				struct tmem_oid *, uint32_t, bool);
-#ifdef CONFIG_RAMSTER
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 	void (*new_obj)(struct tmem_obj *);
 	void (*free_obj)(struct tmem_pool *, struct tmem_obj *, bool);
 	void *(*repatriate_preload)(void *, struct tmem_pool *,
@@ -247,7 +247,7 @@ extern int tmem_flush_page(struct tmem_p
 extern int tmem_flush_object(struct tmem_pool *, struct tmem_oid *);
 extern int tmem_destroy_pool(struct tmem_pool *);
 extern void tmem_new_pool(struct tmem_pool *, uint32_t);
-#ifdef CONFIG_RAMSTER
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 extern int tmem_replace(struct tmem_pool *, struct tmem_oid *, uint32_t index,
 			void *);
 extern void *tmem_localify_get_pampd(struct tmem_pool *, struct tmem_oid *,
diff -puN drivers/staging/zcache/zcache-main.c~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/zcache-main.c
@@ -36,8 +36,10 @@
 #include "debug.h"
 #ifdef CONFIG_RAMSTER
 static bool ramster_enabled __read_mostly;
+static int disable_frontswap_selfshrink;
 #else
 #define ramster_enabled false
+#define disable_frontswap_selfshrink 0
 #endif
 
 #ifndef __PG_WAS_ACTIVE
@@ -74,8 +76,12 @@ static char *namestr __read_mostly = "zc
 	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
 
 /* crypto API for zcache  */
+#ifdef CONFIG_ZCACHE_MODULE
+static char *zcache_comp_name = "lzo";
+#else
 #define ZCACHE_COMP_NAME_SZ CRYPTO_MAX_ALG_NAME
 static char zcache_comp_name[ZCACHE_COMP_NAME_SZ] __read_mostly;
+#endif
 static struct crypto_comp * __percpu *zcache_comp_pcpu_tfms __read_mostly;
 
 enum comp_op {
@@ -1627,6 +1633,7 @@ struct frontswap_ops *zcache_frontswap_r
  * OR NOTHING HAPPENS!
  */
 
+#ifndef CONFIG_ZCACHE_MODULE
 static int __init enable_zcache(char *s)
 {
 	zcache_enabled = true;
@@ -1693,18 +1700,27 @@ static int __init enable_zcache_compress
 	return 1;
 }
 __setup("zcache=", enable_zcache_compressor);
+#endif
 
 
-static int __init zcache_comp_init(void)
+static int zcache_comp_init(void)
 {
 	int ret = 0;
 
 	/* check crypto algorithm */
+#ifdef CONFIG_ZCACHE_MODULE
+	ret = crypto_has_comp(zcache_comp_name, 0, 0);
+	if (!ret) {
+		ret = -1;
+		goto out;
+	}
+#else
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
 		if (!ret)
 			pr_info("zcache: %s not supported\n",
 					zcache_comp_name);
+		goto out;
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
@@ -1713,6 +1729,7 @@ static int __init zcache_comp_init(void)
 		ret = 1;
 		goto out;
 	}
+#endif
 	pr_info("zcache: using %s compressor\n", zcache_comp_name);
 
 	/* alloc percpu transforms */
@@ -1724,10 +1741,13 @@ out:
 	return ret;
 }
 
-static int __init zcache_init(void)
+static int zcache_init(void)
 {
 	int ret = 0;
 
+#ifdef CONFIG_ZCACHE_MODULE
+	zcache_enabled = 1;
+#endif
 	if (ramster_enabled) {
 		namestr = "ramster";
 		ramster_register_pamops(&zcache_pamops);
@@ -1802,9 +1822,28 @@ static int __init zcache_init(void)
 	}
 	if (ramster_enabled)
 		ramster_init(!disable_cleancache, !disable_frontswap,
-				frontswap_has_exclusive_gets, false);
+				frontswap_has_exclusive_gets,
+				!disable_frontswap_selfshrink);
 out:
 	return ret;
 }
 
+#ifdef CONFIG_ZCACHE_MODULE
+#ifdef CONFIG_RAMSTER
+module_param(ramster_enabled, int, S_IRUGO);
+module_param(disable_frontswap_selfshrink, int, S_IRUGO);
+#endif
+module_param(disable_cleancache, int, S_IRUGO);
+module_param(disable_frontswap, int, S_IRUGO);
+#ifdef FRONTSWAP_HAS_EXCLUSIVE_GETS
+module_param(frontswap_has_exclusive_gets, bool, S_IRUGO);
+#endif
+module_param(disable_frontswap_ignore_nonactive, int, S_IRUGO);
+module_param(zcache_comp_name, charp, S_IRUGO);
+module_init(zcache_init);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Magenheimer <dan.magenheimer@oracle.com>");
+MODULE_DESCRIPTION("In-kernel compression of cleancache/frontswap pages");
+#else
 late_initcall(zcache_init);
+#endif
diff -puN drivers/staging/zcache/zcache.h~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module drivers/staging/zcache/zcache.h
--- a/drivers/staging/zcache/zcache.h~staging-zcache-enable-zcache-to-be-built-loaded-as-a-module
+++ a/drivers/staging/zcache/zcache.h
@@ -39,7 +39,7 @@ extern int zcache_flush_page(int, int, s
 extern int zcache_flush_object(int, int, struct tmem_oid *);
 extern void zcache_decompress_to_page(char *, unsigned int, struct page *);
 
-#ifdef CONFIG_RAMSTER
+#if defined(CONFIG_RAMSTER) || defined(CONFIG_RAMSTER_MODULE)
 extern void *zcache_pampd_create(char *, unsigned int, bool, int,
 				struct tmem_handle *);
 int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph);
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

