From: akpm@linux-foundation.org
Subject: [merged] pps-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:00 -0800
Message-ID: <20130228201500.9B48B31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:56709 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3B1UPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:01 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245123yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     pps-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: pps: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    2 +-
 drivers/pps/pps.c  |   36 ++++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff -puN drivers/pps/kapi.c~pps-convert-to-idr_alloc drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-convert-to-idr_alloc
+++ a/drivers/pps/kapi.c
@@ -102,7 +102,7 @@ struct pps_device *pps_register_source(s
 		goto pps_register_source_exit;
 	}
 
-	/* These initializations must be done before calling idr_get_new()
+	/* These initializations must be done before calling idr_alloc()
 	 * in order to avoid reces into pps_event().
 	 */
 	pps->params.api_version = PPS_API_VERS;
diff -puN drivers/pps/pps.c~pps-convert-to-idr_alloc drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-convert-to-idr_alloc
+++ a/drivers/pps/pps.c
@@ -295,29 +295,21 @@ int pps_register_cdev(struct pps_device 
 	dev_t devt;
 
 	mutex_lock(&pps_idr_lock);
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		mutex_unlock(&pps_idr_lock);
-		return -ENOMEM;
-	}
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
+	/*
+	 * Get new ID for the new PPS source.  After idr_alloc() calling
+	 * the new source will be freely available into the kernel.
 	 */
-	err = idr_get_new(&pps_idr, pps, &pps->id);
-	mutex_unlock(&pps_idr_lock);
-
-	if (err < 0)
-		return err;
-
-	pps->id &= MAX_IDR_MASK;
-	if (pps->id >= PPS_MAX_SOURCES) {
-		pr_err("%s: too many PPS sources in the system\n",
-					pps->info.name);
-		err = -EBUSY;
-		goto free_idr;
+	err = idr_alloc(&pps_idr, pps, 0, PPS_MAX_SOURCES, GFP_KERNEL);
+	if (err < 0) {
+		if (err == -ENOSPC) {
+			pr_err("%s: too many PPS sources in the system\n",
+			       pps->info.name);
+			err = -EBUSY;
+		}
+		goto out_unlock;
 	}
+	pps->id = err;
+	mutex_unlock(&pps_idr_lock);
 
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
@@ -351,8 +343,8 @@ del_cdev:
 free_idr:
 	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
+out_unlock:
 	mutex_unlock(&pps_idr_lock);
