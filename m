From: akpm@linux-foundation.org
Subject: [merged] firewire-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:34 -0800
Message-ID: <20130228201235.279D831C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37823 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab3B1UMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:36 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so244859ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     firewire-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: firewire: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
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

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

