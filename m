From: akpm@linux-foundation.org
Subject: + pps-add-parallel-port-pps-client-v7.patch added to -mm tree
Date: Tue, 21 Dec 2010 15:13:08 -0800
Message-ID: <201012212313.oBLND8Dx031594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740Ab0LUXNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 18:13:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: add parallel port PPS client
has been added to the -mm tree.  Its filename is
     pps-add-parallel-port-pps-client-v7.patch

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
Subject: pps: add parallel port PPS client
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps_parport.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/pps/clients/pps_parport.c~pps-add-parallel-port-pps-client-v7 drivers/pps/clients/pps_parport.c
--- a/drivers/pps/clients/pps_parport.c~pps-add-parallel-port-pps-client-v7
+++ a/drivers/pps/clients/pps_parport.c
@@ -79,6 +79,17 @@ static void parport_irq(void *handle)
 		goto out_assert;
 
 	/* try capture the clear edge */
+
+	/* We have to disable interrupts here. The idea is to prevent
+	 * other interrupts on the same processor to introduce random
+	 * lags while polling the port. Reading from IO port is known
+	 * to take approximately 1us while other interrupt handlers can
+	 * take much more potentially.
+	 *
+	 * Interrupts won't be disabled for a long time because the
+	 * number of polls is limited by clear_wait parameter which is
+	 * kept rather low. So it should never be an issue.
+	 */
 	local_irq_save(flags);
 	/* check the signal (no signal means the pulse is lost this time) */
 	if (!signal_is_set(port)) {
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
pps-capture-monotonic_raw-timestamps-as-well-v7.patch
pps-add-kernel-consumer-support.patch
pps-add-kernel-consumer-support-v7.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-client-v7.patch
pps-add-parallel-port-pps-signal-generator.patch

