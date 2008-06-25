From: akpm@linux-foundation.org
Subject: + pnp-have-quirk_system_pci_resources-include-io-resources.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:16:27 -0700
Message-ID: <200806252116.m5PLGRbY027277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYFYVQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@gmail.com, bjorn.helgaas@hp.com


The patch titled
     pnp: have quirk_system_pci_resources() include io resources
has been added to the -mm tree.  Its filename is
     pnp-have-quirk_system_pci_resources-include-io-resources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: have quirk_system_pci_resources() include io resources
From: Rene Herman <rene.herman@gmail.com>

quirk_system_pci_resources() disables a PnP mem resource that overlaps a
PCI BAR so as to not keep the PCI driver from claiming the resource.  Have
it do the same for io resources.

Here, ACPI claims ports that overlap with my soundcard causing the
soundcard driver to fail to load.  It's unknown why my ACPI BIOS claims
those ports; it did not use to but this is not a (kernel) regression. 
Some odd BIOS reconfig triggered by temporarily removing the card seems to
have brought this on.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-have-quirk_system_pci_resources-include-io-resources drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-have-quirk_system_pci_resources-include-io-resources
+++ a/drivers/pnp/quirks.c
@@ -245,15 +245,17 @@ static void quirk_system_pci_resources(s
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
-			    pci_resource_len(pdev, i) == 0)
+			unsigned int type;
+
+			type = pci_resource_flags(pdev, i) &
+					(IORESOURCE_IO | IORESOURCE_MEM);
+			if (!type || pci_resource_len(pdev, i) == 0)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
-			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
-			     j++) {
+			     (res = pnp_get_resource(dev, type, j)); j++) {
 				if (res->start == 0 && res->end == 0)
 					continue;
 
@@ -283,9 +285,10 @@ static void quirk_system_pci_resources(s
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "mem resource "
+				dev_warn(&dev->dev, "%s resource "
 					"(0x%llx-0x%llx) overlaps %s BAR %d "
 					"(0x%llx-0x%llx), disabling\n",
+					pnp_resource_type_name(res),
 					(unsigned long long) pnp_start,
 					(unsigned long long) pnp_end,
 					pci_name(pdev), i,
_

Patches currently in -mm which might be from rene.herman@gmail.com are

pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-have-quirk_system_pci_resources-include-io-resources.patch
make-pnp_add_card_id-static.patch

