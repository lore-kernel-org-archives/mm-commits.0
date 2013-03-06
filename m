From: akpm@linux-foundation.org
Subject: + frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:09:56 -0800
Message-ID: <20130306210956.E834A31C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46946 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3CFVJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:09:58 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so915834ggi.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:09:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad.wilk@oracle.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org


The patch titled
     Subject: frontswap: make frontswap_init use a pointer for the ops
has been added to the -mm tree.  Its filename is
     frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: frontswap: make frontswap_init use a pointer for the ops

This simplifies the code in the frontswap - we can get rid of the
'backend_registered' test and instead check against frontswap_ops.

[v1: Rebase on top of 703ba7fe5e0 (ramster->zcache move]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zcache-main.c |    8 ++---
 drivers/xen/tmem.c                   |    6 +--
 include/linux/frontswap.h            |    2 -
 mm/frontswap.c                       |   38 +++++++++++--------------
 4 files changed, 26 insertions(+), 28 deletions(-)

diff -puN drivers/staging/zcache/zcache-main.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops
+++ a/drivers/staging/zcache/zcache-main.c
@@ -1613,9 +1613,9 @@ static struct frontswap_ops zcache_front
 	.init = zcache_frontswap_init
 };
 
-struct frontswap_ops zcache_frontswap_register_ops(void)
+struct frontswap_ops *zcache_frontswap_register_ops(void)
 {
-	struct frontswap_ops old_ops =
+	struct frontswap_ops *old_ops =
 		frontswap_register_ops(&zcache_frontswap_ops);
 
 	return old_ops;
@@ -1782,7 +1782,7 @@ static int __init zcache_init(void)
 			pr_warn("%s: cleancache_ops overridden\n", namestr);
 	}
 	if (zcache_enabled && !disable_frontswap) {
-		struct frontswap_ops old_ops;
+		struct frontswap_ops *old_ops;
 
 		old_ops = zcache_frontswap_register_ops();
 		if (frontswap_has_exclusive_gets)
@@ -1794,7 +1794,7 @@ static int __init zcache_init(void)
 			namestr, frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
 #endif
-		if (old_ops.init != NULL)
+		if (old_ops != NULL)
 			pr_warn("%s: frontswap_ops overridden\n", namestr);
 	}
 	if (ramster_enabled)
diff -puN drivers/xen/tmem.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops
+++ a/drivers/xen/tmem.c
@@ -362,7 +362,7 @@ static int __init no_frontswap(char *s)
 }
 __setup("nofrontswap", no_frontswap);
 
-static struct frontswap_ops __initdata tmem_frontswap_ops = {
+static struct frontswap_ops tmem_frontswap_ops = {
 	.store = tmem_frontswap_store,
 	.load = tmem_frontswap_load,
 	.invalidate_page = tmem_frontswap_flush_page,
@@ -378,11 +378,11 @@ static int __init xen_tmem_init(void)
 #ifdef CONFIG_FRONTSWAP
 	if (tmem_enabled && use_frontswap) {
 		char *s = "";
-		struct frontswap_ops old_ops =
+		struct frontswap_ops *old_ops =
 			frontswap_register_ops(&tmem_frontswap_ops);
 
 		tmem_frontswap_poolid = -1;
-		if (old_ops.init != NULL)
+		if (old_ops)
 			s = " (WARNING: frontswap_ops overridden)";
 		printk(KERN_INFO "frontswap enabled, RAM provided by "
 				 "Xen Transcendent Memory%s\n", s);
diff -puN include/linux/frontswap.h~frontswap-make-frontswap_init-use-a-pointer-for-the-ops include/linux/frontswap.h
--- a/include/linux/frontswap.h~frontswap-make-frontswap_init-use-a-pointer-for-the-ops
+++ a/include/linux/frontswap.h
@@ -14,7 +14,7 @@ struct frontswap_ops {
 };
 
 extern bool frontswap_enabled;
-extern struct frontswap_ops
+extern struct frontswap_ops *
 	frontswap_register_ops(struct frontswap_ops *ops);
 extern void frontswap_shrink(unsigned long);
 extern unsigned long frontswap_curr_pages(void);
diff -puN mm/frontswap.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops mm/frontswap.c
--- a/mm/frontswap.c~frontswap-make-frontswap_init-use-a-pointer-for-the-ops
+++ a/mm/frontswap.c
@@ -24,7 +24,7 @@
  * frontswap_ops is set by frontswap_register_ops to contain the pointers
  * to the frontswap "backend" implementation functions.
  */
-static struct frontswap_ops frontswap_ops __read_mostly;
+static struct frontswap_ops *frontswap_ops __read_mostly;
 
 /*
  * This global enablement flag reduces overhead on systems where frontswap_ops
@@ -108,41 +108,39 @@ static inline void inc_frontswap_invalid
  *
  * The time between the backend being registered and the swap file system
  * calling the backend (via the frontswap_* functions) is indeterminate as
- * backend_registered is not atomic_t (or a value guarded by a spinlock).
+ * frontswap_ops is not atomic_t (or a value guarded by a spinlock).
  * That is OK as we are comfortable missing some of these calls to the newly
  * registered backend.
  *
  * Obviously the opposite (unloading the backend) must be done after all
  * the frontswap_[store|load|invalidate_area|invalidate_page] start
- * ignorning or failing the requests - at which point backend_registered
+ * ignorning or failing the requests - at which point frontswap_ops
  * would have to be made in some fashion atomic.
  */
 static DECLARE_BITMAP(need_init, MAX_SWAPFILES);
-static bool backend_registered __read_mostly;
 
 /*
  * Register operations for frontswap, returning previous thus allowing
  * detection of multiple backends and possible nesting.
  */
-struct frontswap_ops frontswap_register_ops(struct frontswap_ops *ops)
+struct frontswap_ops *frontswap_register_ops(struct frontswap_ops *ops)
 {
-	struct frontswap_ops old = frontswap_ops;
+	struct frontswap_ops *old = frontswap_ops;
 	int i;
 
-	frontswap_ops = *ops;
 	frontswap_enabled = true;
 
 	for (i = 0; i < MAX_SWAPFILES; i++) {
 		if (test_and_clear_bit(i, need_init))
-			(*frontswap_ops.init)(i);
+			ops->init(i);
 	}
 	/*
-	 * We MUST have backend_registered set _after_ the frontswap_init's
+	 * We MUST have frontswap_ops set _after_ the frontswap_init's
 	 * have been called. Otherwise __frontswap_store might fail. Hence
 	 * the barrier to make sure compiler does not re-order us.
 	 */
 	barrier();
-	backend_registered = true;
+	frontswap_ops = ops;
 	return old;
 }
 EXPORT_SYMBOL(frontswap_register_ops);
@@ -172,11 +170,11 @@ void __frontswap_init(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	if (backend_registered) {
+	if (frontswap_ops) {
 		BUG_ON(sis == NULL);
 		if (sis->frontswap_map == NULL)
 			return;
-		(*frontswap_ops.init)(type);
+		frontswap_ops->init(type);
 	} else {
 		BUG_ON(type > MAX_SWAPFILES);
 		set_bit(type, need_init);
@@ -206,7 +204,7 @@ int __frontswap_store(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
-	if (!backend_registered) {
+	if (!frontswap_ops) {
 		inc_frontswap_failed_stores();
 		return ret;
 	}
@@ -215,7 +213,7 @@ int __frontswap_store(struct page *page)
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
 		dup = 1;
-	ret = frontswap_ops.store(type, offset, page);
+	ret = frontswap_ops->store(type, offset, page);
 	if (ret == 0) {
 		frontswap_set(sis, offset);
 		inc_frontswap_succ_stores();
@@ -250,13 +248,13 @@ int __frontswap_load(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
-	if (!backend_registered)
+	if (!frontswap_ops)
 		return ret;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
-		ret = frontswap_ops.load(type, offset, page);
+		ret = frontswap_ops->load(type, offset, page);
 	if (ret == 0) {
 		inc_frontswap_loads();
 		if (frontswap_tmem_exclusive_gets_enabled) {
@@ -276,12 +274,12 @@ void __frontswap_invalidate_page(unsigne
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	if (!backend_registered)
+	if (!frontswap_ops)
 		return;
 
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset)) {
-		frontswap_ops.invalidate_page(type, offset);
+		frontswap_ops->invalidate_page(type, offset);
 		__frontswap_clear(sis, offset);
 		inc_frontswap_invalidates();
 	}
@@ -296,11 +294,11 @@ void __frontswap_invalidate_area(unsigne
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	if (backend_registered) {
+	if (frontswap_ops) {
 		BUG_ON(sis == NULL);
 		if (sis->frontswap_map == NULL)
 			return;
-		(*frontswap_ops.invalidate_area)(type);
+		frontswap_ops->invalidate_area(type);
 		atomic_set(&sis->frontswap_pages, 0);
 		memset(sis->frontswap_map, 0, sis->max / sizeof(long));
 	}
_

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
linux-next.patch
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

