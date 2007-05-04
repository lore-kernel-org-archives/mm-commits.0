From: akpm@linux-foundation.org
Subject: + cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch added to -mm tree
Date: Fri, 04 May 2007 14:51:09 -0700
Message-ID: <200705042151.l44Lp955017621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376125AbXEDVv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:51:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr


The patch titled
     cxacru: ignore error trying to start ADSL in atm_start
has been added to the -mm tree.  Its filename is
     cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 6 deletions(-)

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
cxacru-add-documentation-file.patch
cxacru-cleanup-sysfs-attribute-code.patch
cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
maintainers-add-cxacru-website-mailing-list.patch
cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
