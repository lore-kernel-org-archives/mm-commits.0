From: akpm@linux-foundation.org
Subject: [to-be-updated] frontswap-allow-multiple-backends.patch removed
 from -mm tree
Date: Tue, 02 Jun 2015 13:52:31 -0700
Message-ID: <556e178f.ElhsEEmdpQOXQrRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbbFBUwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 16:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: allow multiple backends
has been removed from the -mm tree.  Its filename was
     frontswap-allow-multiple-backends.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: frontswap: allow multiple backends

Change frontswap single pointer to a singly linked list of frontswap
implementations.  Update Xen tmem implementation as register no longer
returns anything.

Frontswap only keeps track of a single implementation; any implementation
that registers second (or later) will replace the previously registered
implementation, and gets a pointer to the previous implementation that the
new implementation is expected to pass all frontswap functions to if it
can't handle the function itself.  However that method doesn't really make
much sense, as passing that work on to every implementation adds
unnecessary work to implementations; instead, frontswap should simply keep
a list of all registered implementations and try each implementation for
any function.  Most importantly, neither of the two currently existing
frontswap implementations in the kernel actually do anything with any
previous frontswap implementation that they replace when registering.

This allows frontswap to successfully manage multiple implementations
by keeping a list of them all.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/tmem.c        |    8 -
 include/linux/frontswap.h |    4 
 mm/frontswap.c            |  157 +++++++++++++++++++-----------------
 3 files changed, 87 insertions(+), 82 deletions(-)

diff -puN drivers/xen/tmem.c~frontswap-allow-multiple-backends drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~frontswap-allow-multiple-backends
+++ a/drivers/xen/tmem.c
@@ -381,15 +381,9 @@ static int __init xen_tmem_init(void)
 #ifdef CONFIG_FRONTSWAP
 	if (tmem_enabled && frontswap) {
 		char *s = "";
-		struct frontswap_ops *old_ops;
 
 		tmem_frontswap_poolid = -1;
-		old_ops = frontswap_register_ops(&tmem_frontswap_ops);
-		if (IS_ERR(old_ops) || old_ops) {
-			if (IS_ERR(old_ops))
-				return PTR_ERR(old_ops);
-			s = " (WARNING: frontswap_ops overridden)";
-		}
+		frontswap_register_ops(&tmem_frontswap_ops);
 		pr_info("frontswap enabled, RAM provided by Xen Transcendent Memory%s\n",
 			s);
 	}
diff -puN include/linux/frontswap.h~frontswap-allow-multiple-backends include/linux/frontswap.h
--- a/include/linux/frontswap.h~frontswap-allow-multiple-backends
+++ a/include/linux/frontswap.h
@@ -11,11 +11,11 @@ struct frontswap_ops {
 	int (*load)(unsigned, pgoff_t, struct page *);
 	void (*invalidate_page)(unsigned, pgoff_t);
 	void (*invalidate_area)(unsigned);
+	struct frontswap_ops *next;
 };
 
 extern bool frontswap_enabled;
-extern struct frontswap_ops *
-	frontswap_register_ops(struct frontswap_ops *ops);
+extern void frontswap_register_ops(struct frontswap_ops *ops);
 extern void frontswap_shrink(unsigned long);
 extern unsigned long frontswap_curr_pages(void);
 extern void frontswap_writethrough(bool);
diff -puN mm/frontswap.c~frontswap-allow-multiple-backends mm/frontswap.c
--- a/mm/frontswap.c~frontswap-allow-multiple-backends
+++ a/mm/frontswap.c
@@ -21,8 +21,8 @@
 #include <linux/swapfile.h>
 
 /*
- * frontswap_ops is set by frontswap_register_ops to contain the pointers
- * to the frontswap "backend" implementation functions.
+ * frontswap_ops are added by frontswap_register_ops, and provide the
+ * frontswap "backend" implementation functions.
  */
 static struct frontswap_ops *frontswap_ops __read_mostly;
 
@@ -79,15 +79,6 @@ static inline void inc_frontswap_invalid
  * on all frontswap functions to not call the backend until the backend
  * has registered.
  *
- * Specifically when no backend is registered (nobody called
- * frontswap_register_ops) all calls to frontswap_init (which is done via
- * swapon -> enable_swap_info -> frontswap_init) are registered and remembered
- * (via the setting of need_init bitmap) but fail to create tmem_pools. When a
- * backend registers with frontswap at some later point the previous
- * calls to frontswap_init are executed (by iterating over the need_init
- * bitmap) to create tmem_pools and set the respective poolids. All of that is
- * guarded by us using atomic bit operations on the 'need_init' bitmap.
- *
  * This would not guards us against the user deciding to call swapoff right as
  * we are calling the backend to initialize (so swapon is in action).
  * Fortunatly for us, the swapon_mutex has been taked by the callee so we are
@@ -106,37 +97,51 @@ static inline void inc_frontswap_invalid
  *
  * Obviously the opposite (unloading the backend) must be done after all
  * the frontswap_[store|load|invalidate_area|invalidate_page] start
- * ignorning or failing the requests - at which point frontswap_ops
- * would have to be made in some fashion atomic.
+ * ignorning or failing the requests.  However, there is currently no way
+ * to unload a backend once it is registered.
  */
-static DECLARE_BITMAP(need_init, MAX_SWAPFILES);
 
 /*
- * Register operations for frontswap, returning previous thus allowing
- * detection of multiple backends and possible nesting.
+ * Register operations for frontswap
  */
-struct frontswap_ops *frontswap_register_ops(struct frontswap_ops *ops)
+void frontswap_register_ops(struct frontswap_ops *ops)
 {
-	struct frontswap_ops *old = frontswap_ops;
-	int i;
+	DECLARE_BITMAP(a, MAX_SWAPFILES);
+	DECLARE_BITMAP(b, MAX_SWAPFILES);
+	struct swap_info_struct *si;
+	unsigned int i;
+
+	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if (!WARN_ON(!si->frontswap_map))
+			set_bit(si->type, a);
+	}
+	spin_unlock(&swap_lock);
+
+	for (i = find_first_bit(a, MAX_SWAPFILES);
+	     i < MAX_SWAPFILES;
+	     i = find_next_bit(a, MAX_SWAPFILES, i + 1))
+		ops->init(i);
+
+	do {
+		ops->next = frontswap_ops;
+	} while (cmpxchg(&frontswap_ops, ops->next, ops) != ops->next);
+
+	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if (si->frontswap_map)
+			set_bit(si->type, b);
+	}
+	spin_unlock(&swap_lock);
 
-	for (i = 0; i < MAX_SWAPFILES; i++) {
-		if (test_and_clear_bit(i, need_init)) {
-			struct swap_info_struct *sis = swap_info[i];
-			/* __frontswap_init _should_ have set it! */
-			if (!sis->frontswap_map)
-				return ERR_PTR(-EINVAL);
-			ops->init(i);
+	if (!bitmap_equal(a, b, MAX_SWAPFILES)) {
+		for (i = 0; i < MAX_SWAPFILES; i++) {
+			if (!test_bit(i, a) && test_bit(i, b))
+				ops->init(i);
+			else if (test_bit(i, a) && !test_bit(i, b))
+				ops->invalidate_area(i);
 		}
 	}
-	/*
-	 * We MUST have frontswap_ops set _after_ the frontswap_init's
-	 * have been called. Otherwise __frontswap_store might fail. Hence
-	 * the barrier to make sure compiler does not re-order us.
-	 */
-	barrier();
-	frontswap_ops = ops;
-	return old;
 }
 EXPORT_SYMBOL(frontswap_register_ops);
 
@@ -164,6 +169,7 @@ EXPORT_SYMBOL(frontswap_tmem_exclusive_g
 void __frontswap_init(unsigned type, unsigned long *map)
 {
 	struct swap_info_struct *sis = swap_info[type];
+	struct frontswap_ops *ops;
 
 	BUG_ON(sis == NULL);
 
@@ -179,23 +185,18 @@ void __frontswap_init(unsigned type, uns
 	 * p->frontswap set to something valid to work properly.
 	 */
 	frontswap_map_set(sis, map);
-	if (frontswap_ops)
-		frontswap_ops->init(type);
-	else {
-		BUG_ON(type >= MAX_SWAPFILES);
-		set_bit(type, need_init);
-	}
+
+	for (ops = frontswap_ops; ops; ops = ops->next)
+		ops->init(type);
 }
 EXPORT_SYMBOL(__frontswap_init);
 
 bool __frontswap_test(struct swap_info_struct *sis,
 				pgoff_t offset)
 {
-	bool ret = false;
-
-	if (frontswap_ops && sis->frontswap_map)
-		ret = test_bit(offset, sis->frontswap_map);
-	return ret;
+	if (sis->frontswap_map)
+		return test_bit(offset, sis->frontswap_map);
+	return false;
 }
 EXPORT_SYMBOL(__frontswap_test);
 
@@ -215,24 +216,25 @@ static inline void __frontswap_clear(str
  */
 int __frontswap_store(struct page *page)
 {
-	int ret = -1, dup = 0;
+	int ret, dup;
 	swp_entry_t entry = { .val = page_private(page), };
 	int type = swp_type(entry);
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
+	struct frontswap_ops *ops;
 
 	/*
 	 * Return if no backend registed.
 	 * Don't need to inc frontswap_failed_stores here.
 	 */
 	if (!frontswap_ops)
-		return ret;
+		return -1;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
-	if (__frontswap_test(sis, offset))
-		dup = 1;
-	ret = frontswap_ops->store(type, offset, page);
+	dup = __frontswap_test(sis, offset);
+	for (ops = frontswap_ops, ret = -1; ops && ret; ops = ops->next)
+		ret = ops->store(type, offset, page);
 	if (ret == 0) {
 		set_bit(offset, sis->frontswap_map);
 		inc_frontswap_succ_stores();
@@ -263,19 +265,22 @@ EXPORT_SYMBOL(__frontswap_store);
  */
 int __frontswap_load(struct page *page)
 {
-	int ret = -1;
+	int ret;
 	swp_entry_t entry = { .val = page_private(page), };
 	int type = swp_type(entry);
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
+	struct frontswap_ops *ops;
+
+	if (!frontswap_ops)
+		return -1;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
-	/*
-	 * __frontswap_test() will check whether there is backend registered
-	 */
-	if (__frontswap_test(sis, offset))
-		ret = frontswap_ops->load(type, offset, page);
+	if (!__frontswap_test(sis, offset))
+		return -1;
+	for (ops = frontswap_ops, ret = -1; ops && ret; ops = ops->next)
+		ret = ops->load(type, offset, page);
 	if (ret == 0) {
 		inc_frontswap_loads();
 		if (frontswap_tmem_exclusive_gets_enabled) {
@@ -294,16 +299,19 @@ EXPORT_SYMBOL(__frontswap_load);
 void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct swap_info_struct *sis = swap_info[type];
+	struct frontswap_ops *ops;
+
+	if (!frontswap_ops)
+		return;
 
 	BUG_ON(sis == NULL);
-	/*
-	 * __frontswap_test() will check whether there is backend registered
-	 */
-	if (__frontswap_test(sis, offset)) {
-		frontswap_ops->invalidate_page(type, offset);
-		__frontswap_clear(sis, offset);
-		inc_frontswap_invalidates();
-	}
+	if (!__frontswap_test(sis, offset))
+		return;
+
+	for (ops = frontswap_ops; ops; ops = ops->next)
+		ops->invalidate_page(type, offset);
+	__frontswap_clear(sis, offset);
+	inc_frontswap_invalidates();
 }
 EXPORT_SYMBOL(__frontswap_invalidate_page);
 
@@ -314,16 +322,19 @@ EXPORT_SYMBOL(__frontswap_invalidate_pag
 void __frontswap_invalidate_area(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
+	struct frontswap_ops *ops;
 
-	if (frontswap_ops) {
-		BUG_ON(sis == NULL);
-		if (sis->frontswap_map == NULL)
-			return;
-		frontswap_ops->invalidate_area(type);
-		atomic_set(&sis->frontswap_pages, 0);
-		bitmap_zero(sis->frontswap_map, sis->max);
-	}
-	clear_bit(type, need_init);
+	if (!frontswap_ops)
+		return;
+
+	BUG_ON(sis == NULL);
+	if (sis->frontswap_map == NULL)
+		return;
+
+	for (ops = frontswap_ops; ops; ops = ops->next)
+		ops->invalidate_area(type);
+	atomic_set(&sis->frontswap_pages, 0);
+	bitmap_zero(sis->frontswap_map, sis->max);
 }
 EXPORT_SYMBOL(__frontswap_invalidate_area);
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
zpool-change-pr_info-to-pr_debug.patch
linux-next.patch

