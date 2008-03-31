From: akpm@linux-foundation.org
Subject: + radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:21:48 -0700
Message-ID: <200803312121.m2VLLmnT026612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756712AbYCaVV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, mchehab@infradead.org


The patch titled
     radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP
has been added to the -mm tree.  Its filename is
     radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

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

git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
revert-gregkh-pci-pci-alpha-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ia64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-powerpc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
radio-cadet-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch
hisax-depend-on-config_pnp-not-__isapnp__.patch

