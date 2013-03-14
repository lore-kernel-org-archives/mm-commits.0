From: akpm@linux-foundation.org
Subject: [merged] zcache-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:27 -0700
Message-ID: <20130314185227.7827B5A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43493 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3CNSw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:28 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so250751vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, dan.magenheimer@oracle.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zcache: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     zcache-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: zcache: convert to idr_alloc()

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/ramster/tcp.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN drivers/staging/zcache/ramster/tcp.c~zcache-convert-to-idr_alloc drivers/staging/zcache/ramster/tcp.c
--- a/drivers/staging/zcache/ramster/tcp.c~zcache-convert-to-idr_alloc
+++ a/drivers/staging/zcache/ramster/tcp.c
@@ -300,27 +300,22 @@ static u8 r2net_num_from_nn(struct r2net
 
 static int r2net_prep_nsw(struct r2net_node *nn, struct r2net_status_wait *nsw)
 {
-	int ret = 0;
+	int ret;
 
-	do {
-		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
-			ret = -EAGAIN;
-			break;
-		}
-		spin_lock(&nn->nn_lock);
-		ret = idr_get_new(&nn->nn_status_idr, nsw, &nsw->ns_id);
-		if (ret == 0)
-			list_add_tail(&nsw->ns_node_item,
-				      &nn->nn_status_list);
-		spin_unlock(&nn->nn_lock);
-	} while (ret == -EAGAIN);
+	spin_lock(&nn->nn_lock);
+	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
+	if (ret >= 0) {
+		nsw->ns_id = ret;
+		list_add_tail(&nsw->ns_node_item, &nn->nn_status_list);
+	}
+	spin_unlock(&nn->nn_lock);
 
-	if (ret == 0)  {
+	if (ret >= 0) {
 		init_waitqueue_head(&nsw->ns_wq);
 		nsw->ns_sys_status = R2NET_ERR_NONE;
 		nsw->ns_status = 0;
+		return 0;
 	}
-
 	return ret;
 }
 
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

