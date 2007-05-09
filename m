From: akpm@linux-foundation.org
Subject: - i810fb-fix-incorrect-frequency-mask.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:08 -0700
Message-ID: <200705090301.l49318wF010653@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033015AbXEIDBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     i810fb: fix incorrect frequency mask
has been removed from the -mm tree.  Its filename was
     i810fb-fix-incorrect-frequency-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i810fb: fix incorrect frequency mask
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix a long-standing bug.  The mask used to detect a 100Mhz or 133Mhz chipset
is incorrect. (The only side effect of this bug is that it will choose an
incorrect watermark).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/i810/i810.h~i810fb-fix-incorrect-frequency-mask drivers/video/i810/i810.h
--- a/drivers/video/i810/i810.h~i810fb-fix-incorrect-frequency-mask
+++ a/drivers/video/i810/i810.h
@@ -133,7 +133,7 @@
 /* Masks (AND ops) and OR's */
 #define FB_START_MASK               (0x3f << (32 - 6))
 #define MMIO_ADDR_MASK              (0x1FFF << (32 - 13))
-#define FREQ_MASK                   0x1EF
+#define FREQ_MASK                   (1 << 4)
 #define SCR_OFF                     0x20
 #define DRAM_ON                     0x08            
 #define DRAM_OFF                    0xE7
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
