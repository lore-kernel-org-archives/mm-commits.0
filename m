From: akpm@linux-foundation.org
Subject: [merged] mlx4-remove-leftover-idr_pre_get-call.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:24 -0700
Message-ID: <20130314185224.616F95A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:42905 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3CNSwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:25 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so258334ves.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mlx4: remove leftover idr_pre_get() call
has been removed from the -mm tree.  Its filename was
     mlx4-remove-leftover-idr_pre_get-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

