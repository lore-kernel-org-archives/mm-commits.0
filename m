From: akpm@linux-foundation.org
Subject: + idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:08 -0800
Message-ID: <20130206223709.281BE5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:39260 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab3BFWhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:10 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so209876yen.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new()
has been added to the -mm tree.  Its filename is
     idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch

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
-
-/**
  * ida_remove - remove the given ID
  * @ida:	ida handle
  * @id:		ID to free
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

