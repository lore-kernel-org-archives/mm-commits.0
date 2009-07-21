From: akpm@linux-foundation.org
Subject: + pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:08:43 -0700
Message-ID: <200907212308.n6LN8hSf009829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359AbZGUXKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, greg@kroah.com, jbarnes@virtuousgeek.org, kalon33@ubuntu.com, linux@tjworld.net, pchen@nvidia.com, stable@kernel.org


The patch titled
     pci: apply nv_msi_ht_cap_quirk on resume too
has been added to the -mm tree.  Its filename is
     pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch

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

origin.patch
linux-next.patch
pci-apply-nv_msi_ht_cap_quirk-on-resume-too.patch
vmallocc-fix-double-error-checking.patch

