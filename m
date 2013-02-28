From: akpm@linux-foundation.org
Subject: [merged] thermal-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:21 -0800
Message-ID: <20130228201521.9D99E31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:37529 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3B1UPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:22 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245255yen.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     thermal-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: thermal: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/cpu_cooling.c |   17 +++++------------
 drivers/thermal/thermal_sys.c |   17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff -puN drivers/thermal/cpu_cooling.c~thermal-convert-to-idr_alloc drivers/thermal/cpu_cooling.c
--- a/drivers/thermal/cpu_cooling.c~thermal-convert-to-idr_alloc
+++ a/drivers/thermal/cpu_cooling.c
@@ -73,21 +73,14 @@ static struct cpufreq_cooling_device *no
  */
 static int get_idr(struct idr *idr, int *id)
 {
-	int err;
-again:
-	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
+	int ret;
 
 	mutex_lock(&cooling_cpufreq_lock);
-	err = idr_get_new(idr, NULL, id);
+	ret = idr_alloc(idr, NULL, 0, 0, GFP_KERNEL);
 	mutex_unlock(&cooling_cpufreq_lock);
-
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return err;
-
-	*id = *id & MAX_IDR_MASK;
+	if (unlikely(ret < 0))
+		return ret;
+	*id = ret;
 	return 0;
 }
 
diff -puN drivers/thermal/thermal_sys.c~thermal-convert-to-idr_alloc drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-convert-to-idr_alloc
+++ a/drivers/thermal/thermal_sys.c
@@ -132,23 +132,16 @@ EXPORT_SYMBOL_GPL(thermal_unregister_gov
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
-	int err;
-
-again:
-	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
+	int ret;
 
 	if (lock)
 		mutex_lock(lock);
-	err = idr_get_new(idr, NULL, id);
+	ret = idr_alloc(idr, NULL, 0, 0, GFP_KERNEL);
 	if (lock)
 		mutex_unlock(lock);
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return err;
