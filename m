From: akpm@linux-foundation.org
Subject: + workqueue-convert-to-idr_alloc.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:12 -0800
Message-ID: <20130305220812.C02AA31C1C6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:58368 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:13 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so791581ggn.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: workqueue: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     workqueue-convert-to-idr_alloc.patch

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
Subject: workqueue: convert to idr_alloc()

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueue-convert-to-idr_alloc kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-convert-to-idr_alloc
+++ a/kernel/workqueue.c
@@ -457,11 +457,12 @@ static int worker_pool_assign_id(struct
 	int ret;
 
 	mutex_lock(&worker_pool_idr_mutex);
-	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
-	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
+	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
+	if (ret >= 0)
+		pool->id = ret;
 	mutex_unlock(&worker_pool_idr_mutex);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 /*
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

