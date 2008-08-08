From: akpm@linux-foundation.org
Subject: - cxacru-fix-printk-format-flag-in-error-message.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:24 -0700
Message-ID: <200808082208.m78M8OSX031248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765011AbYHHWMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, mm-commits@vger.kernel.org


The patch titled
     cxacru: fix printk format flag in error message
has been removed from the -mm tree.  Its filename was
     cxacru-fix-printk-format-flag-in-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cxacru: fix printk format flag in error message
From: Simon Arlott <simon@fire.lp0.eu>

"#%x" should have been "%#x"

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/atm/cxacru.c~cxacru-fix-printk-format-flag-in-error-message drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~cxacru-fix-printk-format-flag-in-error-message
+++ a/drivers/usb/atm/cxacru.c
@@ -602,7 +602,7 @@ static int cxacru_cm_get_array(struct cx
 			offd = le32_to_cpu(buf[offb++]);
 			if (offd >= size) {
 				if (printk_ratelimit())
-					usb_err(instance->usbatm, "wrong index #%x in response to cm #%x\n",
+					usb_err(instance->usbatm, "wrong index %#x in response to cm %#x\n",
 						offd, cm);
 				ret = -EIO;
 				goto cleanup;
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

linux-next.patch
v4l-link-tuner-before-saa7134.patch

