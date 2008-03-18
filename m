From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-atmelc-use-time_-macros.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:22:56 -0700
Message-ID: <200803180422.m2I4MuFn013942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752236AbYCREYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, linville@tuxdriver.com


The patch titled
     drivers/net/wireless/atmel.c: use time_* macros
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-atmelc-use-time_-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/atmel.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctly.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/atmel.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/atmel.c~drivers-net-wireless-atmelc-use-time_-macros drivers/net/wireless/atmel.c
--- a/drivers/net/wireless/atmel.c~drivers-net-wireless-atmelc-use-time_-macros
+++ a/drivers/net/wireless/atmel.c
@@ -66,6 +66,7 @@
 #include <linux/device.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
 #include <net/ieee80211.h>
 #include "atmel.h"
 
@@ -516,7 +517,7 @@ struct atmel_private {
 		SITE_SURVEY_IN_PROGRESS,
 		SITE_SURVEY_COMPLETED
 	} site_survey_state;
-	time_t last_survey;
+	unsigned long last_survey;
 
 	int station_was_associated, station_is_associated;
 	int fast_scan;
@@ -2283,7 +2284,7 @@ static int atmel_set_scan(struct net_dev
 		return -EAGAIN;
 
 	/* Timeout old surveys. */
-	if ((jiffies - priv->last_survey) > (20 * HZ))
+	if (time_after(jiffies, priv->last_survey + 20 * HZ))
 		priv->site_survey_state = SITE_SURVEY_IDLE;
 	priv->last_survey = jiffies;
 
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

