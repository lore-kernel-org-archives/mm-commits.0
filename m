From: akpm@linux-foundation.org
Subject: + aspm-fix-pcie-devices-with-non-pcie-children.patch added to -mm tree
Date: Thu, 29 Mar 2012 13:46:43 -0700
Message-ID: <20120329204643.F35CDA032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34973 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025Ab2C2Uqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 16:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, bandidoirlandes@gmail.com, hatem.masmoudi@gmail.com, jan0x6c@gmail.com, jbarnes@virtuousgeek.org, jrnieder@gmail.com, romain@orebokech.com, stable@vger.kernel.org


The patch titled
     Subject: ASPM: fix pcie devices with non-pcie children
has been added to the -mm tree.  Its filename is
     aspm-fix-pcie-devices-with-non-pcie-children.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Garrett <mjg@redhat.com>
Subject: ASPM: fix pcie devices with non-pcie children

Since 3.2.12 and 3.3, some systems are failing to boot with a BUG_ON. 
Some other systems using the pata_jmicron driver fail to boot because no
disks are detected.  Passing pcie_aspm=force on the kernel command line
works around it.

The cause: commit 4949be16822e ("PCI: ignore pre-1.1 ASPM quirking when
ASPM is disabled") changed the behaviour of pcie_aspm_sanity_check() to
always return 0 if aspm is disabled, in order to avoid cases where we
changed ASPM state on pre-PCIe 1.1 devices.  This skipped the secondary
function of pcie_aspm_sanity_check which was to avoid us enabling ASPM on
devices that had non-PCIe children, causing trouble later on.  Move the
aspm_disabled check so we continue to honour that scenario.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42979 and
          http://bugs.debian.org/665420

[jn: with more symptoms in log message]
Reported-by: Romain Francoise <romain@orebokech.com> # kernel panic
Reported-by: Chris Holland <bandidoirlandes@gmail.com> # disk detection trouble
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: <stable@vger.kernel.org>
Tested-by: Hatem Masmoudi <hatem.masmoudi@gmail.com> # Dell Latitude E5520
Tested-by: janek <jan0x6c@gmail.com> # pata_jmicron with JMB362/JMB363
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aspm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/pci/pcie/aspm.c~aspm-fix-pcie-devices-with-non-pcie-children drivers/pci/pcie/aspm.c
--- a/drivers/pci/pcie/aspm.c~aspm-fix-pcie-devices-with-non-pcie-children
+++ a/drivers/pci/pcie/aspm.c
@@ -508,9 +508,6 @@ static int pcie_aspm_sanity_check(struct
 	int pos;
 	u32 reg32;
 
-	if (aspm_disabled)
-		return 0;
-
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
@@ -519,6 +516,16 @@ static int pcie_aspm_sanity_check(struct
 		pos = pci_pcie_cap(child);
 		if (!pos)
 			return -EINVAL;
+
+		/*
+		 * If ASPM is disabled then we're not going to change
+		 * the BIOS state. It's safe to continue even if it's a
+		 * pre-1.1 device
+		 */
+
+		if (aspm_disabled)
+			continue;
+
 		/*
 		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
 		 * RBER bit to determine if a function is 1.1 version device
_
Subject: Subject: ASPM: fix pcie devices with non-pcie children

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch
aspm-fix-pcie-devices-with-non-pcie-children.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

