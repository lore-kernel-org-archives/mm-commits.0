From: akpm@linux-foundation.org
Subject: + firedtv-fix-regression-tuning-fails-due-to-bogus-error-return.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:46:47 -0800
Message-ID: <200911030646.nA36klJW017404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZKCGrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de, mchehab@infradead.org, rjw@sisk.pl


The patch titled
     firedtv: fix regression: tuning fails due to bogus error return
has been added to the -mm tree.  Its filename is
     firedtv-fix-regression-tuning-fails-due-to-bogus-error-return.patch

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
Subject: firedtv: fix regression: tuning fails due to bogus error return
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Since 2.6.32(-rc1), DVB core checks the return value of
dvb_frontend_ops.set_frontend.  Now it becomes apparent that firedtv
always returned a bogus value from its set_frontend method.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/firewire/firedtv-avc.c |    7 +++++--
 drivers/media/dvb/firewire/firedtv-fe.c  |    8 +-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/media/dvb/firewire/firedtv-avc.c~firedtv-fix-regression-tuning-fails-due-to-bogus-error-return drivers/media/dvb/firewire/firedtv-avc.c
--- a/drivers/media/dvb/firewire/firedtv-avc.c~firedtv-fix-regression-tuning-fails-due-to-bogus-error-return
+++ a/drivers/media/dvb/firewire/firedtv-avc.c
@@ -573,8 +573,11 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 
 	msleep(500);
 #if 0
-	/* FIXME: */
-	/* u8 *status was an out-parameter of avc_tuner_dsd, unused by caller */
+	/*
+	 * FIXME:
+	 * u8 *status was an out-parameter of avc_tuner_dsd, unused by caller
+	 * Check for AVC_RESPONSE_ACCEPTED here instead?
+	 */
 	if (status)
 		*status = r->operand[2];
 #endif
diff -puN drivers/media/dvb/firewire/firedtv-fe.c~firedtv-fix-regression-tuning-fails-due-to-bogus-error-return drivers/media/dvb/firewire/firedtv-fe.c
--- a/drivers/media/dvb/firewire/firedtv-fe.c~firedtv-fix-regression-tuning-fails-due-to-bogus-error-return
+++ a/drivers/media/dvb/firewire/firedtv-fe.c
@@ -141,18 +141,12 @@ static int fdtv_read_uncorrected_blocks(
 	return -EOPNOTSUPP;
 }
 
-#define ACCEPTED 0x9
