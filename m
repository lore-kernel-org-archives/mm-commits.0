From: akpm@linux-foundation.org
Subject: + sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:32:37 -0700
Message-ID: <200807022332.m62NWbYf009443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbYGBXdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:33:41 -0400
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

 drivers/video/sm501fb.c |   46 ++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

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
 
@@ -142,37 +147,56 @@ static inline void sm501fb_sync_regs(str
 static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
 			   unsigned int why, size_t size)
 {
-	unsigned int ptr = 0;
-	unsigned int end;
+	struct sm501fb_par *par;
 	struct fb_info *fbi;
+	unsigned int ptr;
+	unsigned int end;
 
 	switch (why) {
 	case SM501_MEMF_CURSOR:
 		ptr = inf->fbmem_len - size;
-		inf->fbmem_len = ptr;
+		inf->fbmem_len = ptr;	/* adjust available memory. */
 		break;
 
 	case SM501_MEMF_PANEL:
 		ptr = inf->fbmem_len - size;
-		fbi = inf->fb[0];
+		fbi = inf->fb[HEAD_CRT];
 
 		if (fbi && ptr < fbi->fix.smem_len)
 			return -ENOMEM;
 
+		if (ptr < 0)
+			return -ENOMEM;
+
 		break;
 
 	case SM501_MEMF_CRT:
 		ptr = 0;
+
+		/* check to see if we have panel memory allocated
+		 * which would put an limit on available memory. */
+
+		fbi = inf->fb[HEAD_PANEL];
+		if (fbi) {
+			par = fbi->par;
+			end = par->screen.k_addr ? par->screen.sm_addr : inf->fbmem_len;
+		} else
+			end = inf->fbmem_len;
+
+		if ((ptr + size) > end)
+			return -ENOMEM;
+
 		break;
 
 	case SM501_MEMF_ACCEL:
-		fbi = inf->fb[0];
+		fbi = inf->fb[HEAD_CRT];
 		ptr = fbi ? fbi->fix.smem_len : 0;
 
-		fbi = inf->fb[1];
-		if (fbi)
-			end = (fbi->fix.smem_start - inf->fbmem_res->start);
-		else
+		fbi = inf->fb[HEAD_PANEL];
+		if (fbi) {
+			par = fbi->par;
+			end = par->screen.sm_addr;
+		} else
 			end = inf->fbmem_len;
 
 		if ((ptr + size) > end)
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
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

