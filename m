From: akpm@linux-foundation.org
Subject: + sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:43 -0700
Message-ID: <200707261900.l6QJ0h8h015663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57587 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932861AbXGZTND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@gmail.com


The patch titled
     sm501fb: Ensure panel interface is not tristated when  setup
has been added to the -mm tree.  Its filename is
     sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sm501fb: Ensure panel interface is not tristated when  setup
From: Ben Dooks <ben-linux@fluff.org>

When we setup the panel interface whilst configuring the
framebuffer, we should ensure the panel interface is not
in tristate, in case the bootloader or previous setup has
not enabled it.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c    |    5 +++++
 include/linux/sm501-regs.h |   18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501fb-ensure-panel-interface-is-not-tristated-when-setup drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-ensure-panel-interface-is-not-tristated-when-setup
+++ a/drivers/video/sm501fb.c
@@ -777,6 +777,11 @@ static int sm501fb_set_par_pnl(struct fb
 	writel(control, fbi->regs + SM501_DC_PANEL_CONTROL);
 	sm501fb_sync_regs(fbi);
 
+	/* ensure the panel interface is not tristated at this point */
+
+	sm501_modify_reg(fbi->dev->parent, SM501_SYSTEM_CONTROL,
+			 0, SM501_SYSCTRL_PANEL_TRISTATE);
+
 	/* power the panel up */
 	sm501fb_panel_power(fbi, 1);
 	return 0;
diff -puN include/linux/sm501-regs.h~sm501fb-ensure-panel-interface-is-not-tristated-when-setup include/linux/sm501-regs.h
--- a/include/linux/sm501-regs.h~sm501fb-ensure-panel-interface-is-not-tristated-when-setup
+++ a/include/linux/sm501-regs.h
@@ -15,6 +15,24 @@
 
 /* config 1 */
 #define SM501_SYSTEM_CONTROL 		(0x000000)
+
+#define SM501_SYSCTRL_PANEL_TRISTATE	(1<<0)
+#define SM501_SYSCTRL_MEM_TRISTATE	(1<<1)
+#define SM501_SYSCTRL_CRT_TRISTATE	(1<<2)
+
+#define SM501_SYSCTRL_PCI_SLAVE_BURST_MASK (3<<4)
+#define SM501_SYSCTRL_PCI_SLAVE_BURST_1	(0<<4)
+#define SM501_SYSCTRL_PCI_SLAVE_BURST_2	(1<<4)
+#define SM501_SYSCTRL_PCI_SLAVE_BURST_4	(2<<4)
+#define SM501_SYSCTRL_PCI_SLAVE_BURST_8	(3<<4)
+
+#define SM501_SYSCTRL_PCI_CLOCK_RUN_EN	(1<<6)
+#define SM501_SYSCTRL_PCI_RETRY_DISABLE	(1<<7)
+#define SM501_SYSCTRL_PCI_SUBSYS_LOCK	(1<<11)
+#define SM501_SYSCTRL_PCI_BURST_READ_EN	(1<<15)
+
+/* miscellaneous control */
+
 #define SM501_MISC_CONTROL		(0x000004)
 
 #define SM501_MISC_BUS_SH		(0x0)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

fixup-s3c24xx-build-after-arch-moves.patch
git-mtd.patch
git-watchdog.patch
s3c2410fb-fix-s3c2410-compilation.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
