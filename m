From: akpm@linux-foundation.org
Subject: + page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch added to -mm tree
Date: Thu, 03 Jul 2008 10:09:55 -0700
Message-ID: <200807031709.m63H9tdA017767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbYGCRRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 13:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com


The patch titled
     page_align: fix implicit declarations of function 'PAGE_ALIGN' in various drivers
has been added to the -mm tree.  Its filename is
     page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch

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
Subject: page_align: fix implicit declarations of function 'PAGE_ALIGN' in various drivers
From: Andrea Righi <righi.andrea@gmail.com>

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/iso.c           |    1 +
 drivers/net/mlx4/eq.c            |    1 +
 drivers/pcmcia/electra_cf.c      |    1 +
 drivers/scsi/sun_esp.c           |    1 +
 drivers/video/acornfb.c          |    1 +
 drivers/video/imxfb.c            |    1 +
 drivers/video/omap/dispc.c       |    1 +
 drivers/video/omap/omapfb_main.c |    1 +
 drivers/video/pxafb.c            |    1 +
 drivers/video/sa1100fb.c         |    1 +
 10 files changed, 10 insertions(+)

diff -puN drivers/ieee1394/iso.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/ieee1394/iso.c
--- a/drivers/ieee1394/iso.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/ieee1394/iso.c
@@ -11,6 +11,7 @@
 
 #include <linux/pci.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include "hosts.h"
diff -puN drivers/net/mlx4/eq.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/net/mlx4/eq.c
--- a/drivers/net/mlx4/eq.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/net/mlx4/eq.c
@@ -33,6 +33,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/mm.h>
 #include <linux/dma-mapping.h>
 
 #include <linux/mlx4/cmd.h>
diff -puN drivers/pcmcia/electra_cf.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/pcmcia/electra_cf.c
--- a/drivers/pcmcia/electra_cf.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/pcmcia/electra_cf.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/of_platform.h>
 
diff -puN drivers/scsi/sun_esp.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/scsi/sun_esp.c
--- a/drivers/scsi/sun_esp.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/scsi/sun_esp.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/init.h>
 
 #include <asm/irq.h>
diff -puN drivers/video/acornfb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/acornfb.c
--- a/drivers/video/acornfb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/acornfb.c
@@ -23,6 +23,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/fb.h>
 #include <linux/platform_device.h>
diff -puN drivers/video/imxfb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/imxfb.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/fb.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff -puN drivers/video/omap/dispc.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/omap/dispc.c
@@ -20,6 +20,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/dma-mapping.h>
+#include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff -puN drivers/video/omap/omapfb_main.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/omap/omapfb_main.c
@@ -25,6 +25,7 @@
  * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 #include <linux/platform_device.h>
+#include <linux/mm.h>
 #include <linux/uaccess.h>
 
 #include <asm/mach-types.h>
diff -puN drivers/video/pxafb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/pxafb.c
@@ -30,6 +30,7 @@
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/fb.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff -puN drivers/video/sa1100fb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers
+++ a/drivers/video/sa1100fb.c
@@ -167,6 +167,7 @@
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/fb.h>
 #include <linux/delay.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
page_align-arm-fix-implicit-declaration-of-function-page_align.patch
page_align-avr32-fix-implicit-declaration-of-function-page_align.patch
page_align-h8300-fix-implicit-declaration-of-function-page_align.patch
page_align-m68k-fix-implicit-declaration-of-function-page_align.patch
page_align-m68knommu-fix-implicit-declaration-of-function-page_align.patch
page_align-mips-fix-implicit-declarations-of-function-page_align.patch
page_align-xtensa-fix-implicit-declaration-of-function-page_align.patch
page_align-fix-implicit-declarations-of-function-page_align-in-various-drivers.patch
distinct-tgid-tid-i-o-statistics.patch

