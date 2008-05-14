From: akpm@linux-foundation.org
Subject: - pnp-remove-ratelimit-on-add-resource-failures.patch removed from -mm tree
Date: Tue, 13 May 2008 19:43:05 -0700
Message-ID: <200805140243.m4E2h5dK012710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759526AbYENCnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 22:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     pnp: remove ratelimit on add resource failures
has been removed from the -mm tree.  Its filename was
     pnp-remove-ratelimit-on-add-resource-failures.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: remove ratelimit on add resource failures
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We used to have a fixed-size resource table.  If a device had twenty resources
when the table only had space for ten, we didn't need ten warnings, so we
added the ratelimit.

Now that we can dynamically allocate new resources, we should only get
failures if the allocation fails.  That should be rare enough that we don't
need to ratelimit the messages.

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

 drivers/pnp/resource.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff -puN drivers/pnp/resource.c~pnp-remove-ratelimit-on-add-resource-failures drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-remove-ratelimit-on-add-resource-failures
+++ a/drivers/pnp/resource.c
@@ -537,15 +537,10 @@ struct pnp_resource *pnp_add_irq_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IRQ %d\n",
-				irq);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IRQ %d\n", irq);
 		return NULL;
 	}
 
@@ -563,15 +558,10 @@ struct pnp_resource *pnp_add_dma_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for DMA %d\n",
-				dma);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for DMA %d\n", dma);
 		return NULL;
 	}
 
@@ -590,16 +580,12 @@ struct pnp_resource *pnp_add_io_resource
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IO "
-				"%#llx-%#llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IO %#llx-%#llx\n",
+			(unsigned long long) start,
+			(unsigned long long) end);
 		return NULL;
 	}
 
@@ -619,16 +605,12 @@ struct pnp_resource *pnp_add_mem_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for MEM "
-				"%#llx-%#llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for MEM %#llx-%#llx\n",
+			(unsigned long long) start,
+			(unsigned long long) end);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-cleanup-pnp_fixup_device.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-isapnp-mpu-option-quirks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

