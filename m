From: akpm@linux-foundation.org
Subject: - arch-ppc-remove-an-unnecessary-pci_dev_put.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:09 -0800
Message-ID: <200712202337.lBKNb9Jc018866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXLTXrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     arch/ppc: remove an unnecessary pci_dev_put
has been removed from the -mm tree.  Its filename was
     arch-ppc-remove-an-unnecessary-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/ppc: remove an unnecessary pci_dev_put
From: Julia Lawall <julia@diku.dk>

Remove an unnecessary pci_dev_put.  pci_dev_put is called implicitly by the
subsequent call to pci_get_device.

The problem was detected using the following semantic patch, and corrected by
hand.

@@
expression dev;
expression E;
@@

- pci_dev_put(dev)
   ... when != dev = E
- pci_get_device(...,dev)

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/platforms/prep_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ppc/platforms/prep_pci.c~arch-ppc-remove-an-unnecessary-pci_dev_put arch/ppc/platforms/prep_pci.c
--- a/arch/ppc/platforms/prep_pci.c~arch-ppc-remove-an-unnecessary-pci_dev_put
+++ a/arch/ppc/platforms/prep_pci.c
@@ -1099,7 +1099,6 @@ prep_pib_init(void)
 				pci_write_config_byte(dev, 0x43, reg);
 			}
 		}
-		pci_dev_put(dev);
 	}
 
 	if ((dev = pci_get_device(PCI_VENDOR_ID_WINBOND,
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
git-agpgart.patch
git-powerpc.patch
git-input.patch
arch-cris-added-a-missing-iounmap.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
