From: akpm@linux-foundation.org
Subject: - drivers-pnp-resourcec-add-missing-pci_dev_put.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:44 -0800
Message-ID: <200712010021.lB10LiUp031776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330AbXLAA1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, bjorn.helgaas@hp.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pnp/resource.c: Add missing pci_dev_put
has been removed from the -mm tree.  Its filename was
     drivers-pnp-resourcec-add-missing-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/pnp/resource.c: Add missing pci_dev_put
From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

This was fixed using the following semantic patch.

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_pci_dev;
@@

T *d;
...
for_each_pci_dev(d)
   {... when != pci_dev_put(d)
        when != e = d
(
    return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/resource.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/resource.c~drivers-pnp-resourcec-add-missing-pci_dev_put drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~drivers-pnp-resourcec-add-missing-pci_dev_put
+++ a/drivers/pnp/resource.c
@@ -367,8 +367,10 @@ int pnp_check_irq(struct pnp_dev *dev, i
 	{
 		struct pci_dev *pci = NULL;
 		for_each_pci_dev(pci) {
-			if (pci->irq == *irq)
+			if (pci->irq == *irq) {
+				pci_dev_put(pci);
 				return 0;
+			}
 		}
 	}
 #endif
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
sound-core-memallocc-add-missing-pci_dev_put.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-input.patch
git-sparc64.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
