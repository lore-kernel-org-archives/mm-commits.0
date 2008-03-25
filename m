From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-atmelc-use-time_-macros.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:55 -0700
Message-ID: <200803250019.m2P0Jt6m032723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbYCYAWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/atmel.c: use time_* macros
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-atmelc-use-time_-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-net.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
fix-indentation.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch

