From: akpm@linux-foundation.org
Subject: + watchdog-using-u64-in-get_sample_period.patch added to -mm tree
Date: Wed, 21 Nov 2012 14:26:46 -0800
Message-ID: <20121121222647.1044E20047B@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57254 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2KVU5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Nov 2012 15:57:35 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so568458lag.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Nov 2012 12:57:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuansheng.liu@intel.com, dzickus@redhat.com


The patch titled
     Subject: watchdog: using u64 in get_sample_period()
has been added to the -mm tree.  Its filename is
     watchdog-using-u64-in-get_sample_period.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
watchdog-using-u64-in-get_sample_period.patch

