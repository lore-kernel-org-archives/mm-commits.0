From: akpm@linux-foundation.org
Subject: - radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:00 -0700
Message-ID: <200804021920.m32JK0a6030206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835AbYDBTUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP
has been removed from the -mm tree.  Its filename was
     radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to pnp_get_resource()
function when CONFIG_PNP=n.  (This is a new interface that's not in mainline
yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-cadet.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/media/radio/radio-cadet.c~radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp drivers/media/radio/radio-cadet.c
--- a/drivers/media/radio/radio-cadet.c~radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp
+++ a/drivers/media/radio/radio-cadet.c
@@ -589,6 +589,8 @@ static struct video_device cadet_radio=
 	.vidioc_s_input     = vidioc_s_input,
 };
 
+#ifdef CONFIG_PNP
+
 static struct pnp_device_id cadet_pnp_devices[] = {
 	/* ADS Cadet AM/FM Radio Card */
 	{.id = "MSM0c24", .driver_data = 0},
@@ -623,6 +625,10 @@ static struct pnp_driver cadet_pnp_drive
 	.remove		= NULL,
 };
 
+#else
+static struct pnp_driver cadet_pnp_driver;
+#endif
+
 static int cadet_probe(void)
 {
 	static int iovals[8]={0x330,0x332,0x334,0x336,0x338,0x33a,0x33c,0x33e};
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-dvb.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
simplify-initcall_debug-output.patch
hisax-depend-on-config_pnp-not-__isapnp__.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

