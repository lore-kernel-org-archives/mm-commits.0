From: akpm@linux-foundation.org
Subject: [to-be-updated] rpmsg-dont-use-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:00:57 -0800
Message-ID: <20130206220057.994D55A424B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38156 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3BFWA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:00:58 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so205886vch.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:00:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rpmsg: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     rpmsg-dont-use-idr_remove_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: rpmsg: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rpmsg/virtio_rpmsg_bus.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-dont-use-idr_remove_all drivers/rpmsg/virtio_rpmsg_bus.c
--- a/drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-dont-use-idr_remove_all
+++ a/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1036,7 +1036,6 @@ static void rpmsg_remove(struct virtio_d
 	if (vrp->ns_ept)
 		__rpmsg_destroy_ept(vrp, vrp->ns_ept);
 
-	idr_remove_all(&vrp->endpoints);
 	idr_destroy(&vrp->endpoints);
 
 	vdev->config->del_vqs(vrp->vdev);
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
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch

