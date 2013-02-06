From: akpm@linux-foundation.org
Subject: [to-be-updated] dm-dont-use-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:00:51 -0800
Message-ID: <20130206220051.A73F931C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:49522 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab3BFWAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:00:53 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so205873vch.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:00:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dm: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     dm-dont-use-idr_remove_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dm: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/md/dm.c~dm-dont-use-idr_remove_all drivers/md/dm.c
--- a/drivers/md/dm.c~dm-dont-use-idr_remove_all
+++ a/drivers/md/dm.c
@@ -318,7 +318,6 @@ static void __exit dm_exit(void)
 	/*
 	 * Should be empty by this point.
 	 */
-	idr_remove_all(&_minor_idr);
 	idr_destroy(&_minor_idr);
 }
 
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
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch

