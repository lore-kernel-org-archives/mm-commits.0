From: akpm@linux-foundation.org
Subject: [merged] pps-default-echo-function.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:08 -0800
Message-ID: <201111072029.pA7KT85r022367@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1KGU3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jamesnuss@nanometrics.ca, bengardiner@nanometrics.ca, giometti@linux.it, lasaine@lvk.cs.msu.su, plyatov@gmail.com, rasm@fe.up.pt, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: default echo function
has been removed from the -mm tree.  Its filename was
     pps-default-echo-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: James Nuss <jamesnuss@nanometrics.ca>
Subject: pps: default echo function

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

origin.patch

