From: akpm@linux-foundation.org
Subject: + drivers-char-remove-unnecessary-pci_dev_put.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:52:28 -0800
Message-ID: <200711260752.lAQ7qSS8023121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbXKZHww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 02:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     drivers/char: remove unnecessary pci_dev_put
has been added to the -mm tree.  Its filename is
     drivers-char-remove-unnecessary-pci_dev_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char: remove unnecessary pci_dev_put
From: Julia Lawall <julia@diku.dk>

pci_get_class implicitly does a pci_dev_put on its second argument, so
pci_dev_put is only needed if there is a break out of the loop.

The semantic match detecting this problem is as follows:

// <smpl>
@@
expression dev;
expression E;
@@

* pci_dev_put(dev)
  ... when != dev = E
(
* pci_get_device(...,dev)
|
* pci_get_device_reverse(...,dev)
|
* pci_get_subsys(...,dev)
|
* pci_get_class(...,dev)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/agp/amd-k7-agp.c~drivers-char-remove-unnecessary-pci_dev_put drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~drivers-char-remove-unnecessary-pci_dev_put
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -436,10 +436,6 @@ static int __devinit agp_amdk7_probe(str
 				return -ENODEV;
 			}
 			cap_ptr = pci_find_capability(gfxcard, PCI_CAP_ID_AGP);
-			if (!cap_ptr) {
-				pci_dev_put(gfxcard);
-				continue;
-			}
 		}
 
 		/* With so many variants of NVidia cards, it's simpler just
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-sparc64.patch
