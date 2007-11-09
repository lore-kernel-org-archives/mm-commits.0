From: akpm@linux-foundation.org
Subject: + arch-ppc-remove-an-unnecessary-pci_dev_put.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:05:09 -0800
Message-ID: <200711090405.lA9459pP028550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbXKIEFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     From: Julia Lawall <julia@diku.dk>
has been added to the -mm tree.  Its filename is
     arch-ppc-remove-an-unnecessary-pci_dev_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Julia Lawall <julia@diku.dk>
From: Julia Lawall <julia@diku.dk>


Remove an unnecessary pci_dev_put.  pci_dev_put is called implicitly by the
subsequent call to pci_get_device.

The problem was detected using the following semantic patch, and corrected
by hand.

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

drivers-misc-move-misplaced-pci_dev_puts.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
