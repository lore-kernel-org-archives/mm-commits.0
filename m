From: akpm@linux-foundation.org
Subject: + pps-use-bug_on-for-kernel-api-safety-checks.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:20:04 -0800
Message-ID: <201012180020.oBI0K4HM004913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756699Ab0LRAUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: use BUG_ON for kernel API safety checks
has been added to the -mm tree.  Its filename is
     pps-use-bug_on-for-kernel-api-safety-checks.patch

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
Subject: pps: use BUG_ON for kernel API safety checks
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

This way less overhead is involved when running production kernel.  If you
want to debug a pps client module please define DEBUG to enable the
checks.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks
+++ a/drivers/pps/kapi.c
@@ -166,10 +166,8 @@ void pps_event(struct pps_device *pps, s
 	int captured = 0;
 	struct pps_ktime ts_real;
 
-	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
-		dev_err(pps->dev, "unknown event (%x)\n", event);
-		return;
-	}
+	/* check event type */
+	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
 
 	dev_dbg(pps->dev, "PPS event at %ld.%09ld\n",
 			ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

