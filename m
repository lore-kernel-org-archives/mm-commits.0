From: akpm@linux-foundation.org
Subject: + idr-remove-_idr_rc_to_errno-hack.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:11 -0800
Message-ID: <20130206223712.2A59D5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:65373 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab3BFWhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:13 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so209721qen.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: remove _idr_rc_to_errno() hack
has been added to the -mm tree.  Its filename is
     idr-remove-_idr_rc_to_errno-hack.patch

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
Subject: idr: remove _idr_rc_to_errno() hack

idr uses -1, IDR_NEED_TO_GROW and IDR_NOMORE_SPACE to communicate
exception conditions internally.  The return value is later translated
to errno values using _idr_rc_to_errno().

This is confusing.  Drop the custom ones and consistently use -EAGAIN
for "tree needs to grow", -ENOMEM for "need more memory" and -ENOSPC
for "ran out of ID space".

Due to the weird memory preloading mechanism, [ra]_get_new*() return
-EAGAIN on memory shortage, so we need to substitute -ENOMEM w/
-EAGAIN on those interface functions.  They'll eventually be cleaned
up and the translations will go away.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    6 ------
 lib/idr.c           |   35 +++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff -puN include/linux/idr.h~idr-remove-_idr_rc_to_errno-hack include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-_idr_rc_to_errno-hack
+++ a/include/linux/idr.h
@@ -70,12 +70,6 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
-/* Actions to be taken after a call to _idr_sub_alloc */
-#define IDR_NEED_TO_GROW -2
-#define IDR_NOMORE_SPACE -3
-
-#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
-
 /**
  * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
diff -puN lib/idr.c~idr-remove-_idr_rc_to_errno-hack lib/idr.c
--- a/lib/idr.c~idr-remove-_idr_rc_to_errno-hack
+++ a/lib/idr.c
@@ -133,6 +133,21 @@ int idr_pre_get(struct idr *idp, gfp_t g
 }
 EXPORT_SYMBOL(idr_pre_get);
 
+/**
+ * sub_alloc - try to allocate an id without growing the tree depth
+ * @idp: idr handle
+ * @starting_id: id to start search at
+ * @id: pointer to the allocated handle
+ * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
+ *
+ * Allocate an id in range [@starting_id, INT_MAX] from @idp without
+ * growing its depth.  Returns
+ *
+ *  the allocated id >= 0 if successful,
+ *  -EAGAIN if the tree needs to grow for allocation to succeed,
+ *  -ENOSPC if the id space is exhausted,
+ *  -ENOMEM if more idr_layers need to be allocated.
+ */
 static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 {
 	int n, m, sh;
@@ -161,7 +176,7 @@ static int sub_alloc(struct idr *idp, in
 			/* if already at the top layer, we need to grow */
 			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
-				return IDR_NEED_TO_GROW;
+				return -EAGAIN;
 			}
 			p = pa[l];
 			BUG_ON(!p);
@@ -180,7 +195,7 @@ static int sub_alloc(struct idr *idp, in
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
 		if ((id >= MAX_IDR_BIT) || (id < 0))
-			return IDR_NOMORE_SPACE;
+			return -ENOSPC;
 		if (l == 0)
 			break;
 		/*
@@ -189,7 +204,7 @@ static int sub_alloc(struct idr *idp, in
 		if (!p->ary[m]) {
 			new = get_from_free_list(idp);
 			if (!new)
-				return -1;
+				return -ENOMEM;
 			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
@@ -215,7 +230,7 @@ build_up:
 	layers = idp->layers;
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
-			return -1;
+			return -ENOMEM;
 		p->layer = 0;
 		layers = 1;
 	}
@@ -246,7 +261,7 @@ build_up:
 				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
-			return -1;
+			return -ENOMEM;
 		}
 		new->ary[0] = p;
 		new->count = 1;
@@ -258,7 +273,7 @@ build_up:
 	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == IDR_NEED_TO_GROW)
+	if (v == -EAGAIN)
 		goto build_up;
 	return(v);
 }
@@ -306,12 +321,8 @@ int idr_get_new_above(struct idr *idp, v
 	int rv;
 
 	rv = idr_get_new_above_int(idp, ptr, starting_id);
-	/*
-	 * This is a cheap hack until the IDR code can be fixed to
-	 * return proper error values.
-	 */
 	if (rv < 0)
-		return _idr_rc_to_errno(rv);
+		return rv == -ENOMEM ? -EAGAIN : rv;
 	*id = rv;
 	return 0;
 }
@@ -766,7 +777,7 @@ int ida_get_new_above(struct ida *ida, i
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
 	if (t < 0)
-		return _idr_rc_to_errno(t);
+		return t == -ENOMEM ? -EAGAIN : t;
 
 	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
 		return -ENOSPC;
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

