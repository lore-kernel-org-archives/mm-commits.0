From: akpm@linux-foundation.org
Subject: [folded] ntp-add-hardpps-implementation-update-v7.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:26:29 -0800
Message-ID: <201101130026.p0D0QTci012429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1AMA1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:27:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ntp-add-hardpps-implementation-update-v7
has been removed from the -mm tree.  Its filename was
     ntp-add-hardpps-implementation-update-v7.patch

This patch was dropped because it was folded into ntp-add-hardpps-implementation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp-add-hardpps-implementation-update-v7
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pps/Kconfig~ntp-add-hardpps-implementation-update-v7 drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~ntp-add-hardpps-implementation-update-v7
+++ a/drivers/pps/Kconfig
@@ -32,11 +32,13 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on PPS
+	depends on PPS && !NO_HZ
 	help
 	  This option adds support for direct in-kernel time
 	  syncronization using an external PPS signal.
 
+	  It doesn't work on tickless systems at the moment.
+
 source drivers/pps/clients/Kconfig
 
 endmenu
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-make-idr-lock-a-mutex-and-protect-idr_pre_get.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-capture-monotonic_raw-timestamps-as-well-v7.patch
pps-add-kernel-consumer-support.patch
pps-add-kernel-consumer-support-v7.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-client-v7.patch
pps-add-parallel-port-pps-signal-generator.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
pps-add-parallel-port-pps-signal-generator-v7.patch

