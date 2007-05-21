From: akpm@linux-foundation.org
Subject: - cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:16 -0700
Message-ID: <200705212317.l4LNHFRc022454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758731AbXEUXTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, mm-commits@vger.kernel.org


The patch titled
     cxacru: ignore error trying to start ADSL in atm_start
has been removed from the -mm tree.  Its filename was
     cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxacru: ignore error trying to start ADSL in atm_start
From: Simon Arlott <simon@fire.lp0.eu>

The sysfs adsl_status attribute ignores (aside from returning -EIO to the
user) any error sending a START/STOP command to the device and there is at
least one firmware which never sends a response but appears to work
regardless.  Therefore atm_start should also continue if an error is received
so that such firmware is usable.

The official Conexant driver doesn't expect a reply either but this is for
another device (E2 router) and a commonly used firmware does respond.

Also, there is no point in changing -ECONNRESET to -ETIMEDOUT since nothing
ever checks for either of these values.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/usb/atm/cxacru.c~cxacru-ignore-error-trying-to-start-adsl-in-atm_start drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~cxacru-ignore-error-trying-to-start-adsl-in-atm_start
+++ a/drivers/usb/atm/cxacru.c
@@ -465,8 +465,6 @@ static int cxacru_start_wait_urb(struct 
 	add_timer(&timer);
 	wait_for_completion(done);
 	status = urb->status;
-	if (status == -ECONNRESET)
-		status = -ETIMEDOUT;
 	del_timer_sync(&timer);
 
 	if (actual_length)
@@ -660,11 +658,8 @@ static int cxacru_atm_start(struct usbat
 	/* start ADSL */
 	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
-	if (ret < 0) {
+	if (ret < 0)
 		atm_err(usbatm_instance, "cxacru_atm_start: CHIP_ADSL_LINE_START returned %d\n", ret);
-		mutex_unlock(&instance->adsl_state_serialize);
-		return ret;
-	}
 
 	/* Start status polling */
 	mutex_lock(&instance->poll_state_serialize);
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
git-dvb.patch
git-sh.patch
git-xtensa.patch
