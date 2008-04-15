From: akpm@linux-foundation.org
Subject: + x86-geode-add-virtual-systems-architecture-detection.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:12:56 -0700
Message-ID: <200804150112.m3F1Cupn003700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYDOBOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, alan@lxorguk.ukuu.org.uk, dilinger@debian.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: GEODE: add Virtual Systems Architecture detection
has been added to the -mm tree.  Its filename is
     x86-geode-add-virtual-systems-architecture-detection.patch

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
Subject: x86: GEODE: add Virtual Systems Architecture detection
From: Andres Salomon <dilinger@queued.net>

This is generic VSA2 detection.  It's used by OLPC to determine whether or not
the BIOS contains VSA2, but since other BIOSes are coming out that don't use
the VSA (ie, tinybios), it might end up being useful for others.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/geode.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN include/asm-x86/geode.h~x86-geode-add-virtual-systems-architecture-detection include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~x86-geode-add-virtual-systems-architecture-detection
+++ a/include/asm-x86/geode.h
@@ -103,6 +103,14 @@ extern int geode_get_dev_base(unsigned i
 #define PM_AWKD			0x50
 #define PM_SSC			0x54
 
+/* VSA2 magic values */
+
+#define VSA_VRC_INDEX		0xAC1C
+#define VSA_VRC_DATA		0xAC1E
+#define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
+#define VSA_VR_SIGNATURE	0x0003
+#define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
+
 /* GPIO */
 
 #define GPIO_OUTPUT_VAL		0x00
@@ -174,6 +182,17 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
+/*
+ * The VSA has virtual registers that we can query for a signature.
+ */
+static inline int geode_has_vsa2(void)
+{
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+	return (inw(VSA_VRC_DATA) == VSA_SIG);
+}
+
 /* MFGPTs */
 
 #define MFGPT_MAX_TIMERS	8
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch

