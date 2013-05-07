From: akpm@linux-foundation.org
Subject: [merged] mm-frontswap-cleanup-code.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:27 -0700
Message-ID: <20130507174627.8C2C35A42A7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43714 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3EGRq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:28 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so85017yen.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: frontswap: cleanup code
has been removed from the -mm tree.  Its filename was
     mm-frontswap-cleanup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: frontswap: cleanup code

After allowing tmem backends to build/run as modules, frontswap_enabled
always true if defined CONFIG_FRONTSWAP.  But frontswap_test() depends on
whether backend is registered, mv it into frontswap.c using fronstswap_ops
to make the decision.

frontswap_set/clear are not used outside frontswap, so don't export them.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |   28 +----------------
 mm/frontswap.c            |   57 ++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 52 deletions(-)

diff -puN include/linux/frontswap.h~mm-frontswap-cleanup-code include/linux/frontswap.h
--- a/include/linux/frontswap.h~mm-frontswap-cleanup-code
+++ a/include/linux/frontswap.h
@@ -22,6 +22,7 @@ extern void frontswap_writethrough(bool)
 #define FRONTSWAP_HAS_EXCLUSIVE_GETS
 extern void frontswap_tmem_exclusive_gets(bool);
 
+extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
 extern void __frontswap_init(unsigned type);
 extern int __frontswap_store(struct page *page);
 extern int __frontswap_load(struct page *page);
@@ -29,26 +30,11 @@ extern void __frontswap_invalidate_page(
 extern void __frontswap_invalidate_area(unsigned);
 
 #ifdef CONFIG_FRONTSWAP
+#define frontswap_enabled (1)
 
 static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
 {
-	bool ret = false;
-
-	if (frontswap_enabled && sis->frontswap_map)
-		ret = test_bit(offset, sis->frontswap_map);
-	return ret;
-}
-
-static inline void frontswap_set(struct swap_info_struct *sis, pgoff_t offset)
-{
-	if (frontswap_enabled && sis->frontswap_map)
-		set_bit(offset, sis->frontswap_map);
-}
-
-static inline void frontswap_clear(struct swap_info_struct *sis, pgoff_t offset)
-{
-	if (frontswap_enabled && sis->frontswap_map)
-		clear_bit(offset, sis->frontswap_map);
+	return __frontswap_test(sis, offset);
 }
 
 static inline void frontswap_map_set(struct swap_info_struct *p,
@@ -71,14 +57,6 @@ static inline bool frontswap_test(struct
 	return false;
 }
 
-static inline void frontswap_set(struct swap_info_struct *sis, pgoff_t offset)
-{
-}
-
-static inline void frontswap_clear(struct swap_info_struct *sis, pgoff_t offset)
-{
-}
-
 static inline void frontswap_map_set(struct swap_info_struct *p,
 				     unsigned long *map)
 {
diff -puN mm/frontswap.c~mm-frontswap-cleanup-code mm/frontswap.c
--- a/mm/frontswap.c~mm-frontswap-cleanup-code
+++ a/mm/frontswap.c
@@ -27,14 +27,6 @@
 static struct frontswap_ops *frontswap_ops __read_mostly;
 
 /*
- * This global enablement flag reduces overhead on systems where frontswap_ops
- * has not been registered, so is preferred to the slower alternative: a
- * function call that checks a non-global.
- */
-bool frontswap_enabled __read_mostly;
-EXPORT_SYMBOL(frontswap_enabled);
-
-/*
  * If enabled, frontswap_store will return failure even on success.  As
  * a result, the swap subsystem will always write the page to swap, in
  * effect converting frontswap into a writethrough cache.  In this mode,
@@ -128,8 +120,6 @@ struct frontswap_ops *frontswap_register
 	struct frontswap_ops *old = frontswap_ops;
 	int i;
 
-	frontswap_enabled = true;
-
 	for (i = 0; i < MAX_SWAPFILES; i++) {
 		if (test_and_clear_bit(i, need_init))
 			ops->init(i);
@@ -183,9 +173,21 @@ void __frontswap_init(unsigned type)
 }
 EXPORT_SYMBOL(__frontswap_init);
 
-static inline void __frontswap_clear(struct swap_info_struct *sis, pgoff_t offset)
+bool __frontswap_test(struct swap_info_struct *sis,
+				pgoff_t offset)
+{
+	bool ret = false;
+
+	if (frontswap_ops && sis->frontswap_map)
+		ret = test_bit(offset, sis->frontswap_map);
+	return ret;
+}
+EXPORT_SYMBOL(__frontswap_test);
+
+static inline void __frontswap_clear(struct swap_info_struct *sis,
+				pgoff_t offset)
 {
-	frontswap_clear(sis, offset);
+	clear_bit(offset, sis->frontswap_map);
 	atomic_dec(&sis->frontswap_pages);
 }
 
@@ -204,18 +206,20 @@ int __frontswap_store(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
-	if (!frontswap_ops) {
-		inc_frontswap_failed_stores();
+	/*
+	 * Return if no backend registed.
+	 * Don't need to inc frontswap_failed_stores here.
+	 */
+	if (!frontswap_ops)
 		return ret;
-	}
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
-	if (frontswap_test(sis, offset))
+	if (__frontswap_test(sis, offset))
 		dup = 1;
 	ret = frontswap_ops->store(type, offset, page);
 	if (ret == 0) {
-		frontswap_set(sis, offset);
+		set_bit(offset, sis->frontswap_map);
 		inc_frontswap_succ_stores();
 		if (!dup)
 			atomic_inc(&sis->frontswap_pages);
@@ -248,18 +252,18 @@ int __frontswap_load(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
-	if (!frontswap_ops)
-		return ret;
-
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
-	if (frontswap_test(sis, offset))
+	/*
+	 * __frontswap_test() will check whether there is backend registered
+	 */
+	if (__frontswap_test(sis, offset))
 		ret = frontswap_ops->load(type, offset, page);
 	if (ret == 0) {
 		inc_frontswap_loads();
 		if (frontswap_tmem_exclusive_gets_enabled) {
 			SetPageDirty(page);
-			frontswap_clear(sis, offset);
+			__frontswap_clear(sis, offset);
 		}
 	}
 	return ret;
@@ -274,11 +278,11 @@ void __frontswap_invalidate_page(unsigne
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	if (!frontswap_ops)
-		return;
