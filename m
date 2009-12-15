From: akpm@linux-foundation.org
Subject: [merged] cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:37 -0800
Message-ID: <200912152156.nBFLubew015656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761289AbZLOV5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, cjb@laptop.org, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cs5535: define lxfb/gxfb MSRs in linux/cs5535.h
has been removed from the -mm tree.  Its filename was
     cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535: define lxfb/gxfb MSRs in linux/cs5535.h
From: Andres Salomon <dilinger@collabora.co.uk>

..and include them in the lxfb/gxfb drivers rather than asm/geode.h (where
possible).

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/geode.h     |   13 -------------
 drivers/video/geode/display_gx.c |    2 +-
 drivers/video/geode/gxfb.h       |    2 +-
 drivers/video/geode/gxfb_core.c  |    2 +-
 drivers/video/geode/lxfb.h       |    2 +-
 drivers/video/geode/lxfb_ops.c   |    2 +-
 drivers/video/geode/suspend_gx.c |    2 +-
 drivers/video/geode/video_gx.c   |    2 +-
 include/linux/cs5535.h           |   13 +++++++++++++
 9 files changed, 20 insertions(+), 20 deletions(-)

diff -puN arch/x86/include/asm/geode.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h arch/x86/include/asm/geode.h
--- a/arch/x86/include/asm/geode.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/arch/x86/include/asm/geode.h
@@ -31,25 +31,12 @@ extern int geode_get_dev_base(unsigned i
 
 /* MSRS */
 
-#define MSR_GLIU_P2D_RO0	0x10000029
-
-#define MSR_LX_GLD_MSR_CONFIG	0x48002001
-#define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
-						 * sheet has the wrong value */
-#define MSR_GLCP_SYS_RSTPLL	0x4C000014
-#define MSR_GLCP_DOTPLL		0x4C000015
-
 #define MSR_LBAR_SMB		0x5140000B
 #define MSR_LBAR_GPIO		0x5140000C
 #define MSR_LBAR_MFGPT		0x5140000D
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
-#define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
-
-#define MSR_GX_GLD_MSR_CONFIG	0xC0002001
-#define MSR_GX_MSR_PADSEL	0xC0002011
-
 /* Resource Sizes */
 
 #define LBAR_GPIO_SIZE		0xFF
diff -puN drivers/video/geode/display_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/display_gx.c
@@ -17,7 +17,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff -puN drivers/video/geode/gxfb.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/gxfb.h
--- a/drivers/video/geode/gxfb.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/gxfb.h
@@ -340,7 +340,7 @@ static inline void write_fp(struct gxfb_
 }
 
 
-/* MSRs are defined in asm/geode.h; their bitfields are here */
+/* MSRs are defined in linux/cs5535.h; their bitfields are here */
 
 #define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(1 << 3)
 #define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(1 << 2)
diff -puN drivers/video/geode/gxfb_core.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/gxfb_core.c
@@ -32,7 +32,7 @@
 #include <linux/suspend.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff -puN drivers/video/geode/lxfb.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/lxfb.h
@@ -409,7 +409,7 @@ static inline void write_fp(struct lxfb_
 }
 
 
-/* MSRs are defined in asm/geode.h; their bitfields are here */
+/* MSRs are defined in linux/cs5535.h; their bitfields are here */
 
 #define MSR_GLCP_DOTPLL_LOCK		(1 << 25)	/* r/o */
 #define MSR_GLCP_DOTPLL_HALFPIX		(1 << 24)
diff -puN drivers/video/geode/lxfb_ops.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/lxfb_ops.c
@@ -13,7 +13,7 @@
 #include <linux/fb.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "lxfb.h"
 
diff -puN drivers/video/geode/suspend_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/suspend_gx.c
--- a/drivers/video/geode/suspend_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/suspend_gx.c
@@ -10,7 +10,7 @@
 #include <linux/fb.h>
 #include <asm/io.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 #include <asm/delay.h>
 
 #include "gxfb.h"
diff -puN drivers/video/geode/video_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/drivers/video/geode/video_gx.c
@@ -16,7 +16,7 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff -puN include/linux/cs5535.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h include/linux/cs5535.h
--- a/include/linux/cs5535.h~cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h
+++ a/include/linux/cs5535.h
@@ -12,6 +12,14 @@
 #define _CS5535_H
 
 /* MSRs */
+#define MSR_GLIU_P2D_RO0	0x10000029
+
+#define MSR_LX_GLD_MSR_CONFIG	0x48002001
+#define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
+						 * sheet has the wrong value */
+#define MSR_GLCP_SYS_RSTPLL	0x4C000014
+#define MSR_GLCP_DOTPLL		0x4C000015
+
 #define MSR_LBAR_SMB		0x5140000B
 #define MSR_LBAR_GPIO		0x5140000C
 #define MSR_LBAR_MFGPT		0x5140000D
@@ -30,6 +38,11 @@
 #define MSR_MFGPT_NR		0x51400029
 #define MSR_MFGPT_SETUP		0x5140002B
 
+#define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
+
+#define MSR_GX_GLD_MSR_CONFIG	0xC0002001
+#define MSR_GX_MSR_PADSEL	0xC0002011
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch
lxfb-add-copyright-license-info.patch

