From: akpm@linux-foundation.org
Subject: - bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:44 -0700
Message-ID: <200803110322.m2B3Miot019834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYCKDWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, adaplas@pol.net, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     BF54x LQ043 Framebuffer driver: fix bug NULL for gpio_request label is not allowed
has been removed from the -mm tree.  Its filename was
     bf54x-lq043-framebuffer-driver-fix-bug-null-for-gpio_request-label-is-not-allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

