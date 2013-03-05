From: akpm@linux-foundation.org
Subject: + zcache-convert-to-idr_alloc.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:08:16 -0800
Message-ID: <20130305220816.B99FC5A41D3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:38235 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CEWIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:08:17 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so794077yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:08:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, dan.magenheimer@oracle.com, gregkh@linuxfoundation.org


The patch titled
     Subject: zcache: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     zcache-convert-to-idr_alloc.patch

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

