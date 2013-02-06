From: akpm@linux-foundation.org
Subject: [to-be-updated] firewire-dont-use-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:00:45 -0800
Message-ID: <20130206220045.997F35A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44594 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab3BFWAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:00:46 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so206528ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:00:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     firewire-dont-use-idr_remove_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: firewire: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-cdev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/firewire/core-cdev.c~firewire-dont-use-idr_remove_all drivers/firewire/core-cdev.c
--- a/drivers/firewire/core-cdev.c~firewire-dont-use-idr_remove_all
+++ a/drivers/firewire/core-cdev.c
@@ -1779,7 +1779,6 @@ static int fw_device_op_release(struct i
 	wait_event(client->tx_flush_wait, !has_outbound_transactions(client));
 
 	idr_for_each(&client->resource_idr, shutdown_resource, client);
-	idr_remove_all(&client->resource_idr);
 	idr_destroy(&client->resource_idr);
 
 	list_for_each_entry_safe(event, next_event, &client->event_list, link)
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

