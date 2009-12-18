From: akpm@linux-foundation.org
Subject: + pcie-aer-reject-aer-inject-if-hardware-mask-error-reporting.patch added to -mm tree
Date: Fri, 18 Dec 2009 15:59:06 -0800
Message-ID: <200912182359.nBINx6jW026233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbZLRX7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 18:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: youquan.song@linux.intel.com, ak@linux.intel.com, andrew.patterson@hp.com, jbarnes@virtuousgeek.org, ying.huang@intel.com, youquan.song@intel.com


The patch titled
     PCIe AER: reject aer inject if hardware mask error reporting
has been added to the -mm tree.  Its filename is
     pcie-aer-reject-aer-inject-if-hardware-mask-error-reporting.patch

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
Subject: PCIe AER: reject aer inject if hardware mask error reporting
From: "Youquan,Song" <youquan.song@linux.intel.com>

Correcteable/Uncorrectable Error Mask Register are used by PCIe AER driver
which will controls the reporting of idividual errors to PCIe RC via PCIe
error messages.

If hardware masks special error reporting to RC, the aer_inject driver
should not inject aer error.

Signed-off-by: Youquan, Song <youquan.song@intel.com>
Acked-by: Ying, Huang <ying.huang@intel.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aer_inject.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/pci/pcie/aer/aer_inject.c~pcie-aer-reject-aer-inject-if-hardware-mask-error-reporting drivers/pci/pcie/aer/aer_inject.c
--- a/drivers/pci/pcie/aer/aer_inject.c~pcie-aer-reject-aer-inject-if-hardware-mask-error-reporting
+++ a/drivers/pci/pcie/aer/aer_inject.c
@@ -321,7 +321,7 @@ static int aer_inject(struct aer_error_i
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever;
+	u32 sever, mask;
 	int ret = 0;
 
 	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
@@ -374,6 +374,24 @@ static int aer_inject(struct aer_error_i
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
+	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The correctable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
+	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The uncorrectable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
 	rperr = __find_aer_error_by_dev(rpdev);
 	if (!rperr) {
 		rperr = rperr_alloc;
_

Patches currently in -mm which might be from youquan.song@linux.intel.com are

pcie-aer-fix-aer-inject-result-in-kernel-oops.patch
pcie-aer-reject-aer-inject-if-hardware-mask-error-reporting.patch

