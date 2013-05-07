From: akpm@linux-foundation.org
Subject: [merged] mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:21 -0700
Message-ID: <20130507174621.96FDE5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:42932 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3EGRqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:24 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so73181ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.magenheimer@oracle.com, andor.daam@googlemail.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: frontswap: lazy initialization to allow tmem backends to build/run as modules
has been removed from the -mm tree.  Its filename was
     mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: mm: frontswap: lazy initialization to allow tmem backends to build/run as modules

With the goal of allowing tmem backends (zcache, ramster, Xen tmem) to be
built/loaded as modules rather than built-in and enabled by a boot
parameter, this patch provides "lazy initialization", allowing backends to
register to frontswap even after swapon was run.  Before a backend
registers all calls to init are recorded and the creation of tmem_pools
delayed until a backend registers or until a frontswap store is attempted.

Signed-off-by: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Florian Schmaus <fschmaus@gmail.com>
Signed-off-by: Andor Daam <andor.daam@googlemail.com>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
[v1: Fixes per Seth Jennings suggestions]
[v2: Removed FRONTSWAP_HAS_.. ]
[v3: Fix up per Bob Liu <lliubbo@gmail.com> recommendations]
[v4: Fix up per Andrew's comments]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |   94 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 10 deletions(-)

diff -puN mm/frontswap.c~mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules mm/frontswap.c
--- a/mm/frontswap.c~mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules
+++ a/mm/frontswap.c
@@ -80,6 +80,46 @@ static inline void inc_frontswap_succ_st
 static inline void inc_frontswap_failed_stores(void) { }
 static inline void inc_frontswap_invalidates(void) { }
 #endif
+
+/*
+ * Due to the asynchronous nature of the backends loading potentially
+ * _after_ the swap system has been activated, we have chokepoints
+ * on all frontswap functions to not call the backend until the backend
+ * has registered.
+ *
+ * Specifically when no backend is registered (nobody called
+ * frontswap_register_ops) all calls to frontswap_init (which is done via
+ * swapon -> enable_swap_info -> frontswap_init) are registered and remembered
+ * (via the setting of need_init bitmap) but fail to create tmem_pools. When a
+ * backend registers with frontswap at some later point the previous
+ * calls to frontswap_init are executed (by iterating over the need_init
+ * bitmap) to create tmem_pools and set the respective poolids. All of that is
+ * guarded by us using atomic bit operations on the 'need_init' bitmap.
+ *
+ * This would not guards us against the user deciding to call swapoff right as
+ * we are calling the backend to initialize (so swapon is in action).
+ * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
+ * OK. The other scenario where calls to frontswap_store (called via
+ * swap_writepage) is racing with frontswap_invalidate_area (called via
+ * swapoff) is again guarded by the swap subsystem.
+ *
+ * While no backend is registered all calls to frontswap_[store|load|
+ * invalidate_area|invalidate_page] are ignored or fail.
+ *
+ * The time between the backend being registered and the swap file system
+ * calling the backend (via the frontswap_* functions) is indeterminate as
+ * backend_registered is not atomic_t (or a value guarded by a spinlock).
+ * That is OK as we are comfortable missing some of these calls to the newly
+ * registered backend.
+ *
+ * Obviously the opposite (unloading the backend) must be done after all
+ * the frontswap_[store|load|invalidate_area|invalidate_page] start
+ * ignorning or failing the requests - at which point backend_registered
+ * would have to be made in some fashion atomic.
+ */
+static DECLARE_BITMAP(need_init, MAX_SWAPFILES);
+static bool backend_registered __read_mostly;
+
 /*
  * Register operations for frontswap, returning previous thus allowing
  * detection of multiple backends and possible nesting.
@@ -87,9 +127,22 @@ static inline void inc_frontswap_invalid
 struct frontswap_ops frontswap_register_ops(struct frontswap_ops *ops)
 {
 	struct frontswap_ops old = frontswap_ops;
+	int i;
 
 	frontswap_ops = *ops;
 	frontswap_enabled = true;
+
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		if (test_and_clear_bit(i, need_init))
+			(*frontswap_ops.init)(i);
+	}
+	/*
+	 * We MUST have backend_registered set _after_ the frontswap_init's
+	 * have been called. Otherwise __frontswap_store might fail. Hence
+	 * the barrier to make sure compiler does not re-order us.
+	 */
+	barrier();
+	backend_registered = true;
 	return old;
 }
 EXPORT_SYMBOL(frontswap_register_ops);
@@ -119,10 +172,16 @@ void __frontswap_init(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	BUG_ON(sis == NULL);
-	if (sis->frontswap_map == NULL)
-		return;
-	frontswap_ops.init(type);
+	if (backend_registered) {
+		BUG_ON(sis == NULL);
+		if (sis->frontswap_map == NULL)
+			return;
+		(*frontswap_ops.init)(type);
+	} else {
+		BUG_ON(type > MAX_SWAPFILES);
+		set_bit(type, need_init);
+	}
+
 }
 EXPORT_SYMBOL(__frontswap_init);
 
@@ -147,6 +206,11 @@ int __frontswap_store(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
+	if (!backend_registered) {
+		inc_frontswap_failed_stores();
+		return ret;
+	}
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
@@ -186,6 +250,9 @@ int __frontswap_load(struct page *page)
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
 
+	if (!backend_registered)
+		return ret;
+
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset))
@@ -209,6 +276,9 @@ void __frontswap_invalidate_page(unsigne
 {
 	struct swap_info_struct *sis = swap_info[type];
 
+	if (!backend_registered)
+		return;
+
 	BUG_ON(sis == NULL);
 	if (frontswap_test(sis, offset)) {
 		frontswap_ops.invalidate_page(type, offset);
@@ -226,12 +296,15 @@ void __frontswap_invalidate_area(unsigne
 {
 	struct swap_info_struct *sis = swap_info[type];
 
-	BUG_ON(sis == NULL);
-	if (sis->frontswap_map == NULL)
-		return;
-	frontswap_ops.invalidate_area(type);
-	atomic_set(&sis->frontswap_pages, 0);
-	memset(sis->frontswap_map, 0, sis->max / sizeof(long));
+	if (backend_registered) {
+		BUG_ON(sis == NULL);
+		if (sis->frontswap_map == NULL)
+			return;
+		(*frontswap_ops.invalidate_area)(type);
+		atomic_set(&sis->frontswap_pages, 0);
+		memset(sis->frontswap_map, 0, sis->max / sizeof(long));
+	}
+	clear_bit(type, need_init);
 }
 EXPORT_SYMBOL(__frontswap_invalidate_area);
 
@@ -364,6 +437,7 @@ static int __init init_frontswap(void)
 	debugfs_create_u64("invalidates", S_IRUGO,
 				root, &frontswap_invalidates);
 #endif
+	frontswap_enabled = 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from dan.magenheimer@oracle.com are

origin.patch

