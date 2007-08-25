From: akpm@linux-foundation.org
Subject: - add-pci_try_set_mwi-prism54pci.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:21:45 -0700
Message-ID: <200708250321.l7P3LjPK027886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbXHYDV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     add pci_try_set_mwi
has been removed from the -mm tree.  Its filename was
     add-pci_try_set_mwi-prism54pci.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: add pci_try_set_mwi
From: Randy Dunlap <randy.dunlap@oracle.com>

As suggested by Andrew, add pci_try_set_mwi(), which does not require
return-value checking.

- add pci_try_set_mwi() without __must_check
- make it return 0 on success, errno if the "try" failed or error
- review callers

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/mac80211/p54/prism54pci.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi-prism54pci drivers/net/wireless/mac80211/p54/prism54pci.c
--- a/drivers/net/wireless/mac80211/p54/prism54pci.c~add-pci_try_set_mwi-prism54pci
+++ a/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -540,7 +540,7 @@ static int __devinit p54p_probe(struct p
 	}
 
 	pci_set_master(pdev);
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 	pci_write_config_byte(pdev, 0x40, 0);
 	pci_write_config_byte(pdev, 0x41, 0);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
pci-aer-fix-warnings-when-pcieaer=n.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
