From: akpm@linux-foundation.org
Subject: [merged] watchdog-using-u64-in-get_sample_period.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:42 -0800
Message-ID: <20121130212842.A1A83100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51854 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2K3V2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:44 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so104104ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuansheng.liu@intel.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: using u64 in get_sample_period()
has been removed from the -mm tree.  Its filename was
     watchdog-using-u64-in-get_sample_period.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: watchdog: using u64 in get_sample_period()

In get_sample_period(), unsigned long is not enough:
watchdog_thresh * 2 * (NSEC_PER_SEC / 5)

case1: watchdog_thresh is 10 by default,
the sample value will be: 0xEE6B 2800

case2: set watchdog_thresh is 20,
the sample value will be: 0x1 DCD6 5000

In case2, we need use u64 to express the sample period.  Otherwise,
Changing the threshold thru proc often can not be successful.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-using-u64-in-get_sample_period kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-using-u64-in-get_sample_period
+++ a/kernel/watchdog.c
@@ -116,7 +116,7 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -125,7 +125,7 @@ static unsigned long get_sample_period(v
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
_

Patches currently in -mm which might be from chuansheng.liu@intel.com are

origin.patch
linux-next.patch

