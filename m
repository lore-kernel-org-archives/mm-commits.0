From: akpm@linux-foundation.org
Subject: - pnp-dont-sort-by-type-in-sys-resources.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:09 -0700
Message-ID: <200806232103.m5NL39RF016139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310AbYFWVDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, ambx1@neo.rr.com, castet.matthieu@free.fr, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commi


The patch titled
     pnp: dont sort by type in /sys/.../resources
has been removed from the -mm tree.  Its filename was
     pnp-dont-sort-by-type-in-sys-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: dont sort by type in /sys/.../resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Rather than stepping through all IO resources, then stepping through
all MMIO resources, etc., we can just iterate over the resource list
once directly.

This can change the order in /sys, e.g.,

    # cat /sys/devices/pnp0/00:07/resources     # OLD
    state = active
    io 0x3f8-0x3ff
    irq 4

    # cat /sys/devices/pnp0/00:07/resources     # NEW
    state = active
    irq 4
    io 0x3f8-0x3ff

The old code artificially sorted resources by type; the new code
just lists them in the order we read them from the ISAPNP hardware
or the BIOS.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |   58 +++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff -puN drivers/pnp/interface.c~pnp-dont-sort-by-type-in-sys-resources drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-dont-sort-by-type-in-sys-resources
+++ a/drivers/pnp/interface.c
@@ -248,8 +248,9 @@ static ssize_t pnp_show_current_resource
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i, ret;
+	int ret;
 	pnp_info_buffer_t *buffer;
 
 	if (!dev)
@@ -262,46 +263,33 @@ static ssize_t pnp_show_current_resource
 	buffer->buffer = buf;
 	buffer->curr = buffer->buffer;
 
-	pnp_printf(buffer, "state = ");
-	if (dev->active)
-		pnp_printf(buffer, "active\n");
-	else
-		pnp_printf(buffer, "disabled\n");
-
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
-		pnp_printf(buffer, "io");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " 0x%llx-0x%llx\n",
-				   (unsigned long long) res->start,
-				   (unsigned long long) res->end);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		pnp_printf(buffer, "mem");
-		if (res->flags & IORESOURCE_DISABLED)
+	pnp_printf(buffer, "state = %s\n", dev->active ? "active" : "disabled");
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+
+		pnp_printf(buffer, pnp_resource_type_name(res));
+
+		if (res->flags & IORESOURCE_DISABLED) {
 			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " 0x%llx-0x%llx\n",
+			continue;
+		}
+
+		switch (pnp_resource_type(res)) {
+		case IORESOURCE_IO:
+		case IORESOURCE_MEM:
+			pnp_printf(buffer, " %#llx-%#llx\n",
 				   (unsigned long long) res->start,
 				   (unsigned long long) res->end);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
-		pnp_printf(buffer, "irq");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " %lld\n",
-				   (unsigned long long) res->start);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
-		pnp_printf(buffer, "dma");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
+			break;
+		case IORESOURCE_IRQ:
+		case IORESOURCE_DMA:
 			pnp_printf(buffer, " %lld\n",
 				   (unsigned long long) res->start);
+			break;
+		}
 	}
+
 	ret = (buffer->curr - buf);
 	kfree(buffer);
 	return ret;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

