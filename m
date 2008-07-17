From: akpm@linux-foundation.org
Subject: + sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size.patch added to -mm tree
Date: Thu, 17 Jul 2008 15:20:23 -0700
Message-ID: <200807172220.m6HMKOAi009543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755732AbYGQWVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 18:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     Subject: SM501: Align PANEL fb to PAGE_SIZE
has been added to the -mm tree.  Its filename is
     sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size.patch

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
Subject: Subject: SM501: Align PANEL fb to PAGE_SIZE
From: Ben Dooks <ben-linux@fluff.org>

Some programs, such as anything linked with directfb get
the drawing wrong if given an screen start which is not
aligned to PAGE_SIZE. Change the allocator to always return
an properly aligned address when asked for PANEL memory.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt1/drivers/video/sm501fb.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size
+++ a/drivers/video/sm501fb.c
@@ -162,6 +162,13 @@ static int sm501_alloc_mem(struct sm501f
 		ptr = inf->fbmem_len - size;
 		fbi = inf->fb[HEAD_CRT];
 
+		/* round down, some programs such as directfb do not draw
+		 * 0,0 correctly unless the start is aligned to a page start.
+		*/
+
+		if (ptr > 0)
+			ptr &= ~(PAGE_SIZE - 1);
+
 		if (fbi && ptr < fbi->fix.smem_len)
 			return -ENOMEM;
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch
lcd-add-platform_lcd-driver-fix.patch
lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch

