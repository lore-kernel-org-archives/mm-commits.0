From: akpm@linux-foundation.org
Subject: - pnp-make-the-resource-type-an-unsigned-long.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:14 -0700
Message-ID: <200810182318.m9INIE6G029238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYJRXSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, andi@firstfloor.org, bjorn.helgaas@hp.com, hpa@zytor.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnp: make the resource type an unsigned long
has been removed from the -mm tree.  Its filename was
     pnp-make-the-resource-type-an-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: make the resource type an unsigned long
From: Rene Herman <rene.herman@keyaccess.nl>

PnP encodes the resource type directly as its struct resource->flags value
which is an unsigned long.  Make it so...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h     |    2 +-
 drivers/pnp/quirks.c   |    2 +-
 drivers/pnp/resource.c |    4 ++--
 include/linux/pnp.h    |    6 ++++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/pnp/base.h~pnp-make-the-resource-type-an-unsigned-long drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-make-the-resource-type-an-unsigned-long
+++ a/drivers/pnp/base.h
@@ -147,7 +147,7 @@ char *pnp_resource_type_name(struct reso
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_free_resources(struct pnp_dev *dev);
-int pnp_resource_type(struct resource *res);
+unsigned long pnp_resource_type(struct resource *res);
 
 struct pnp_resource {
 	struct list_head list;
diff -puN drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-make-the-resource-type-an-unsigned-long
+++ a/drivers/pnp/quirks.c
@@ -245,7 +245,7 @@ static void quirk_system_pci_resources(s
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			unsigned int type;
+			unsigned long type;
 
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
diff -puN drivers/pnp/resource.c~pnp-make-the-resource-type-an-unsigned-long drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-make-the-resource-type-an-unsigned-long
+++ a/drivers/pnp/resource.c
@@ -467,14 +467,14 @@ int pnp_check_dma(struct pnp_dev *dev, s
 #endif
 }
 
-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+				  unsigned long type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
diff -puN include/linux/pnp.h~pnp-make-the-resource-type-an-unsigned-long include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-make-the-resource-type-an-unsigned-long
+++ a/include/linux/pnp.h
@@ -22,9 +22,11 @@ struct pnp_dev;
  * Resource Management
  */
 #ifdef CONFIG_PNP
-struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned long type,
+				unsigned int num);
 #else
-static inline struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned int type, unsigned int num)
+static inline struct resource *pnp_get_resource(struct pnp_dev *dev,
+			unsigned long type, unsigned int num)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

origin.patch

