From: akpm@linux-foundation.org
Subject: + pnp-add-isapnp-mpu-option-quirks.patch added to -mm tree
Date: Mon, 12 May 2008 15:56:47 -0700
Message-ID: <200805122256.m4CMulBr013362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbYELW5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, bjorn.helgaas@hp.com, len.brown@intel.com, rene.herman@gmail.com, tiwai@suse.de, uwe.bugla@gmx.de


The patch titled
     pnp: add ISAPnP MPU option quirks
has been added to the -mm tree.  Its filename is
     pnp-add-isapnp-mpu-option-quirks.patch

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
Subject: pnp: add ISAPnP MPU option quirks
From: Rene Herman <rene.herman@keyaccess.nl>

The AD181x and AZT230 chips don't support an IRQ-less MPU401 option but
work fine without one.  This adds (priority functional) IRQ-less options
for each port option to help systems with few available IRQs.

The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
penalizing the IRQ.  Also, while not a practical issue due to no IRQ
option being present for the dependents, this needs to add in front, not
back.

Doesn't use pnp_register_port_resource() for symetry with above.

This does not delete the AD1815 independent option even though it should
be empty after the IRQ transfer due to AD1816 coming with an empty but
still present independent option by default.

Was tested on AD1815, AD1816 and AZT230.  The ALSA snd-ad1818a driver also
support the AZT2002 ID for MPU401 but this doesn't as I was unable to test
it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Tested-by: Uwe Bugla <uwe.bugla@gmx.de>
Acked-by: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |  112 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff -puN drivers/pnp/quirks.c~pnp-add-isapnp-mpu-option-quirks drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-add-isapnp-mpu-option-quirks
+++ a/drivers/pnp/quirks.c
@@ -111,6 +111,113 @@ static void quirk_sb16audio_resources(st
 		dev_info(&dev->dev, "SB audio device quirk - increased port range\n");
 }
 
+static struct pnp_option *quirk_isapnp_mpu_options(struct pnp_dev *dev)
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
+	if (head)
+		dev_info(&dev->dev, "adding IRQ-less MPU options\n");
+
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
+			break;
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
+	res->next = quirk_isapnp_mpu_options(dev);
+
+	res = dev->independent;
+	res->irq = NULL;
+}
+
+static void quirk_isapnp_mpu_resources(struct pnp_dev *dev)
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
+	res->next = quirk_isapnp_mpu_options(dev);
+}
 
 #include <linux/pci.h>
 
@@ -205,6 +312,11 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	/* Add IRQ-less MPU options */
+	{"ADS7151", quirk_ad1815_mpu_resources},
+	{"ADS7181", quirk_isapnp_mpu_resources},
+	{"AZT0002", quirk_isapnp_mpu_resources},
+	/* PnP resources that might overlap PCI BARs */
 	{"PNP0c01", quirk_system_pci_resources},
 	{"PNP0c02", quirk_system_pci_resources},
 	{""}
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

linux-next.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-isapnp-mpu-option-quirks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch

