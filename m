From: akpm@linux-foundation.org
Subject: + bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:56:04 -0800
Message-ID: <200803060656.m266u4xb013591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757915AbYCFG4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, adaplas@pol.net, bryan.wu@analog.com


The patch titled
     BF54x LQ043 Framebuffer driver: fix bug NULL for gpio_request label is not allowed
has been added to the -mm tree.  Its filename is
     bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed.patch

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
Subject: BF54x LQ043 Framebuffer driver: fix bug NULL for gpio_request label is not allowed
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bf54x-lq043fb.c~bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed
+++ a/drivers/video/bf54x-lq043fb.c
@@ -241,7 +241,7 @@ static int request_ports(struct bfin_bf5
 	u16 eppi_req_18[] = EPPI0_18;
 	u16 disp = fbi->mach_info->disp;
 
-	if (gpio_request(disp, NULL)) {
+	if (gpio_request(disp, DRIVER_NAME)) {
 		printk(KERN_ERR "Requesting GPIO %d faild\n", disp);
 		return -EFAULT;
 	}
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed.patch
bf54x-lq043-framebuffer-driver-update-copyright-on-previously-modified-files.patch

