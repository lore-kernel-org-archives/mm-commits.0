From: akpm@linux-foundation.org
Subject: + mlx4-remove-leftover-idr_pre_get-call.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:14 -0800
Message-ID: <20130305220814.A5AEF5A41D3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53099 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:15 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so791914vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com, roland@purestorage.com


The patch titled
     Subject: mlx4: remove leftover idr_pre_get() call
has been added to the -mm tree.  Its filename is
     mlx4-remove-leftover-idr_pre_get-call.patch

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
Subject: mlx4: remove leftover idr_pre_get() call

6a9200603d ("IB/mlx4: convert to idr_alloc()") forgot to remove
idr_pre_get() call in mlx4_ib_cm_paravirt_init().  It's unnecessary
and idr_pre_get() will soon be deprecated.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mlx4/cm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/infiniband/hw/mlx4/cm.c~mlx4-remove-leftover-idr_pre_get-call drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~mlx4-remove-leftover-idr_pre_get-call
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -362,7 +362,6 @@ void mlx4_ib_cm_paravirt_init(struct mlx
 	INIT_LIST_HEAD(&dev->sriov.cm_list);
 	dev->sriov.sl_id_map = RB_ROOT;
 	idr_init(&dev->sriov.pv_id_table);
-	idr_pre_get(&dev->sriov.pv_id_table, GFP_KERNEL);
 }
 
 /* slave = -1 ==> all slaves */
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

