From: akpm@linux-foundation.org
Subject: + isapnp-fix-limits-of-logical-device-register-set.patch added to -mm tree
Date: Fri, 21 Mar 2008 16:02:53 -0700
Message-ID: <200803212302.m2LN2rtZ015232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763590AbYCUXDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 19:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@perex.cz, stable@kernel.org


The patch titled
     isapnp: fix limits of logical device register set
has been added to the -mm tree.  Its filename is
     isapnp-fix-limits-of-logical-device-register-set.patch

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
Subject: isapnp: fix limits of logical device register set
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Without this patch, we can read and write off the end of the ISAPNP hardware
register set with unknown consequences.  This was also broken in 2.6.24, and I
haven't heard any reports, but if 2.6.25 ends up being more widely-used,
ISAPNP users might start tripping over it.


PNP_MAX_MEM and PNP_MAX_PORT are mainly used to size tables of PNP device
resources.  In 2.6.24, we increased their values to accomodate ACPI devices
that have many resources:

                 2.6.23    2.6.24
                 ------    ------
  PNP_MAX_MEM       4         12
  PNP_MAX_PORT      8         40

However, ISAPNP also used these constants as the size of parts of the logical
device register set.  This register set is fixed by hardware, so increasing
the constants meant that we were reading and writing unintended parts of the
register set.

This patch changes ISAPNP to use the correct register set sizes (the
same values we used prior to 2.6.24).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: <stable@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/core.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/pnp/isapnp/core.c~isapnp-fix-limits-of-logical-device-register-set drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~isapnp-fix-limits-of-logical-device-register-set
+++ a/drivers/pnp/isapnp/core.c
@@ -88,6 +88,15 @@ MODULE_LICENSE("GPL");
 #define _LTAG_MEM32RANGE	0x85
 #define _LTAG_FIXEDMEM32RANGE	0x86
 
+/*
+ * Sizes of ISAPNP logical device configuration register sets.
+ * See PNP-ISA-v1.0a.pdf, Appendix A.
+ */
+#define ISAPNP_MAX_MEM		4
+#define ISAPNP_MAX_PORT		8
+#define ISAPNP_MAX_IRQ		2
+#define ISAPNP_MAX_DMA		2
+
 static unsigned char isapnp_checksum_value;
 static DEFINE_MUTEX(isapnp_cfg_mutex);
 static int isapnp_csn_count;
@@ -945,14 +954,14 @@ static int isapnp_read_resources(struct 
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
 			res->port_resource[tmp].start = ret;
 			res->port_resource[tmp].flags = IORESOURCE_IO;
 		}
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret =
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
@@ -960,7 +969,7 @@ static int isapnp_read_resources(struct 
 			res->mem_resource[tmp].start = ret;
 			res->mem_resource[tmp].flags = IORESOURCE_MEM;
 		}
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret =
 			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
 			     8);
@@ -970,7 +979,7 @@ static int isapnp_read_resources(struct 
 			    res->irq_resource[tmp].end = ret;
 			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
 		}
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
@@ -1002,14 +1011,14 @@ static int isapnp_set_resources(struct p
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0;
-	     tmp < PNP_MAX_PORT
+	     tmp < ISAPNP_MAX_PORT
 	     && (res->port_resource[tmp].
 		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
 	     tmp++)
 		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 				  res->port_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_IRQ
+	     tmp < ISAPNP_MAX_IRQ
 	     && (res->irq_resource[tmp].
 		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
 	     tmp++) {
@@ -1019,14 +1028,14 @@ static int isapnp_set_resources(struct p
 		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 	}
 	for (tmp = 0;
-	     tmp < PNP_MAX_DMA
+	     tmp < ISAPNP_MAX_DMA
 	     && (res->dma_resource[tmp].
 		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
 	     tmp++)
 		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
 				  res->dma_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_MEM
+	     tmp < ISAPNP_MAX_MEM
 	     && (res->mem_resource[tmp].
 		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
 	     tmp++)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

pnp-increase-the-number-of-memory-resources-from-12-to-24.patch
isapnp-fix-limits-of-logical-device-register-set.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch

