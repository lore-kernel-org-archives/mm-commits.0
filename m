From: akpm@linux-foundation.org
Subject: - pnp-add-ad1815-and-ad1816-quirks.patch removed from -mm tree
Date: Mon, 12 May 2008 15:54:22 -0700
Message-ID: <200805122254.m4CMsNhU013319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754991AbYELWzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, bjorn.helgaas@hp.com, len.brown@intel.com, rene.herman@gmail.com, tiwai@suse.de, uwe.bugla@gmx.de, mm-commits@vger.kernel.org


The patch titled
     pnp: add AD1815 and AD1816 quirks
has been removed from the -mm tree.  Its filename was
     pnp-add-ad1815-and-ad1816-quirks.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: add AD1815 and AD1816 quirks
From: Rene Herman <rene.herman@keyaccess.nl>

The AD181x chip doesn't support an IRQ-less MPU401 option but works fine
without one.  This adds (priority: functional) IRQ-less options for each port
option to help systems with few available IRQs.

The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
penalizing the IRQ.  Also, while not a practical issue due to no IRQ option
being present for the dependents, this needs to add in front, not back.

Doesn't use pnp_register_port_resource() for symetry with above.

This does not delete the AD1815 independent option even though it should be
empty after the IRQ transfer due to AD1816 coming with an empty but still
present independent option by default.

Was tested on AD1815 and AD1816.  The ALSA driver also support the AZT2002 ID
for MPU401 but this doesn't as I was unable to test it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |  112 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff -puN drivers/pnp/quirks.c~pnp-add-ad1815-and-ad1816-quirks drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-add-ad1815-and-ad1816-quirks
+++ a/drivers/pnp/quirks.c
@@ -111,6 +111,114 @@ static void quirk_sb16audio_resources(st
 		dev_info(&dev->dev, "SB audio device quirk - increased port range\n");
 }
 
+static struct pnp_option *quirk_ad181x_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *head = NULL;
+	struct pnp_option *prev = NULL;
+	struct pnp_option *res;
+
+	/*
+	 * Build a functional IRQ-less variant of each MPU option.
+	 */
+
+	for (res = dev->dependent; res; res = res->next) {
+		struct pnp_option *curr;
+		struct pnp_port *port;
+		struct pnp_port *copy;
+
+		port = res->port;
+		if (!port || !res->irq)
+			continue;
+
+		copy = pnp_alloc(sizeof *copy);
+		if (!copy)
+			break;
+
+		copy->min = port->min;
+		copy->max = port->max;
+		copy->align = port->align;
+		copy->size = port->size;
+		copy->flags = port->flags;
+
+		curr = pnp_build_option(PNP_RES_PRIORITY_FUNCTIONAL);
+		if (!curr) {
+			kfree(copy);
+			break;
+		}
+		curr->port = copy;
+
+		if (prev)
+			prev->next = curr;
+		else
+			head = curr;
+		prev = curr;
+	}
+	return head;
+}
+
+static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *res;
+	struct pnp_irq *irq;
+
+	/*
+	 * Distribute the independent IRQ over the dependent options
+	 */
+
+	res = dev->independent;
+	if (!res)
+		return;
+
+	irq = res->irq;
+	if (!irq || irq->next)
+		return;
+
+	res = dev->dependent;
+	if (!res)
+		return;
+
+	while (1) {
+		struct pnp_irq *copy;
+
+		copy = pnp_alloc(sizeof *copy);
+		if (!copy)
+			return;
+
+		memcpy(copy->map, irq->map, sizeof copy->map);
+		copy->flags = irq->flags;
+
+		copy->next = res->irq; /* Yes, this is NULL */
+		res->irq = copy;
+
+		if (!res->next)
+			break;
+		res = res->next;
+	}
+	kfree(irq);
+
+	res->next = quirk_ad181x_mpu_resources(dev);
+
+	res = dev->independent;
+	res->irq = NULL;
+
+	printk(KERN_INFO "pnp: adding IRQ-less AD1815 MPU options\n");
+}
+
+static void quirk_ad1816_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *res;
+
+	res = dev->dependent;
+	if (!res)
+		return;
+
+	while (res->next)
+		res = res->next;
+
+	res->next = quirk_ad181x_mpu_resources(dev);
+
+	printk(KERN_INFO "pnp: adding IRQ-less AD1816 MPU options\n");
+}
 
 #include <linux/pci.h>
 
@@ -205,6 +313,10 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	/* Add IRQ-less AD1815 MPU options */
+	{"ADS7151", quirk_ad1815_mpu_resources},
+	/* Add IRQ-less AD1816 MPU options */
+	{"ADS7181", quirk_ad1816_mpu_resources},
 	{"PNP0c01", quirk_system_pci_resources},
 	{"PNP0c02", quirk_system_pci_resources},
 	{""}
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

linux-next.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-ad1815-and-ad1816-quirks.patch
pnp-add-isapnp-mpu-option-quirks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch

