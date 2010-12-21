From: akpm@linux-foundation.org
Subject: + ntp-add-hardpps-implementation-update-v7.patch added to -mm tree
Date: Tue, 21 Dec 2010 15:07:10 -0800
Message-ID: <201012212307.oBLN7AvQ031382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0LUXHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 18:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com


The patch titled
     ntp-add-hardpps-implementation-update-v7
has been added to the -mm tree.  Its filename is
     ntp-add-hardpps-implementation-update-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
ntp-add-hardpps-implementation-update-v7.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

