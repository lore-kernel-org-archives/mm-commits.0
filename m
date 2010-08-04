From: akpm@linux-foundation.org
Subject: + pps-use-bug_on-for-kernel-api-safety-checks.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:33 -0700
Message-ID: <201008042338.o74NcXhe017014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab0HDX7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 19:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


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
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff -puN drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks
+++ a/drivers/pps/kapi.c
@@ -80,25 +80,14 @@ struct pps_device *pps_register_source(s
 	int err;
 
 	/* Sanity checks */
-	if ((info->mode & default_params) != default_params) {
-		pr_err("pps: %s: unsupported default parameters\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
-	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
-			info->echo == NULL) {
-		pr_err("pps: %s: echo function is not defined\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
-	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
-		pr_err("pps: %s: unspecified time format\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
+
+	/* default_params should be supported */
+	BUG_ON((info->mode & default_params) != default_params);
+	/* echo function should be defined if we are asked to call it */
+	BUG_ON((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
+			info->echo == NULL);
+	/* time format should be specified */
+	BUG_ON((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0);
 
 	/* Allocate memory for the new PPS source struct */
 	pps = kzalloc(sizeof(struct pps_device), GFP_KERNEL);
@@ -175,10 +164,8 @@ void pps_event(struct pps_device *pps, s
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
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

