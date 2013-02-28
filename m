From: akpm@linux-foundation.org
Subject: [merged] idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:00 -0800
Message-ID: <20130228201300.B36F731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59006 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3B1UNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:01 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261167qaj.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()
has been removed from the -mm tree.  Its filename was
     idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()

* Move idr_for_each_entry() definition next to other idr related
  definitions.

* Make id[r|a]_get_new() inline wrappers of id[r|a]_get_new_above().

This changes the implementation of idr_get_new() but the new
implementation is trivial.  This patch doesn't introduce any
functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   47 ++++++++++++++++++++++++++++++----------
 lib/idr.c           |   49 ------------------------------------------
 2 files changed, 35 insertions(+), 61 deletions(-)

diff -puN include/linux/idr.h~idr-relocate-idr_for_each_entry-and-reorganize-id_get_new include/linux/idr.h
--- a/include/linux/idr.h~idr-relocate-idr_for_each_entry-and-reorganize-id_get_new
+++ a/include/linux/idr.h
@@ -99,7 +99,6 @@ struct idr {
 
 void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int idr_get_new(struct idr *idp, void *ptr, int *id);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
@@ -109,6 +108,30 @@ void idr_remove(struct idr *idp, int id)
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+/**
+ * idr_get_new - allocate new idr entry
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @id: pointer to the allocated handle
+ *
+ * Simple wrapper around idr_get_new_above() w/ @starting_id of zero.
+ */
+static inline int idr_get_new(struct idr *idp, void *ptr, int *id)
+{
+	return idr_get_new_above(idp, ptr, 0, id);
+}
+
+/**
+ * idr_for_each_entry - iterate over an idr's elements of a given type
+ * @idp:     idr handle
+ * @entry:   the type * to use as cursor
+ * @id:      id entry's key
+ */
+#define idr_for_each_entry(idp, entry, id)				\
+	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
+	     entry != NULL;                                             \
+	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+
 void __idr_remove_all(struct idr *idp);	/* don't use */
 
 /**
@@ -149,7 +172,6 @@ struct ida {
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id);
-int ida_get_new(struct ida *ida, int *p_id);
 void ida_remove(struct ida *ida, int id);
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
@@ -158,17 +180,18 @@ int ida_simple_get(struct ida *ida, unsi
 		   gfp_t gfp_mask);
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
-void __init idr_init_cache(void);
-
 /**
- * idr_for_each_entry - iterate over an idr's elements of a given type
- * @idp:     idr handle
- * @entry:   the type * to use as cursor
- * @id:      id entry's key
+ * ida_get_new - allocate new ID
+ * @ida:	idr handle
+ * @p_id:	pointer to the allocated handle
+ *
+ * Simple wrapper around ida_get_new_above() w/ @starting_id of zero.
  */
-#define idr_for_each_entry(idp, entry, id)				\
-	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
-	     entry != NULL;                                             \
-	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+static inline int ida_get_new(struct ida *ida, int *p_id)
+{
+	return ida_get_new_above(ida, 0, p_id);
+}
+
+void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff -puN lib/idr.c~idr-relocate-idr_for_each_entry-and-reorganize-id_get_new lib/idr.c
--- a/lib/idr.c~idr-relocate-idr_for_each_entry-and-reorganize-id_get_new
+++ a/lib/idr.c
@@ -317,36 +317,6 @@ int idr_get_new_above(struct idr *idp, v
 }
 EXPORT_SYMBOL(idr_get_new_above);
 
-/**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * If allocation from IDR's private freelist fails, idr_get_new_above() will
- * return %-EAGAIN.  The caller should retry the idr_pre_get() call to refill
- * IDR's preallocation and then retry the idr_get_new_above() call.
- *
- * If the idr is full idr_get_new_above() will return %-ENOSPC.
- *
- * @id returns a value in the range %0 ... %0x7fffffff
- */
-int idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	int rv;
-
-	rv = idr_get_new_above_int(idp, ptr, 0);
-	/*
-	 * This is a cheap hack until the IDR code can be fixed to
-	 * return proper error values.
-	 */
-	if (rv < 0)
-		return _idr_rc_to_errno(rv);
-	*id = rv;
-	return 0;
-}
-EXPORT_SYMBOL(idr_get_new);
-
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
@@ -857,25 +827,6 @@ int ida_get_new_above(struct ida *ida, i
 EXPORT_SYMBOL(ida_get_new_above);
 
 /**
- * ida_get_new - allocate new ID
- * @ida:	idr handle
- * @p_id:	pointer to the allocated handle
- *
- * Allocate new ID.  It should be called with any required locks.
- *
- * If memory is required, it will return %-EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return %-ENOSPC.
- *
- * @p_id returns a value in the range %0 ... %0x7fffffff.
- */
-int ida_get_new(struct ida *ida, int *p_id)
-{
-	return ida_get_new_above(ida, 0, p_id);
-}
-EXPORT_SYMBOL(ida_get_new);
