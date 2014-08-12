From: akpm@linux-foundation.org
Subject: [merged] atm-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:19 -0700
Message-ID: <53ea6e1b.yBcc9ueewnIRCr7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:38836 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:20 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1307113yhl.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     Subject: atm: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     atm-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: atm: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/he.c       |   31 +++++++++++++++----------------
 drivers/atm/idt77252.c |   15 ++++++---------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff -puN drivers/atm/he.c~atm-use-pci_zalloc_consistent drivers/atm/he.c
--- a/drivers/atm/he.c~atm-use-pci_zalloc_consistent
+++ a/drivers/atm/he.c
@@ -533,14 +533,13 @@ static void he_init_tx_lbfp(struct he_de
 
 static int he_init_tpdrq(struct he_dev *he_dev)
 {
-	he_dev->tpdrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq), &he_dev->tpdrq_phys);
+	he_dev->tpdrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						   CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq),
+						   &he_dev->tpdrq_phys);
 	if (he_dev->tpdrq_base == NULL) {
 		hprintk("failed to alloc tpdrq\n");
 		return -ENOMEM;
 	}
-	memset(he_dev->tpdrq_base, 0,
-				CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq));
 
 	he_dev->tpdrq_tail = he_dev->tpdrq_base;
 	he_dev->tpdrq_head = he_dev->tpdrq_base;
@@ -804,13 +803,13 @@ static int he_init_group(struct he_dev *
 		goto out_free_rbpl_virt;
 	}
 
-	he_dev->rbpl_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_RBPL_SIZE * sizeof(struct he_rbp), &he_dev->rbpl_phys);
+	he_dev->rbpl_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_RBPL_SIZE * sizeof(struct he_rbp),
+						  &he_dev->rbpl_phys);
 	if (he_dev->rbpl_base == NULL) {
 		hprintk("failed to alloc rbpl_base\n");
 		goto out_destroy_rbpl_pool;
 	}
-	memset(he_dev->rbpl_base, 0, CONFIG_RBPL_SIZE * sizeof(struct he_rbp));
 
 	INIT_LIST_HEAD(&he_dev->rbpl_outstanding);
 
@@ -843,13 +842,13 @@ static int he_init_group(struct he_dev *
 
 	/* rx buffer ready queue */
 
-	he_dev->rbrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq), &he_dev->rbrq_phys);
+	he_dev->rbrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq),
+						  &he_dev->rbrq_phys);
 	if (he_dev->rbrq_base == NULL) {
 		hprintk("failed to allocate rbrq\n");
 		goto out_free_rbpl;
 	}
-	memset(he_dev->rbrq_base, 0, CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq));
 
 	he_dev->rbrq_head = he_dev->rbrq_base;
 	he_writel(he_dev, he_dev->rbrq_phys, G0_RBRQ_ST + (group * 16));
@@ -867,13 +866,13 @@ static int he_init_group(struct he_dev *
 
 	/* tx buffer ready queue */
 
-	he_dev->tbrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq), &he_dev->tbrq_phys);
+	he_dev->tbrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq),
+						  &he_dev->tbrq_phys);
 	if (he_dev->tbrq_base == NULL) {
 		hprintk("failed to allocate tbrq\n");
 		goto out_free_rbpq_base;
 	}
-	memset(he_dev->tbrq_base, 0, CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq));
 
 	he_dev->tbrq_head = he_dev->tbrq_base;
 
@@ -1460,13 +1459,13 @@ static int he_start(struct atm_dev *dev)
 
 	/* host status page */
 
-	he_dev->hsp = pci_alloc_consistent(he_dev->pci_dev,
-				sizeof(struct he_hsp), &he_dev->hsp_phys);
+	he_dev->hsp = pci_zalloc_consistent(he_dev->pci_dev,
+					    sizeof(struct he_hsp),
+					    &he_dev->hsp_phys);
 	if (he_dev->hsp == NULL) {
 		hprintk("failed to allocate host status page\n");
 		return -ENOMEM;
 	}
-	memset(he_dev->hsp, 0, sizeof(struct he_hsp));
 	he_writel(he_dev, he_dev->hsp_phys, HSP_BA);
 
 	/* initialize framer */
diff -puN drivers/atm/idt77252.c~atm-use-pci_zalloc_consistent drivers/atm/idt77252.c
--- a/drivers/atm/idt77252.c~atm-use-pci_zalloc_consistent
+++ a/drivers/atm/idt77252.c
@@ -641,13 +641,11 @@ alloc_scq(struct idt77252_dev *card, int
 	scq = kzalloc(sizeof(struct scq_info), GFP_KERNEL);
 	if (!scq)
 		return NULL;
-	scq->base = pci_alloc_consistent(card->pcidev, SCQ_SIZE,
-					 &scq->paddr);
+	scq->base = pci_zalloc_consistent(card->pcidev, SCQ_SIZE, &scq->paddr);
 	if (scq->base == NULL) {
 		kfree(scq);
 		return NULL;
 	}
-	memset(scq->base, 0, SCQ_SIZE);
 
 	scq->next = scq->base;
 	scq->last = scq->base + (SCQ_ENTRIES - 1);
@@ -972,13 +970,12 @@ init_rsq(struct idt77252_dev *card)
 {
 	struct rsq_entry *rsqe;
 
-	card->rsq.base = pci_alloc_consistent(card->pcidev, RSQSIZE,
-					      &card->rsq.paddr);
+	card->rsq.base = pci_zalloc_consistent(card->pcidev, RSQSIZE,
+					       &card->rsq.paddr);
 	if (card->rsq.base == NULL) {
 		printk("%s: can't allocate RSQ.\n", card->name);
 		return -1;
 	}
-	memset(card->rsq.base, 0, RSQSIZE);
 
 	card->rsq.last = card->rsq.base + RSQ_NUM_ENTRIES - 1;
 	card->rsq.next = card->rsq.last;
@@ -3400,14 +3397,14 @@ static int init_card(struct atm_dev *dev
 	writel(0, SAR_REG_GP);
 
 	/* Initialize RAW Cell Handle Register  */
-	card->raw_cell_hnd = pci_alloc_consistent(card->pcidev, 2 * sizeof(u32),
-						  &card->raw_cell_paddr);
+	card->raw_cell_hnd = pci_zalloc_consistent(card->pcidev,
+						   2 * sizeof(u32),
+						   &card->raw_cell_paddr);
 	if (!card->raw_cell_hnd) {
 		printk("%s: memory allocation failure.\n", card->name);
 		deinit_card(card);
 		return -1;
 	}
-	memset(card->raw_cell_hnd, 0, 2 * sizeof(u32));
 	writel(card->raw_cell_paddr, SAR_REG_RAWHND);
 	IPRINTK("%s: raw cell handle is at 0x%p.\n", card->name,
 		card->raw_cell_hnd);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

