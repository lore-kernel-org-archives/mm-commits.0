From: akpm@linux-foundation.org
Subject: [merged] macvtap-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:51 -0800
Message-ID: <20130228201451.B79095A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48125 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:52 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so39803qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jasowang@redhat.com, mst@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: macvtap: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     macvtap-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: macvtap: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/macvtap.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN drivers/net/macvtap.c~macvtap-convert-to-idr_alloc drivers/net/macvtap.c
--- a/drivers/net/macvtap.c~macvtap-convert-to-idr_alloc
+++ a/drivers/net/macvtap.c
@@ -279,28 +279,17 @@ static int macvtap_receive(struct sk_buf
 static int macvtap_get_minor(struct macvlan_dev *vlan)
 {
 	int retval = -ENOMEM;
-	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&minor_idr, GFP_KERNEL) == 0)
-		goto exit;
-
-	retval = idr_get_new_above(&minor_idr, vlan, 1, &id);
-	if (retval < 0) {
-		if (retval == -EAGAIN)
-			retval = -ENOMEM;
-		goto exit;
-	}
-	if (id < MACVTAP_NUM_DEVS) {
-		vlan->minor = id;
-	} else {
+	retval = idr_alloc(&minor_idr, vlan, 1, MACVTAP_NUM_DEVS, GFP_KERNEL);
+	if (retval >= 0) {
+		vlan->minor = retval;
+	} else if (retval == -ENOSPC) {
 		printk(KERN_ERR "too many macvtap devices\n");
 		retval = -EINVAL;
-		idr_remove(&minor_idr, id);
 	}
-exit:
 	mutex_unlock(&minor_lock);
-	return retval;
+	return retval < 0 ? retval : 0;
 }
 
 static void macvtap_free_minor(struct macvlan_dev *vlan)
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

