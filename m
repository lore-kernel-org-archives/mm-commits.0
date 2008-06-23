From: akpm@linux-foundation.org
Subject: - pnp-add-pnp_resource_type_name-helper-function.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:56 -0700
Message-ID: <200806232102.m5NL2uDc016118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034AbYFWVDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     pnp: add pnp_resource_type_name() helper function
has been removed from the -mm tree.  Its filename was
     pnp-add-pnp_resource_type_name-helper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: add pnp_resource_type_name() helper function
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This patch adds a "pnp_resource_type_name(struct resource *)" that returns the
string resource type.  This will be used by the sysfs "show resources"
function and the debug resource dump function.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Acked-by: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h    |    1 +
 drivers/pnp/support.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff -puN drivers/pnp/base.h~pnp-add-pnp_resource_type_name-helper-function drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-add-pnp_resource_type_name-helper-function
+++ a/drivers/pnp/base.h
@@ -43,6 +43,7 @@ int pnp_check_mem(struct pnp_dev *dev, s
 int pnp_check_irq(struct pnp_dev *dev, struct resource *res);
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res);
 
+char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_init_resource(struct resource *res);
diff -puN drivers/pnp/support.c~pnp-add-pnp_resource_type_name-helper-function drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-add-pnp_resource_type_name-helper-function
+++ a/drivers/pnp/support.c
@@ -52,6 +52,21 @@ void pnp_eisa_id_to_string(u32 id, char 
 	str[7] = '\0';
 }
 
+char *pnp_resource_type_name(struct resource *res)
+{
+	switch (pnp_resource_type(res)) {
+	case IORESOURCE_IO:
+		return "io";
+	case IORESOURCE_MEM:
+		return "mem";
+	case IORESOURCE_IRQ:
+		return "irq";
+	case IORESOURCE_DMA:
+		return "dma";
+	}
+	return NULL;
+}
+
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
 #ifdef DEBUG
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

