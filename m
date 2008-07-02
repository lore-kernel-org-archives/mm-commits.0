From: akpm@linux-foundation.org
Subject: + sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:29:06 -0700
Message-ID: <200807022329.m62NT6aT009312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYGBX3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     sm501: fixup allocation code to be 64bit resource compliant
has been added to the -mm tree.  Its filename is
     sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch

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
Subject: sm501: fixup allocation code to be 64bit resource compliant
From: Ben Dooks <ben-linux@fluff.org>

As pointed out by Andrew Morton, we have a problem when setting the 64bit
resources option.  Alter the allocation routines to remove the need to use
the start and end fields, use the proper HEAD_PANEL/HEAD_CRT and update
the comments.

Note, we also fix the bug where we failed to check the size of the
CRT memory allocation.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-fixup-allocation-code-to-be-64bit-resource-compliant drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-fixup-allocation-code-to-be-64bit-resource-compliant
+++ a/drivers/video/sm501fb.c
@@ -48,10 +48,15 @@ enum sm501_controller {
 	HEAD_PANEL	= 1,
 };
 
-/* SM501 memory address */
+/* SM501 memory address.
+ *
+ * This structure is used to track memory usage within the SM501 framebuffer
+ * allocation. The sm_addr field is stored as an offset as it is often used
+ * against both the physical and mapped addresses.
+ */
 struct sm501_mem {
 	unsigned long	 size;
-	unsigned long	 sm_addr;
+	unsigned long	 sm_addr;	/* offset from base of sm501 fb. */
 	void __iomem	*k_addr;
 };
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

mfd-maintainer.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

