From: akpm@linux-foundation.org
Subject: [merged] pci-enable-msi-on-8132.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:55 -0800
Message-ID: <200902191917.n1JJHtPe016425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbZBSTSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, david@lang.hm, jbarnes@virtuousgeek.org, mingo@elte.hu, stable@kernel.org, willy@linux.intel.com, mm-com


The patch titled
     pci: enable MSI on 8132
has been removed from the -mm tree.  Its filename was
     pci-enable-msi-on-8132.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enable MSI on 8132
From: Yinghai Lu <yinghai@kernel.org>

Impact: workaround BIOS that doesn't enable that bit

David reported that LSI sas doesn't work with MSI.  it turns out that BIOS
doesn't enable HT MSI 8132 does support HT MSI.  add quirk to enable it

Reported-by: David Lang <david@lang.hm>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: <stable@kernel.org>		[2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~pci-enable-msi-on-8132 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-enable-msi-on-8132
+++ a/drivers/pci/quirks.c
@@ -1981,7 +1981,6 @@ static void __devinit quirk_msi_ht_cap(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
