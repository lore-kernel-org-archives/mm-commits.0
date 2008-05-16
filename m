From: akpm@linux-foundation.org
Subject: + pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch added to -mm tree
Date: Thu, 15 May 2008 17:11:31 -0700
Message-ID: <200805160011.m4G0BWep017583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758126AbYEPAMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, ambx1@neo.rr.com, castet.matthieu@free.fr, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: make pnp_{port,mem,etc}_start(), et al work for invalid resources
has been added to the -mm tree.  Its filename is
     pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch

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
Subject: pnp: make pnp_{port,mem,etc}_start(), et al work for invalid resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Some callers use pnp_port_start() and similar functions without
making sure the resource is valid.  This patch makes us fall
back to returning the initial values if the resource is not
valid or not even present.

This mostly preserves the previous behavior, where we would just
return the initial values set by pnp_init_resource_table().  The
original 2.6.25 code didn't range-check the "bar", so it would
return garbage if the bar exceeded the table size.  This code
returns sensible values instead.

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

 include/linux/pnp.h |   72 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 12 deletions(-)

diff -puN include/linux/pnp.h~pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources
+++ a/include/linux/pnp.h
@@ -40,19 +40,31 @@ static inline resource_size_t pnp_resour
 static inline resource_size_t pnp_port_start(struct pnp_dev *dev,
 					     unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_IO, bar)->start;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
+
+	if (pnp_resource_valid(res))
+		return res->start;
+	return 0;
 }
 
 static inline resource_size_t pnp_port_end(struct pnp_dev *dev,
 					   unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_IO, bar)->end;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
+
+	if (pnp_resource_valid(res))
+		return res->end;
+	return 0;
 }
 
 static inline unsigned long pnp_port_flags(struct pnp_dev *dev,
 					   unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_IO, bar)->flags;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
+
+	if (pnp_resource_valid(res))
+		return res->flags;
+	return IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
 }
 
 static inline int pnp_port_valid(struct pnp_dev *dev, unsigned int bar)
@@ -63,25 +75,41 @@ static inline int pnp_port_valid(struct 
 static inline resource_size_t pnp_port_len(struct pnp_dev *dev,
 					   unsigned int bar)
 {
-	return pnp_resource_len(pnp_get_resource(dev, IORESOURCE_IO, bar));
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
+
+	if (pnp_resource_valid(res))
+		return pnp_resource_len(res);
+	return 0;
 }
 
 
 static inline resource_size_t pnp_mem_start(struct pnp_dev *dev,
 					    unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->start;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
+
+	if (pnp_resource_valid(res))
+		return res->start;
+	return 0;
 }
 
 static inline resource_size_t pnp_mem_end(struct pnp_dev *dev,
 					  unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->end;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
+
+	if (pnp_resource_valid(res))
+		return res->end;
+	return 0;
 }
 
 static inline unsigned long pnp_mem_flags(struct pnp_dev *dev, unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->flags;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
+
+	if (pnp_resource_valid(res))
+		return res->flags;
+	return IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
 }
 
 static inline int pnp_mem_valid(struct pnp_dev *dev, unsigned int bar)
@@ -92,18 +120,30 @@ static inline int pnp_mem_valid(struct p
 static inline resource_size_t pnp_mem_len(struct pnp_dev *dev,
 					  unsigned int bar)
 {
-	return pnp_resource_len(pnp_get_resource(dev, IORESOURCE_MEM, bar));
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
+
+	if (pnp_resource_valid(res))
+		return pnp_resource_len(res);
+	return 0;
 }
 
 
 static inline resource_size_t pnp_irq(struct pnp_dev *dev, unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_IRQ, bar)->start;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IRQ, bar);
+
+	if (pnp_resource_valid(res))
+		return res->start;
+	return -1;
 }
 
 static inline unsigned long pnp_irq_flags(struct pnp_dev *dev, unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_IRQ, bar)->flags;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IRQ, bar);
+
+	if (pnp_resource_valid(res))
+		return res->flags;
+	return IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 }
 
 static inline int pnp_irq_valid(struct pnp_dev *dev, unsigned int bar)
@@ -114,12 +154,20 @@ static inline int pnp_irq_valid(struct p
 
 static inline resource_size_t pnp_dma(struct pnp_dev *dev, unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_DMA, bar)->start;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_DMA, bar);
+
+	if (pnp_resource_valid(res))
+		return res->start;
+	return -1;
 }
 
 static inline unsigned long pnp_dma_flags(struct pnp_dev *dev, unsigned int bar)
 {
-	return pnp_get_resource(dev, IORESOURCE_DMA, bar)->flags;
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_DMA, bar);
+
+	if (pnp_resource_valid(res))
+		return res->flags;
+	return IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 }
 
 static inline int pnp_dma_valid(struct pnp_dev *dev, unsigned int bar)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
pnp-cleanup-pnp_fixup_device.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-isapnp-mpu-option-quirks.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

