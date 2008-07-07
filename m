From: akpm@linux-foundation.org
Subject: - pci-vt3336-cant-do-msi-either.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:59:27 -0700
Message-ID: <200807070259.m672xRpW004448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbYGGC7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:59:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: VT3336 can't do MSI either
has been removed from the -mm tree.  Its filename was
     pci-vt3336-cant-do-msi-either.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: VT3336 can't do MSI either
From: Tejun Heo <tj@kernel.org>

It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
Reported in the following SUSE bug.

  https://bugzilla.novell.com/show_bug.cgi?id=300001

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/quirks.c~pci-vt3336-cant-do-msi-either drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-vt3336-cant-do-msi-either
+++ a/drivers/pci/quirks.c
@@ -1727,6 +1727,7 @@ static void __init quirk_disable_all_msi
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
_

Patches currently in -mm which might be from tj@kernel.org are

cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch

