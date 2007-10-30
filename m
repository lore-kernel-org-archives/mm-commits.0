From: akpm@linux-foundation.org
Subject: - remove-bogus-default-y-for-dmar-and-net_dma.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:25 -0700
Message-ID: <200710301806.l9UI6PKO020519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbXJ3SHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, jeff@garzik.org, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     Remove bogus default y for DMAR and NET_DMA
has been removed from the -mm tree.  Its filename was
     remove-bogus-default-y-for-dmar-and-net_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove bogus default y for DMAR and NET_DMA
From: Andi Kleen <ak@suse.de>

No reason I can think of of making them default y Most people don't have
the hardware and with default y they just pollute lots of configs during
make oldconfig.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: "Nelson, Shannon" <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.x86_64 |    1 -
 drivers/dma/Kconfig     |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/x86/Kconfig.x86_64~remove-bogus-default-y-for-dmar-and-net_dma arch/x86/Kconfig.x86_64
--- a/arch/x86/Kconfig.x86_64~remove-bogus-default-y-for-dmar-and-net_dma
+++ a/arch/x86/Kconfig.x86_64
@@ -753,7 +753,6 @@ config PCI_DOMAINS
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	default y
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
diff -puN drivers/dma/Kconfig~remove-bogus-default-y-for-dmar-and-net_dma drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~remove-bogus-default-y-for-dmar-and-net_dma
+++ a/drivers/dma/Kconfig
@@ -43,7 +43,6 @@ comment "DMA Clients"
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
-	default y
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
acpi-add-reboot-mechanism.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-add-acpi-reboot-option.patch
pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
