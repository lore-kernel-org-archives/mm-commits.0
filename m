From: akpm@linux-foundation.org
Subject: + cxacru-fix-printk-format-flag-in-error-message.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:20:17 -0700
Message-ID: <200807130120.m6D1KHR1030394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYGMBUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 21:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu


The patch titled
     cxacru: fix printk format flag in error message
has been added to the -mm tree.  Its filename is
     cxacru-fix-printk-format-flag-in-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cxacru-fix-printk-format-flag-in-error-message.patch

