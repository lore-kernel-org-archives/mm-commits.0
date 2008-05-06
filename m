From: akpm@linux-foundation.org
Subject: + pnp-add-pnp_resource_type_name-helper-function.patch added to -mm tree
Date: Tue, 06 May 2008 12:00:57 -0700
Message-ID: <200805061900.m46J0vHF022220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756646AbYEFTCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: add pnp_resource_type_name() helper function
has been added to the -mm tree.  Its filename is
     pnp-add-pnp_resource_type_name-helper-function.patch

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
Cc: Rene Herman <rene.herman@keyaccess.nl>
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
@@ -42,6 +42,7 @@ int pnp_check_mem(struct pnp_dev *dev, s
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

