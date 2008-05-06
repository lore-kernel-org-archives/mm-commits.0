From: akpm@linux-foundation.org
Subject: + pnp-add-pnp_resource_type-internal-interface.patch added to -mm tree
Date: Tue, 06 May 2008 12:00:55 -0700
Message-ID: <200805061900.m46J0ui2022217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385AbYEFTCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: add pnp_resource_type() internal interface
has been added to the -mm tree.  Its filename is
     pnp-add-pnp_resource_type-internal-interface.patch

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
Subject: pnp: add pnp_resource_type() internal interface
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Given a struct resource, this returns the type (IO, MEM, IRQ, DMA).

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

 drivers/pnp/base.h     |    1 +
 drivers/pnp/resource.c |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN drivers/pnp/base.h~pnp-add-pnp_resource_type-internal-interface drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-add-pnp_resource_type-internal-interface
+++ a/drivers/pnp/base.h
@@ -45,6 +45,7 @@ int pnp_check_dma(struct pnp_dev *dev, s
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

