From: akpm@linux-foundation.org
Subject: + pnp-dont-sort-by-type-in-sys-resources.patch added to -mm tree
Date: Tue, 06 May 2008 12:01:05 -0700
Message-ID: <200805061901.m46J16Nb022235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbYEFTCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: dont sort by type in /sys/.../resources
has been added to the -mm tree.  Its filename is
     pnp-dont-sort-by-type-in-sys-resources.patch

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
Subject: pnp: dont sort by type in /sys/.../resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Rather than stepping through all IO resources, then stepping through all MMIO
resources, etc., we can just iterate over the resource list once directly.

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
Cc: Len Brown <lenb@kernel.org>
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
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-irq-index-in-sysfs-set-irq-interface.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

