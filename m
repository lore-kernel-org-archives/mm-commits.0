From: akpm@linux-foundation.org
Subject: + pci-msi-fix-msi_mask.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:36:27 -0800
Message-ID: <200902052136.n15LaRkc008765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbZBEVgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, jbarnes@virtuousgeek.org, matthew@wil.cx


The patch titled
     pci/msi: fix msi_mask()
has been added to the -mm tree.  Its filename is
     pci-msi-fix-msi_mask.patch

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
Subject: pci/msi: fix msi_mask()
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Commit bffac3c593eba1f9da3efd0199e49ea6558a40ce ("PCI MSI: Fix undefined
shift by 32") does:

 -    temp = (1 << multi_msi_capable(control));
 -    temp = ((temp - 1) & ~temp);
 +    temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);

and provides msi_mask() to avoid undefined shift by 32.

According to PCI Local Bus Spec 3.0 "6.8.1.3 Message Control for MSI",
relations between the encoded bits in control register, the number of
vectors and the proper maskbits should be as following table:

 control[3::1] | vectors  | maskbits
 --------------+----------+-----------
          000b |        1 | 0x1
          001b |        2 | 0x3
          010b |        4 | 0xf
          011b |        8 | 0xff
          100b |       16 | 0xffff
          101b |       32 | 0xffffffff
          110b | Reserved | n/a
          111b | Reserved | n/a

This patch fixes the wrong array in the msi_mask().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/msi.c~pci-msi-fix-msi_mask drivers/pci/msi.c
--- a/drivers/pci/msi.c~pci-msi-fix-msi_mask
+++ a/drivers/pci/msi.c
@@ -109,7 +109,7 @@ static void msix_set_enable(struct pci_d
  */
 static inline __attribute_const__ u32 msi_mask(unsigned x)
 {
-	static const u32 mask[] = { 1, 2, 4, 0xf, 0xff, 0xffff, 0xffffffff };
+	static const u32 mask[] = { 1, 3, 0xf, 0xff, 0xffff, 0xffffffff };
 	return mask[x];
 }
 
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

linux-next.patch
pci-msi-fix-msi_mask.patch

