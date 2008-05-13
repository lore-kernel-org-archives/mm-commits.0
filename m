From: akpm@linux-foundation.org
Subject: - pci-enable-nv_msi_ht_cap_quirk-for-ali-bridges.patch removed from -mm tree
Date: Tue, 13 May 2008 14:35:02 -0700
Message-ID: <200805132135.m4DLZ2ig001055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760778AbYEMVfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fox.box@gmail.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: enable nv_msi_ht_cap_quirk for ALi bridges
has been removed from the -mm tree.  Its filename was
     pci-enable-nv_msi_ht_cap_quirk-for-ali-bridges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enable nv_msi_ht_cap_quirk for ALi bridges
From: Bjorn Krombholz <fox.box@gmail.com>

This applies the NVidia MSI enabled flag for HT capable devices quirk
to ALi bridges as well.

As described in more detail in
http://bugzilla.kernel.org/show_bug.cgi?id=10667 this is required for
my board which is using an nForce 3 250Gb chipset with an ALi M1695
northbridge.

It fixes a regression introduced in 2.6.24 that made the internal NIC
of the board unusable (MSI initialisation of the NIC but disabled MSI
on the northbridge devices.

Signed-off-by: Bjorn Krombholz <fox.box@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/quirks.c~pci-enable-nv_msi_ht_cap_quirk-for-ali-bridges drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-enable-nv_msi_ht_cap_quirk-for-ali-bridges
+++ a/drivers/pci/quirks.c
@@ -1826,6 +1826,7 @@ static void __devinit nv_msi_ht_cap_quir
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk);
 
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
_

Patches currently in -mm which might be from fox.box@gmail.com are

origin.patch
linux-next.patch

