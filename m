From: akpm@linux-foundation.org
Subject: + remove-bogus-default-y-for-dmar-and-net_dma.patch added to -mm tree
Date: Wed, 24 Oct 2007 18:17:30 -0700
Message-ID: <200710250117.l9P1HUp4025115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbXJYBRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 21:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, jeff@garzik.org, shannon.nelson@intel.com


The patch titled
     Remove bogus default y for DMAR and NET_DMA
has been added to the -mm tree.  Its filename is
     remove-bogus-default-y-for-dmar-and-net_dma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86_64/Kconfig |    1 -
 drivers/dma/Kconfig |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/x86_64/Kconfig~remove-bogus-default-y-for-dmar-and-net_dma arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~remove-bogus-default-y-for-dmar-and-net_dma
+++ a/arch/x86_64/Kconfig
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

remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-add-reboot-mechanism.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
x86_64-add-acpi-reboot-option.patch
pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
