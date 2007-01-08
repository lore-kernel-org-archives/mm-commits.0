From: akpm@osdl.org
Subject: + increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:36:05 -0800
Message-ID: <200701082136.l08La5n4019659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbXAHVgN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:36:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brice@myri.com, gallatin@myri.com, greg@kroah.com


The patch titled
     increment pos before looking for the next cap in __pci_find_next_ht_cap
has been added to the -mm tree.  Its filename is
     increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: increment pos before looking for the next cap in __pci_find_next_ht_cap
From: Brice Goglin <brice@myri.com>

While testing 2.6.20-rc3 on a machine with some CK804 chipsets, we noticed
that quirk_nvidia_ck804_msi_ht_cap() was not detecting HT MSI capabilities
anymore.  It is actually caused by the MSI mapping on the root chipset
being the 2nd HT capability in the chain.  pci_find_ht_capability() does
not seem to find anything but the first HT cap correctly, because it
forgets to increment the position before looking for the next cap.  The
following patch seems to fix it.

At least, this proves that having a ttl is good idea since the machine
would have been stucked in an infinite loop if we didn't have a ttl :)



We have to pass pos + PCI_CAP_LIST_NEXT to __pci_find_next_cap_ttl to
get the next HT cap instead of the same one again.

Signed-off-by: Brice Goglin <brice@myri.com>
Signed-off-by: Andrew J. Gallatin <gallatin@myri.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pci/pci.c~increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap drivers/pci/pci.c
--- a/drivers/pci/pci.c~increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap
+++ a/drivers/pci/pci.c
@@ -254,7 +254,8 @@ static int __pci_find_next_ht_cap(struct
 		if ((cap & mask) == ht_cap)
 			return pos;
 
-		pos = __pci_find_next_cap_ttl(dev->bus, dev->devfn, pos,
+		pos = __pci_find_next_cap_ttl(dev->bus, dev->devfn,
+					      pos + PCI_CAP_LIST_NEXT,
 					      PCI_CAP_ID_HT, &ttl);
 	}
 
_

Patches currently in -mm which might be from brice@myri.com are

increment-pos-before-looking-for-the-next-cap-in-__pci_find_next_ht_cap.patch
