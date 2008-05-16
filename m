From: akpm@linux-foundation.org
Subject: + pnp-remove-ratelimit-on-add-resource-failures.patch added to -mm tree
Date: Thu, 15 May 2008 17:11:38 -0700
Message-ID: <200805160011.m4G0Bcv3017589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758148AbYEPAMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, ambx1@neo.rr.com, castet.matthieu@free.fr, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: remove ratelimit on add resource failures
has been added to the -mm tree.  Its filename is
     pnp-remove-ratelimit-on-add-resource-failures.patch

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
Subject: pnp: remove ratelimit on add resource failures
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We used to have a fixed-size resource table.  If a device had
twenty resources when the table only had space for ten, we didn't
need ten warnings, so we added the ratelimit.

Now that we can dynamically allocate new resources, we should
only get failures if the allocation fails.  That should be
rare enough that we don't need to ratelimit the messages.

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

