From: akpm@linux-foundation.org
Subject: + idr-deprecate-idr_remove_all.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:04 -0800
Message-ID: <20130206223705.2309231C1FF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58956 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab3BFWhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:37:06 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so221743qaj.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:37:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: idr: deprecate idr_remove_all()
has been added to the -mm tree.  Its filename is
     idr-deprecate-idr_remove_all.patch

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
Subject: idr: deprecate idr_remove_all()

There was only one legitimate use of idr_remove_all() and a lot more
of incorrect uses (or lack of it).  Now that idr_destroy() implies
idr_remove_all() and all the in-kernel users updated not to use it,
there's no reason to keep it around.  Mark it deprecated so that we
can later unexport it.

idr_remove_all() is made an inline function calling __idr_remove_all()
to avoid triggering deprecated warning on EXPORT_SYMBOL().

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   14 +++++++++++++-
 lib/idr.c           |   10 +++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/idr.h~idr-deprecate-idr_remove_all include/linux/idr.h
--- a/include/linux/idr.h~idr-deprecate-idr_remove_all
+++ a/include/linux/idr.h
@@ -110,10 +110,22 @@ int idr_for_each(struct idr *idp,
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
-void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+void __idr_remove_all(struct idr *idp);	/* don't use */
+
+/**
+ * idr_remove_all - remove all ids from the given idr tree
+ * @idp: idr handle
+ *
+ * If you're trying to destroy @idp, calling idr_destroy() is enough.
+ * This is going away.  Don't use.
+ */
+static inline void __deprecated idr_remove_all(struct idr *idp)
+{
+	__idr_remove_all(idp);
+}
 
 /*
  * IDA - IDR based id allocator, use when translation from id to
diff -puN lib/idr.c~idr-deprecate-idr_remove_all lib/idr.c
--- a/lib/idr.c~idr-deprecate-idr_remove_all
+++ a/lib/idr.c
@@ -433,11 +433,7 @@ void idr_remove(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_remove);
 
-/**
- * idr_remove_all - remove all ids from the given idr tree
- * @idp: idr handle
- */
-void idr_remove_all(struct idr *idp)
+void __idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
 	int bt_mask;
@@ -470,7 +466,7 @@ void idr_remove_all(struct idr *idp)
 	}
 	idp->layers = 0;
 }
-EXPORT_SYMBOL(idr_remove_all);
+EXPORT_SYMBOL(__idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
@@ -487,7 +483,7 @@ EXPORT_SYMBOL(idr_remove_all);
  */
 void idr_destroy(struct idr *idp)
 {
-	idr_remove_all(idp);
+	__idr_remove_all(idp);
 
 	while (idp->id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(idp);
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

