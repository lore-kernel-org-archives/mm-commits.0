From: akpm@linux-foundation.org
Subject: + idr-deprecate-idr_pre_get-and-idr_get_new.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:20 -0800
Message-ID: <20130305220820.C55715A41D3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:49500 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:21 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so791732ggn.0
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, rusty@rustcorp.com.au


The patch titled
     Subject: idr: deprecate idr_pre_get() and idr_get_new[_above]()
has been added to the -mm tree.  Its filename is
     idr-deprecate-idr_pre_get-and-idr_get_new.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: deprecate idr_pre_get() and idr_get_new[_above]()

Now that all in-kernel users are converted to ues the new alloc
interface, mark the old interface deprecated.  We should be able to
remove these in a few releases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   66 +++++++++++++++++++++++++++++++-----------
 lib/idr.c           |   41 +++-----------------------
 2 files changed, 55 insertions(+), 52 deletions(-)

diff -puN include/linux/idr.h~idr-deprecate-idr_pre_get-and-idr_get_new include/linux/idr.h
--- a/include/linux/idr.h~idr-deprecate-idr_pre_get-and-idr_get_new
+++ a/include/linux/idr.h
@@ -73,8 +73,6 @@ struct idr {
  */
 
 void *idr_find_slowpath(struct idr *idp, int id);
-int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
 void idr_preload(gfp_t gfp_mask);
 int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
@@ -120,19 +118,6 @@ static inline void *idr_find(struct idr
 }
 
 /**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * Simple wrapper around idr_get_new_above() w/ @starting_id of zero.
- */
-static inline int idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	return idr_get_new_above(idp, ptr, 0, id);
-}
-
-/**
  * idr_for_each_entry - iterate over an idr's elements of a given type
  * @idp:     idr handle
  * @entry:   the type * to use as cursor
@@ -143,7 +128,56 @@ static inline int idr_get_new(struct idr
 	     entry != NULL;                                             \
 	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
 
-void __idr_remove_all(struct idr *idp);	/* don't use */
+/*
+ * Don't use the following functions.  These exist only to suppress
+ * deprecated warnings on EXPORT_SYMBOL()s.
+ */
+int __idr_pre_get(struct idr *idp, gfp_t gfp_mask);
+int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+void __idr_remove_all(struct idr *idp);
+
+/**
+ * idr_pre_get - reserve resources for idr allocation
+ * @idp:	idr handle
+ * @gfp_mask:	memory allocation flags
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_pre_get(struct idr *idp, gfp_t gfp_mask)
+{
+	return __idr_pre_get(idp, gfp_mask);
+}
+
+/**
+ * idr_get_new_above - allocate new idr entry above or equal to a start id
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @starting_id: id to start search at
+ * @id: pointer to the allocated handle
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_get_new_above(struct idr *idp, void *ptr,
+						 int starting_id, int *id)
+{
+	return __idr_get_new_above(idp, ptr, starting_id, id);
+}
+
+/**
+ * idr_get_new - allocate new idr entry
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the id
+ * @id: pointer to the allocated handle
+ *
+ * Part of old alloc interface.  This is going away.  Use
+ * idr_preload[_end]() and idr_alloc() instead.
+ */
+static inline int __deprecated idr_get_new(struct idr *idp, void *ptr, int *id)
+{
+	return __idr_get_new_above(idp, ptr, 0, id);
+}
 
 /**
  * idr_remove_all - remove all ids from the given idr tree
diff -puN lib/idr.c~idr-deprecate-idr_pre_get-and-idr_get_new lib/idr.c
--- a/lib/idr.c~idr-deprecate-idr_pre_get-and-idr_get_new
+++ a/lib/idr.c
@@ -184,20 +184,7 @@ static void idr_mark_full(struct idr_lay
 	}
 }
 
-/**
- * idr_pre_get - reserve resources for idr allocation
- * @idp:	idr handle
- * @gfp_mask:	memory allocation flags
- *
- * This function should be called prior to calling the idr_get_new* functions.
- * It preallocates enough memory to satisfy the worst possible allocation. The
- * caller should pass in GFP_KERNEL if possible.  This of course requires that
- * no spinning locks be held.
- *
- * If the system is REALLY out of memory this function returns %0,
- * otherwise %1.
- */
-int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
+int __idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
 	while (idp->id_free_cnt < MAX_IDR_FREE) {
 		struct idr_layer *new;
@@ -208,7 +195,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 	}
 	return 1;
 }
-EXPORT_SYMBOL(idr_pre_get);
+EXPORT_SYMBOL(__idr_pre_get);
 
 /**
  * sub_alloc - try to allocate an id without growing the tree depth
@@ -376,25 +363,7 @@ static void idr_fill_slot(struct idr *id
 	idr_mark_full(pa, id);
 }
 
-/**
- * idr_get_new_above - allocate new idr entry above or equal to a start id
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @starting_id: id to start search at
- * @id: pointer to the allocated handle
- *
- * This is the allocate id function.  It should be called with any
- * required locks.
- *
- * If allocation from IDR's private freelist fails, idr_get_new_above() will
- * return %-EAGAIN.  The caller should retry the idr_pre_get() call to refill
- * IDR's preallocation and then retry the idr_get_new_above() call.
- *
- * If the idr is full idr_get_new_above() will return %-ENOSPC.
- *
- * @id returns a value in the range @starting_id ... %0x7fffffff
- */
-int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
+int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
 	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
 	int rv;
@@ -407,7 +376,7 @@ int idr_get_new_above(struct idr *idp, v
 	*id = rv;
 	return 0;
 }
-EXPORT_SYMBOL(idr_get_new_above);
+EXPORT_SYMBOL(__idr_get_new_above);
 
 /**
  * idr_preload - preload for idr_alloc()
@@ -908,7 +877,7 @@ static void free_bitmap(struct ida *ida,
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
 	/* allocate idr_layers */
-	if (!idr_pre_get(&ida->idr, gfp_mask))
+	if (!__idr_pre_get(&ida->idr, gfp_mask))
 		return 0;
 
 	/* allocate free_bitmap */
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
idr-remove-warn_on_once-on-negative-ids.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
rtc-add-devm_rtc_device_registerunregister.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-remove-unused-get_new_stid.patch
nfsd-convert-to-idr_alloc.patch
workqueue-convert-to-idr_alloc.patch
mlx4-remove-leftover-idr_pre_get-call.patch
zcache-convert-to-idr_alloc.patch
tidspbridge-convert-to-idr_alloc.patch
idr-deprecate-idr_pre_get-and-idr_get_new.patch

