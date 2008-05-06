From: akpm@linux-foundation.org
Subject: + pnp-remove-pnp_resourceindex.patch added to -mm tree
Date: Tue, 06 May 2008 12:00:52 -0700
Message-ID: <200805061900.m46J0rtd022214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958AbYEFTCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: remove pnp_resource.index
has been added to the -mm tree.  Its filename is
     pnp-remove-pnp_resourceindex.patch

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
Subject: pnp: remove pnp_resource.index
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We used pnp_resource.index to keep track of which ISAPNP configuration
register a resource should be written to.  We needed this only to handle the
case where a register is disabled but a subsequent register in the same set is
enabled.

Rather than explicitly maintaining the pnp_resource.index, this patch adds a
resource every time we read an ISAPNP configuration register and marks the
resource as IORESOURCE_DISABLED when appropriate.  This makes the position in
the pnp_resource_table always correspond to the config register index.

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

 drivers/pnp/base.h        |    1 
 drivers/pnp/interface.c   |   20 +-------
 drivers/pnp/isapnp/core.c |   84 ++++++++++++------------------------
 drivers/pnp/manager.c     |    4 -
 4 files changed, 33 insertions(+), 76 deletions(-)

diff -puN drivers/pnp/base.h~pnp-remove-pnp_resourceindex drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-remove-pnp_resourceindex
+++ a/drivers/pnp/base.h
@@ -56,7 +56,6 @@ struct pnp_resource *pnp_get_pnp_resourc
 
 struct pnp_resource {
 	struct resource res;
-	unsigned int index;		/* ISAPNP config register index */
 };
 
 struct pnp_resource_table {
diff -puN drivers/pnp/interface.c~pnp-remove-pnp_resourceindex drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-remove-pnp_resourceindex
+++ a/drivers/pnp/interface.c
@@ -320,7 +320,6 @@ pnp_set_current_resources(struct device 
 			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
-	struct pnp_resource *pnp_res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
 	resource_size_t start, end;
@@ -368,7 +367,6 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -391,10 +389,7 @@ pnp_set_current_resources(struct device 
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
-				pnp_res = pnp_add_io_resource(dev, start, end,
-							      0);
-				if (pnp_res)
-					pnp_res->index = nport++;
+				pnp_add_io_resource(dev, start, end, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
@@ -411,10 +406,7 @@ pnp_set_current_resources(struct device 
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
-				pnp_res = pnp_add_mem_resource(dev, start, end,
-							       0);
-				if (pnp_res)
-					pnp_res->index = nmem++;
+				pnp_add_mem_resource(dev, start, end, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
@@ -422,9 +414,7 @@ pnp_set_current_resources(struct device 
 				while (isspace(*buf))
 					++buf;
 				start = simple_strtoul(buf, &buf, 0);
-				pnp_res = pnp_add_irq_resource(dev, start, 0);
-				if (pnp_res)
-					pnp_res->index = nirq++;
+				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
@@ -432,9 +422,7 @@ pnp_set_current_resources(struct device 
 				while (isspace(*buf))
 					++buf;
 				start = simple_strtoul(buf, &buf, 0);
-				pnp_res = pnp_add_dma_resource(dev, start, 0);
-				if (pnp_res)
-					pnp_res->index = ndma++;
+				pnp_add_dma_resource(dev, start, 0);
 				continue;
 			}
 			break;
diff -puN drivers/pnp/isapnp/core.c~pnp-remove-pnp_resourceindex drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-remove-pnp_resourceindex
+++ a/drivers/pnp/isapnp/core.c
@@ -928,7 +928,6 @@ EXPORT_SYMBOL(isapnp_write_byte);
 
 static int isapnp_get_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource *pnp_res;
 	int i, ret;
 
 	dev_dbg(&dev->dev, "get resources\n");
@@ -940,35 +939,23 @@ static int isapnp_get_resources(struct p
 
 	for (i = 0; i < ISAPNP_MAX_PORT; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_PORT + (i << 1));
-		if (ret) {
-			pnp_res = pnp_add_io_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_io_resource(dev, ret, ret,
+				    ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_MEM; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
-		if (ret) {
-			pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_mem_resource(dev, ret, ret,
+				     ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >> 8;
-		if (ret) {
-			pnp_res = pnp_add_irq_resource(dev, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_irq_resource(dev, ret,
+				     ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_DMA; i++) {
 		ret = isapnp_read_byte(ISAPNP_CFG_DMA + i);
-		if (ret != 4) {
-			pnp_res = pnp_add_dma_resource(dev, ret, 0);
-			if  (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_dma_resource(dev, ret,
+				     ret == 4 ? IORESOURCE_DISABLED : 0);
 	}
 
 __end:
@@ -978,62 +965,49 @@ __end:
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int tmp, index;
+	int tmp;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_PORT + (index << 1),
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 					  res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
+		res = pnp_get_resource(dev, IORESOURCE_IRQ, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
-			index = pnp_res->index;
-			dev_dbg(&dev->dev, "  set irq %d to %d\n", index, irq);
-			isapnp_write_byte(ISAPNP_CFG_IRQ + (index << 1), irq);
+			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
+			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_byte(ISAPNP_CFG_DMA + index, res->start);
+				tmp, (unsigned long long) res->start);
+			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
 					  (res->start >> 8) & 0xffff);
 		}
 	}
diff -puN drivers/pnp/manager.c~pnp-remove-pnp_resourceindex drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-remove-pnp_resourceindex
+++ a/drivers/pnp/manager.c
@@ -40,7 +40,6 @@ static int pnp_assign_port(struct pnp_de
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IO;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -90,7 +89,6 @@ static int pnp_assign_mem(struct pnp_dev
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_MEM;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -155,7 +153,6 @@ static int pnp_assign_irq(struct pnp_dev
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IRQ;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -214,7 +211,6 @@ static void pnp_assign_dma(struct pnp_de
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_DMA;
 	res->flags &= ~IORESOURCE_UNSET;
 
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

