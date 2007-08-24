From: akpm@linux-foundation.org
Subject: - pnp-remove-null-pointer-checks.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:59:06 -0700
Message-ID: <200708242059.l7OKx6bV014367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763128AbXHXVJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz, mm-commits@vger.kernel.org


The patch titled
     PNP: remove null pointer checks
has been removed from the -mm tree.  Its filename was
     pnp-remove-null-pointer-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: remove null pointer checks
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Remove some null pointer checks.  Null pointers in these areas indicate
programming errors, and I think it's better to oops immediately rather
than return an error that is easily ignored.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/core.c        |    7 +------
 drivers/pnp/driver.c      |    4 ----
 drivers/pnp/isapnp/core.c |    2 +-
 drivers/pnp/manager.c     |   23 -----------------------
 drivers/pnp/resource.c    |   26 --------------------------
 5 files changed, 2 insertions(+), 60 deletions(-)

diff -puN drivers/pnp/core.c~pnp-remove-null-pointer-checks drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/core.c
@@ -52,9 +52,6 @@ int pnp_register_protocol(struct pnp_pro
 	int nodenum;
 	struct list_head *pos;
 
-	if (!protocol)
-		return -EINVAL;
-
 	INIT_LIST_HEAD(&protocol->devices);
 	INIT_LIST_HEAD(&protocol->cards);
 	nodenum = 0;
@@ -94,8 +91,6 @@ static void pnp_free_ids(struct pnp_dev 
 	struct pnp_id *id;
 	struct pnp_id *next;
 
-	if (!dev)
-		return;
 	id = dev->id;
 	while (id) {
 		next = id->next;
@@ -143,7 +138,7 @@ int __pnp_add_device(struct pnp_dev *dev
  */
 int pnp_add_device(struct pnp_dev *dev)
 {
-	if (!dev || !dev->protocol || dev->card)
+	if (dev->card)
 		return -EINVAL;
 	dev->dev.parent = &dev->protocol->dev;
 	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
diff -puN drivers/pnp/driver.c~pnp-remove-null-pointer-checks drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/driver.c
@@ -232,10 +232,6 @@ int pnp_add_id(struct pnp_id *id, struct
 {
 	struct pnp_id *ptr;
 
-	if (!id)
-		return -EINVAL;
-	if (!dev)
-		return -EINVAL;
 	id->next = NULL;
 	ptr = dev->id;
 	while (ptr && ptr->next)
diff -puN drivers/pnp/isapnp/core.c~pnp-remove-null-pointer-checks drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/isapnp/core.c
@@ -1040,7 +1040,7 @@ static int isapnp_set_resources(struct p
 
 static int isapnp_disable_resources(struct pnp_dev *dev)
 {
-	if (!dev || !dev->active)
+	if (!dev->active)
 		return -EINVAL;
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	isapnp_deactivate(dev->number);
diff -puN drivers/pnp/manager.c~pnp-remove-null-pointer-checks drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/manager.c
@@ -21,9 +21,6 @@ static int pnp_assign_port(struct pnp_de
 	resource_size_t *start, *end;
 	unsigned long *flags;
 
-	if (!dev || !rule)
-		return -EINVAL;
-
 	if (idx >= PNP_MAX_PORT) {
 		pnp_err
 		    ("More than 4 ports is incompatible with pnp specifications.");
@@ -66,9 +63,6 @@ static int pnp_assign_mem(struct pnp_dev
 	resource_size_t *start, *end;
 	unsigned long *flags;
 
-	if (!dev || !rule)
-		return -EINVAL;
-
 	if (idx >= PNP_MAX_MEM) {
 		pnp_err
 		    ("More than 8 mems is incompatible with pnp specifications.");
@@ -127,9 +121,6 @@ static int pnp_assign_irq(struct pnp_dev
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	if (!dev || !rule)
-		return -EINVAL;
-
 	if (idx >= PNP_MAX_IRQ) {
 		pnp_err
 		    ("More than 2 irqs is incompatible with pnp specifications.");
@@ -181,9 +172,6 @@ static int pnp_assign_dma(struct pnp_dev
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	if (!dev || !rule)
-		return -EINVAL;
-
 	if (idx >= PNP_MAX_DMA) {
 		pnp_err
 		    ("More than 2 dmas is incompatible with pnp specifications.");
@@ -410,8 +398,6 @@ int pnp_manual_config_dev(struct pnp_dev
 	int i;
 	struct pnp_resource_table *bak;
 
-	if (!dev || !res)
-		return -EINVAL;
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
 	bak = pnp_alloc(sizeof(struct pnp_resource_table));
@@ -460,9 +446,6 @@ int pnp_auto_config_dev(struct pnp_dev *
 	struct pnp_option *dep;
 	int i = 1;
 
-	if (!dev)
-		return -EINVAL;
-
 	if (!pnp_can_configure(dev)) {
 		pnp_dbg("Device %s does not support resource configuration.",
 			dev->dev.bus_id);
@@ -541,8 +524,6 @@ int pnp_activate_dev(struct pnp_dev *dev
 {
 	int error;
 
-	if (!dev)
-		return -EINVAL;
 	if (dev->active)
 		return 0;	/* the device is already active */
 
@@ -568,8 +549,6 @@ int pnp_disable_dev(struct pnp_dev *dev)
 {
 	int error;
 
-	if (!dev)
-		return -EINVAL;
 	if (!dev->active)
 		return 0;	/* the device is already disabled */
 
@@ -596,8 +575,6 @@ int pnp_disable_dev(struct pnp_dev *dev)
 void pnp_resource_change(struct resource *resource, resource_size_t start,
 			 resource_size_t size)
 {
-	if (resource == NULL)
-		return;
 	resource->flags &= ~(IORESOURCE_AUTO | IORESOURCE_UNSET);
 	resource->start = start;
 	resource->end = start + size - 1;
diff -puN drivers/pnp/resource.c~pnp-remove-null-pointer-checks drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/resource.c
@@ -47,9 +47,6 @@ struct pnp_option *pnp_register_independ
 {
 	struct pnp_option *option;
 
-	if (!dev)
-		return NULL;
-
 	option = pnp_build_option(PNP_RES_PRIORITY_PREFERRED);
 
 	/* this should never happen but if it does we'll try to continue */
@@ -64,9 +61,6 @@ struct pnp_option *pnp_register_dependen
 {
 	struct pnp_option *option;
 
-	if (!dev)
-		return NULL;
-
 	option = pnp_build_option(priority);
 
 	if (dev->dependent) {
@@ -83,11 +77,6 @@ int pnp_register_irq_resource(struct pnp
 {
 	struct pnp_irq *ptr;
 
-	if (!option)
-		return -EINVAL;
-	if (!data)
-		return -EINVAL;
-
 	ptr = option->irq;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
@@ -112,11 +101,6 @@ int pnp_register_dma_resource(struct pnp
 {
 	struct pnp_dma *ptr;
 
-	if (!option)
-		return -EINVAL;
-	if (!data)
-		return -EINVAL;
-
 	ptr = option->dma;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
@@ -132,11 +116,6 @@ int pnp_register_port_resource(struct pn
 {
 	struct pnp_port *ptr;
 
-	if (!option)
-		return -EINVAL;
-	if (!data)
-		return -EINVAL;
-
 	ptr = option->port;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
@@ -152,11 +131,6 @@ int pnp_register_mem_resource(struct pnp
 {
 	struct pnp_mem *ptr;
 
-	if (!option)
-		return -EINVAL;
-	if (!data)
-		return -EINVAL;
-
 	ptr = option->mem;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
