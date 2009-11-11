From: akpm@linux-foundation.org
Subject: + cs5535-move-vsa2-checks-into-linux-cs5535h.patch added to -mm tree
Date: Tue, 10 Nov 2009 16:41:05 -0800
Message-ID: <200911110041.nAB0f5EO013462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZKKAmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 19:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, cjb@laptop.org, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     cs5535: move VSA2 checks into linux/cs5535.h
has been added to the -mm tree.  Its filename is
     cs5535-move-vsa2-checks-into-linux-cs5535h.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535: move VSA2 checks into linux/cs5535.h
From: Andres Salomon <dilinger@collabora.co.uk>

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86/include/asm/geode.h~cs5535-move-vsa2-checks-into-linux-cs5535h arch/x86/include/asm/geode.h
--- a/arch/x86/include/asm/geode.h~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/arch/x86/include/asm/geode.h
@@ -95,16 +95,6 @@ extern int geode_get_dev_base(unsigned i
 #define PM_AWKD			0x50
 #define PM_SSC			0x54
 
-/* VSA2 magic values */
-
-#define VSA_VRC_INDEX		0xAC1C
-#define VSA_VRC_DATA		0xAC1E
-#define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
-#define VSA_VR_SIGNATURE	0x0003
-#define VSA_VR_MEM_SIZE		0x0200
-#define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
-#define GSW_VSA_SIG		0x534d  /* General Software signature */
-
 static inline u32 geode_gpio(unsigned int nr)
 {
 	BUG_ON(nr > 28);
@@ -148,15 +138,6 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-#ifdef CONFIG_MGEODE_LX
-extern int geode_has_vsa2(void);
-#else
-static inline int geode_has_vsa2(void)
-{
-	return 0;
-}
-#endif
-
 static inline void geode_mfgpt_write(int timer, u16 reg, u16 value)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_MFGPT);
diff -puN arch/x86/kernel/geode_32.c~cs5535-move-vsa2-checks-into-linux-cs5535h arch/x86/kernel/geode_32.c
--- a/arch/x86/kernel/geode_32.c~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/arch/x86/kernel/geode_32.c
@@ -161,28 +161,6 @@ void geode_gpio_setup_event(unsigned int
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
-int geode_has_vsa2(void)
-{
-	static int has_vsa2 = -1;
-
-	if (has_vsa2 == -1) {
-		u16 val;
-
-		/*
-		 * The VSA has virtual registers that we can query for a
-		 * signature.
-		 */
-		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
-		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
-
-		val = inw(VSA_VRC_DATA);
-		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
-	}
-
-	return has_vsa2;
-}
-EXPORT_SYMBOL_GPL(geode_has_vsa2);
-
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
diff -puN arch/x86/kernel/olpc.c~cs5535-move-vsa2-checks-into-linux-cs5535h arch/x86/kernel/olpc.c
--- a/arch/x86/kernel/olpc.c~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/arch/x86/kernel/olpc.c
@@ -212,7 +212,7 @@ static int __init olpc_init(void)
 	unsigned char *romsig;
 
 	/* The ioremap check is dangerous; limit what we run it on */
-	if (!is_geode() || geode_has_vsa2())
+	if (!is_geode() || cs5535_has_vsa2())
 		return 0;
 
 	spin_lock_init(&ec_lock);
@@ -244,7 +244,7 @@ static int __init olpc_init(void)
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
 	/* check to see if the VSA exists */
-	if (geode_has_vsa2())
+	if (cs5535_has_vsa2())
 		olpc_platform_info.flags |= OLPC_F_VSA;
 
 	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
diff -puN drivers/video/geode/display_gx.c~cs5535-move-vsa2-checks-into-linux-cs5535h drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/drivers/video/geode/display_gx.c
@@ -25,7 +25,7 @@ unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
 
-	if (!geode_has_vsa2()) {
+	if (!cs5535_has_vsa2()) {
 		uint32_t hi, lo;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
diff -puN drivers/video/geode/lxfb_ops.c~cs5535-move-vsa2-checks-into-linux-cs5535h drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/drivers/video/geode/lxfb_ops.c
@@ -307,7 +307,7 @@ unsigned int lx_framebuffer_size(void)
 {
 	unsigned int val;
 
-	if (!geode_has_vsa2()) {
+	if (!cs5535_has_vsa2()) {
 		uint32_t hi, lo;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
diff -puN include/linux/cs5535.h~cs5535-move-vsa2-checks-into-linux-cs5535h include/linux/cs5535.h
--- a/include/linux/cs5535.h~cs5535-move-vsa2-checks-into-linux-cs5535h
+++ a/include/linux/cs5535.h
@@ -36,6 +36,38 @@
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/* VSA2 magic values */
+#define VSA_VRC_INDEX		0xAC1C
+#define VSA_VRC_DATA		0xAC1E
+#define VSA_VR_UNLOCK		0xFC53  /* unlock virtual register */
+#define VSA_VR_SIGNATURE	0x0003
+#define VSA_VR_MEM_SIZE		0x0200
+#define AMD_VSA_SIG		0x4132  /* signature is ascii 'VSA2' */
+#define GSW_VSA_SIG		0x534d  /* General Software signature */
+
+#include <linux/io.h>
+
+static inline int cs5535_has_vsa2(void)
+{
+	static int has_vsa2 = -1;
+
+	if (has_vsa2 == -1) {
+		uint16_t val;
+
+		/*
+		 * The VSA has virtual registers that we can query for a
+		 * signature.
+		 */
+		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+		val = inw(VSA_VRC_DATA);
+		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
+	}
+
+	return has_vsa2;
+}
+
 /* GPIOs */
 #define GPIO_OUTPUT_VAL		0x00
 #define GPIO_OUTPUT_ENABLE	0x04
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch

