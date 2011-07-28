From: akpm@linux-foundation.org
Subject: + pps-default-echo-function.patch added to -mm tree
Date: Thu, 28 Jul 2011 16:08:41 -0700
Message-ID: <201107282308.p6SN8f6Z013887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352Ab1G1XI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 19:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jamesnuss@nanometrics.ca, bengardiner@nanometrics.ca, giometti@linux.it, lasaine@lvk.cs.msu.su, plyatov@gmail.com, rasm@fe.up.pt


The patch titled
     pps: default echo function
has been added to the -mm tree.  Its filename is
     pps-default-echo-function.patch

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
Subject: pps: default echo function
From: James Nuss <jamesnuss@nanometrics.ca>

A default echo function has been provided so it is no longer an error when
you specify PPS_ECHOASSERT or PPS_ECHOCLEAR without an explicit echo
function.  This allows some code re-use and also makes it easier to write
client drivers since the default echo function does not normally need to
change.

Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Cc: Ricardo Martins <rasm@fe.up.pt>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Igor Plyatov <plyatov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c  |   12 ------------
 drivers/pps/clients/pps_parport.c |    9 ---------
 drivers/pps/kapi.c                |   20 +++++++++++++-------
 3 files changed, 13 insertions(+), 28 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-default-echo-function drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-default-echo-function
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -52,17 +52,6 @@ static void pps_ktimer_event(unsigned lo
 }
 
 /*
- * The echo function
- */
-
-static void pps_ktimer_echo(struct pps_device *pps, int event, void *data)
-{
-	dev_info(pps->dev, "echo %s %s\n",
-		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "");
-}
-
-/*
  * The PPS info struct
  */
 
@@ -72,7 +61,6 @@ static struct pps_source_info pps_ktimer
 	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 			  PPS_ECHOASSERT |
 			  PPS_CANWAIT | PPS_TSFMT_TSPEC,
-	.echo		= pps_ktimer_echo,
 	.owner		= THIS_MODULE,
 };
 
diff -puN drivers/pps/clients/pps_parport.c~pps-default-echo-function drivers/pps/clients/pps_parport.c
--- a/drivers/pps/clients/pps_parport.c~pps-default-echo-function
+++ a/drivers/pps/clients/pps_parport.c
@@ -133,14 +133,6 @@ out_both:
 	return;
 }
 
-/* the PPS echo function */
-static void pps_echo(struct pps_device *pps, int event, void *data)
-{
-	dev_info(pps->dev, "echo %s %s\n",
-		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "");
-}
-
 static void parport_attach(struct parport *port)
 {
 	struct pps_client_pp *device;
@@ -151,7 +143,6 @@ static void parport_attach(struct parpor
 				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
 				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
 				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
-		.echo		= pps_echo,
 		.owner		= THIS_MODULE,
 		.dev		= NULL
 	};
diff -puN drivers/pps/kapi.c~pps-default-echo-function drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-default-echo-function
+++ a/drivers/pps/kapi.c
@@ -52,6 +52,14 @@ static void pps_add_offset(struct pps_kt
 	ts->sec += offset->sec;
 }
 
+static void pps_echo_client_default(struct pps_device *pps, int event,
+		void *data)
+{
+	dev_info(pps->dev, "echo %s %s\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "");
+}
+
 /*
  * Exported functions
  */
@@ -80,13 +88,6 @@ struct pps_device *pps_register_source(s
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
-	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
-			info->echo == NULL) {
-		pr_err("%s: echo function is not defined\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
 	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
 		pr_err("%s: unspecified time format\n",
 					info->name);
@@ -108,6 +109,11 @@ struct pps_device *pps_register_source(s
 	pps->params.mode = default_params;
 	pps->info = *info;
 
+	/* check for default echo function */
+	if ((pps->info.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) &&
+			pps->info.echo == NULL)
+		pps->info.echo = pps_echo_client_default;
+
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
_

Patches currently in -mm which might be from jamesnuss@nanometrics.ca are

pps-default-echo-function.patch
pps-new-client-driver-using-gpio.patch
pps-new-client-driver-using-gpio-fix.patch

