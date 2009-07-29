From: akpm@linux-foundation.org
Subject: [merged] pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch removed from -mm tree
Date: Wed, 29 Jul 2009 12:35:29 -0700
Message-ID: <200907291935.n6TJZTde003727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbZG2Tgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, greg@kroah.com, jbarnes@virtuousgeek.org, kalon33@ubuntu.com, linux@tjworld.net, pchen@nvidia.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pci: apply nv_msi_ht_cap_quirk on resume too
has been removed from the -mm tree.  Its filename was
     pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: apply nv_msi_ht_cap_quirk on resume too
From: Tejun Heo <tj@kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12542 reports that with the
quirk not applied on resume, msi stops working after resuming and mcp78s
ahci fails due to IRQ mis-delivery.  Apply it on resume too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Tj <linux@tjworld.net>
Reported-by: Nicolas Derive <kalon33@ubuntu.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pci/quirks.c~pci-apply-nv_msi_ht_cap_quirk-on-resume-too drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-apply-nv_msi_ht_cap_quirk-on-resume-too
+++ a/drivers/pci/quirks.c
@@ -2382,8 +2382,10 @@ static void __devinit nv_msi_ht_cap_quir
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
vmallocc-fix-double-error-checking.patch

