From: akpm@linux-foundation.org
Subject: + x86-allow-intel_iommu-support-to-be-disabled-by-default.patch added to -mm tree
Date: Wed, 04 Feb 2009 14:29:19 -0800
Message-ID: <200902042229.n14MTJb9028068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZBDW35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 17:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@redhat.com, dwmw2@infradead.org, hpa@zytor.com, jbarnes@virtuousgeek.org, markmc@redhat.com, mingo@elte.hu, stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de


The patch titled
     x86: allow intel_iommu support to be disabled by default
has been added to the -mm tree.  Its filename is
     x86-allow-intel_iommu-support-to-be-disabled-by-default.patch

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
Subject: x86: allow intel_iommu support to be disabled by default
From: Kyle McMartin <kyle@redhat.com>

Due to recurring issues with DMAR support on certain platforms, provide a
Kconfig option to change whether it is enabled by default.  If disabled,
it can be reenabled by passing intel_iommu=on to the kernel.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/Kconfig                    |   11 +++++++++++
 drivers/pci/intel-iommu.c           |   14 +++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~x86-allow-intel_iommu-support-to-be-disabled-by-default Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~x86-allow-intel_iommu-support-to-be-disabled-by-default
+++ a/Documentation/kernel-parameters.txt
@@ -938,6 +938,8 @@ and is between 256 and 4096 characters. 
 
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
+		on
+			Enable intel iommu driver.
 		off
 			Disable intel iommu driver.
 		igfx_off [Default Off]
diff -puN arch/x86/Kconfig~x86-allow-intel_iommu-support-to-be-disabled-by-default arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-allow-intel_iommu-support-to-be-disabled-by-default
+++ a/arch/x86/Kconfig
@@ -1811,6 +1811,17 @@ config DMAR
 	  and include PCI device scope covered by these DMA
 	  remapping devices.
 
+config DMAR_DEFAULT_ON
+	def_bool n
+	prompt " Enable DMA Remapping Devices by default"
+	depends on DMAR
+	help
+	  Selecting this option will enable a DMAR device at boot time if
+	  one is found. If this option is not selected, DMAR support can
+	  be enabled by passing intel_iommu=on to the kernel. It is
+	  recommended you say N here while the DMAR code remains
+	  experimental.
+
 config DMAR_GFX_WA
 	def_bool y
 	prompt "Support for Graphics workaround"
diff -puN drivers/pci/intel-iommu.c~x86-allow-intel_iommu-support-to-be-disabled-by-default drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~x86-allow-intel_iommu-support-to-be-disabled-by-default
+++ a/drivers/pci/intel-iommu.c
@@ -268,7 +268,12 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-int dmar_disabled;
+#ifdef CONFIG_DMAR_DEFAULT_ON
+int dmar_disabled = 0;
+#else
+int dmar_disabled = 1;
+#endif /*CONFIG_DMAR_DEFAULT_ON*/
+
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
@@ -284,9 +289,12 @@ static int __init intel_iommu_setup(char
 	if (!str)
 		return -EINVAL;
 	while (*str) {
-		if (!strncmp(str, "off", 3)) {
+		if (!strncmp(str, "on", 2)) {
+			dmar_disabled = 0;
+			printk(KERN_INFO "Intel-IOMMU: enabled\n");
+		} else if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
-			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+			printk(KERN_INFO "Intel-IOMMU: disabled\n");
 		} else if (!strncmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
_

Patches currently in -mm which might be from kyle@redhat.com are

x86-allow-intel_iommu-support-to-be-disabled-by-default.patch

