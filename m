From: akpm@linux-foundation.org
Subject: - pnp-add-pnp_resource_type-internal-interface.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:53 -0700
Message-ID: <200806232102.m5NL2rHE016115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757764AbYFWVDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     pnp: add pnp_resource_type() internal interface
has been removed from the -mm tree.  Its filename was
     pnp-add-pnp_resource_type-internal-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: add pnp_resource_type() internal interface
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Given a struct resource, this returns the type (IO, MEM, IRQ, DMA).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Acked-by: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h     |    1 +
 drivers/pnp/resource.c |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN drivers/pnp/base.h~pnp-add-pnp_resource_type-internal-interface drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-add-pnp_resource_type-internal-interface
+++ a/drivers/pnp/base.h
@@ -46,6 +46,7 @@ int pnp_check_dma(struct pnp_dev *dev, s
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_init_resource(struct resource *res);
+int pnp_resource_type(struct resource *res);
 
 struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
 					  unsigned int type, unsigned int num);
diff -puN drivers/pnp/resource.c~pnp-add-pnp_resource_type-internal-interface drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-add-pnp_resource_type-internal-interface
+++ a/drivers/pnp/resource.c
@@ -499,6 +499,12 @@ int pnp_check_dma(struct pnp_dev *dev, s
 #endif
 }
 
+int pnp_resource_type(struct resource *res)
+{
+	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
+			     IORESOURCE_IRQ | IORESOURCE_DMA);
+}
+
 struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
 					  unsigned int type, unsigned int num)
 {
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

