From: akpm@linux-foundation.org
Subject: + idr-cosmetic-updates-to-struct-initializer-definitions.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:06 -0800
Message-ID: <20130206223707.26D5631C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39198 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab3BFWhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:08 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so209561yen.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: cosmetic updates to struct / initializer definitions
has been added to the -mm tree.  Its filename is
     idr-cosmetic-updates-to-struct-initializer-definitions.patch

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
Subject: idr: cosmetic updates to struct / initializer definitions

* Tab align fields like a normal person.

* Drop the unnecessary 0 inits from IDR_INIT().

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN include/linux/idr.h~idr-cosmetic-updates-to-struct-initializer-definitions include/linux/idr.h
--- a/include/linux/idr.h~idr-cosmetic-updates-to-struct-initializer-definitions
+++ a/include/linux/idr.h
@@ -49,28 +49,24 @@
 #define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
 
 struct idr_layer {
-	unsigned long		 bitmap; /* A zero bit means "space here" */
+	unsigned long		bitmap;	/* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
-	int			 count;	 /* When zero, we can release it */
-	int			 layer;	 /* distance from leaf */
-	struct rcu_head		 rcu_head;
+	int			count;	/* When zero, we can release it */
+	int			layer;	/* distance from leaf */
+	struct rcu_head		rcu_head;
 };
 
 struct idr {
-	struct idr_layer __rcu *top;
-	struct idr_layer *id_free;
-	int		  layers; /* only valid without concurrent changes */
-	int		  id_free_cnt;
-	spinlock_t	  lock;
+	struct idr_layer __rcu	*top;
+	struct idr_layer	*id_free;
+	int			layers;	/* only valid w/o concurrent changes */
+	int			id_free_cnt;
+	spinlock_t		lock;
 };
 
-#define IDR_INIT(name)						\
-{								\
-	.top		= NULL,					\
-	.id_free	= NULL,					\
-	.layers 	= 0,					\
-	.id_free_cnt	= 0,					\
-	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+#define IDR_INIT(name)							\
+{									\
+	.lock			= __SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
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

