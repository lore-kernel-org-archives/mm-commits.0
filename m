From: akpm@linux-foundation.org
Subject: + dlm-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:39:26 -0800
Message-ID: <20130206223927.29D2931C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34176 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab3BFWj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:39:28 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so210056qcr.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:39:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: dlm: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     dlm-convert-to-idr_alloc.patch

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
Subject: dlm: convert to idr_alloc()

Convert to the much saner new idr interface.  Error return values from
recover_idr_add() mix -1 and -errno.  The conversion doesn't change
that but it looks iffy.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lock.c    |   18 ++++++------------
 fs/dlm/recover.c |   27 +++++++++++++--------------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff -puN fs/dlm/lock.c~dlm-convert-to-idr_alloc fs/dlm/lock.c
--- a/fs/dlm/lock.c~dlm-convert-to-idr_alloc
+++ a/fs/dlm/lock.c
@@ -1183,7 +1183,7 @@ static void detach_lkb(struct dlm_lkb *l
 static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 {
 	struct dlm_lkb *lkb;
-	int rv, id;
+	int rv;
 
 	lkb = dlm_allocate_lkb(ls);
 	if (!lkb)
@@ -1199,19 +1199,13 @@ static int create_lkb(struct dlm_ls *ls,
 	mutex_init(&lkb->lkb_cb_mutex);
 	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
 
- retry:
-	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
-
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_lkbidr_spin);
-	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
-	if (!rv)
-		lkb->lkb_id = id;
+	rv = idr_alloc(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);
+	if (rv >= 0)
+		lkb->lkb_id = rv;
 	spin_unlock(&ls->ls_lkbidr_spin);
-
-	if (rv == -EAGAIN)
-		goto retry;
+	idr_preload_end();
 
 	if (rv < 0) {
 		log_error(ls, "create_lkb idr error %d", rv);
diff -puN fs/dlm/recover.c~dlm-convert-to-idr_alloc fs/dlm/recover.c
--- a/fs/dlm/recover.c~dlm-convert-to-idr_alloc
+++ a/fs/dlm/recover.c
@@ -305,27 +305,26 @@ static int recover_idr_empty(struct dlm_
 static int recover_idr_add(struct dlm_rsb *r)
 {
 	struct dlm_ls *ls = r->res_ls;
-	int rv, id;
-
-	rv = idr_pre_get(&ls->ls_recover_idr, GFP_NOFS);
-	if (!rv)
-		return -ENOMEM;
+	int rv;
 
+	idr_preload(GFP_NOFS);
 	spin_lock(&ls->ls_recover_idr_lock);
 	if (r->res_id) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return -1;
-	}
-	rv = idr_get_new_above(&ls->ls_recover_idr, r, 1, &id);
-	if (rv) {
-		spin_unlock(&ls->ls_recover_idr_lock);
-		return rv;
+		rv = -1;
+		goto out_unlock;
 	}
-	r->res_id = id;
+	rv = idr_alloc(&ls->ls_recover_idr, r, 1, 0, GFP_NOWAIT);
+	if (rv < 0)
+		goto out_unlock;
+
+	r->res_id = rv;
 	ls->ls_recover_list_count++;
 	dlm_hold_rsb(r);
+	rv = 0;
+out_unlock:
 	spin_unlock(&ls->ls_recover_idr_lock);
-	return 0;
+	idr_preload_end();
+	return rv;
 }
 
 static void recover_idr_del(struct dlm_rsb *r)
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

