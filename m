From: akpm@linux-foundation.org
Subject: - pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:22 -0800
Message-ID: <200802070030.m170U340007352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935111AbYBGApp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, ambx1@neo.rr.com, bjorn.helgaas@hp.com, drzeus@drzeus.cx, linux@rainbow-software.org, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     PNP: do not test PNP_DRIVER_RES_DO_NOT_CHANGE on suspend/resume
has been removed from the -mm tree.  Its filename was
     pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: do not test PNP_DRIVER_RES_DO_NOT_CHANGE on suspend/resume
From: Rene Herman <rene.herman@keyaccess.nl>

The PNP_DRIVER_RES_DO_NOT_CHANGE flag is meant to signify that the PNP core
should not change resources for the device -- not that it shouldn't
disable/enable the device on suspend/resume.

ALSA ISAPnP drivers set PNP_DRIVER_RES_DO_NOT_CHANAGE (0x0001) through
setting PNP_DRIVER_RES_DISABLE (0x0003).  The latter including the former
may in itself be considered rather unexpected but doesn't change that
suspend/resume wouldn't seem to have any business testing the flag.

As reported by Ondrej Zary for snd-cs4236, ALSA driven ISAPnP cards don't
survive swsusp hibernation with the resume skipping setting the resources
due to testing the flag -- the same test in the suspend path isn't enough
to keep hibernation from disabling the card it seems.

These tests were added (in 2005) by Piere Ossman in commit
68094e3251a664ee1389fcf179497237cbf78331, "alsa: Improved PnP suspend
support" who doesn't remember why.  This deletes them.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/driver.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/pnp/driver.c~pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume
+++ a/drivers/pnp/driver.c
@@ -161,8 +161,7 @@ static int pnp_bus_suspend(struct device
 			return error;
 	}
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
-	    pnp_can_disable(pnp_dev)) {
+	if (pnp_can_disable(pnp_dev)) {
 		error = pnp_stop_dev(pnp_dev);
 		if (error)
 			return error;
@@ -185,14 +184,17 @@ static int pnp_bus_resume(struct device 
 	if (pnp_dev->protocol && pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
+	if (pnp_can_write(pnp_dev)) {
 		error = pnp_start_dev(pnp_dev);
 		if (error)
 			return error;
 	}
 
-	if (pnp_drv->resume)
-		return pnp_drv->resume(pnp_dev);
+	if (pnp_drv->resume) {
+		error = pnp_drv->resume(pnp_dev);
+		if (error)
+			return error;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

origin.patch
