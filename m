From: akpm@linux-foundation.org
Subject: - pnp-make-resource-option-structures-private-to-pnp-subsystem.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:22 -0700
Message-ID: <200806232103.m5NL3MmL016154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034AbYFWVEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     pnp: make resource option structures private to PNP subsystem
has been removed from the -mm tree.  Its filename was
     pnp-make-resource-option-structures-private-to-pnp-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: make resource option structures private to PNP subsystem
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Nothing outside the PNP subsystem should need access to a device's
resource options, so this patch moves the option structure declarations to
a private header file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h  |   48 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pnp.h |   48 ------------------------------------------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff -puN drivers/pnp/base.h~pnp-make-resource-option-structures-private-to-pnp-subsystem drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-make-resource-option-structures-private-to-pnp-subsystem
+++ a/drivers/pnp/base.h
@@ -19,6 +19,54 @@ void pnp_remove_card(struct pnp_card *ca
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
 
+struct pnp_port {
+	unsigned short min;	/* min base number */
+	unsigned short max;	/* max base number */
+	unsigned char align;	/* align boundary */
+	unsigned char size;	/* size of range */
+	unsigned char flags;	/* port flags */
+	unsigned char pad;	/* pad */
+	struct pnp_port *next;	/* next port */
+};
+
+#define PNP_IRQ_NR 256
+struct pnp_irq {
+	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
+	unsigned char flags;	/* IRQ flags */
+	unsigned char pad;	/* pad */
+	struct pnp_irq *next;	/* next IRQ */
+};
+
+struct pnp_dma {
+	unsigned char map;	/* bitmask for DMA channels */
+	unsigned char flags;	/* DMA flags */
+	struct pnp_dma *next;	/* next port */
+};
+
+struct pnp_mem {
+	unsigned int min;	/* min base number */
+	unsigned int max;	/* max base number */
+	unsigned int align;	/* align boundary */
+	unsigned int size;	/* size of range */
+	unsigned char flags;	/* memory flags */
+	unsigned char pad;	/* pad */
+	struct pnp_mem *next;	/* next memory resource */
+};
+
+#define PNP_RES_PRIORITY_PREFERRED	0
+#define PNP_RES_PRIORITY_ACCEPTABLE	1
+#define PNP_RES_PRIORITY_FUNCTIONAL	2
+#define PNP_RES_PRIORITY_INVALID	65535
+
+struct pnp_option {
+	unsigned short priority;	/* priority */
+	struct pnp_port *port;		/* first port */
+	struct pnp_irq *irq;		/* first IRQ */
+	struct pnp_dma *dma;		/* first DMA */
+	struct pnp_mem *mem;		/* first memory resource */
+	struct pnp_option *next;	/* used to chain dependent resources */
+};
+
 struct pnp_option *pnp_build_option(int priority);
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
diff -puN include/linux/pnp.h~pnp-make-resource-option-structures-private-to-pnp-subsystem include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-make-resource-option-structures-private-to-pnp-subsystem
+++ a/include/linux/pnp.h
@@ -175,54 +175,6 @@ static inline int pnp_dma_valid(struct p
 }
 
 
-struct pnp_port {
-	unsigned short min;	/* min base number */
-	unsigned short max;	/* max base number */
-	unsigned char align;	/* align boundary */
-	unsigned char size;	/* size of range */
-	unsigned char flags;	/* port flags */
-	unsigned char pad;	/* pad */
-	struct pnp_port *next;	/* next port */
-};
-
-#define PNP_IRQ_NR 256
-struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
-	unsigned char flags;	/* IRQ flags */
-	unsigned char pad;	/* pad */
-	struct pnp_irq *next;	/* next IRQ */
-};
-
-struct pnp_dma {
-	unsigned char map;	/* bitmask for DMA channels */
-	unsigned char flags;	/* DMA flags */
-	struct pnp_dma *next;	/* next port */
-};
-
-struct pnp_mem {
-	unsigned int min;	/* min base number */
-	unsigned int max;	/* max base number */
-	unsigned int align;	/* align boundary */
-	unsigned int size;	/* size of range */
-	unsigned char flags;	/* memory flags */
-	unsigned char pad;	/* pad */
-	struct pnp_mem *next;	/* next memory resource */
-};
-
-#define PNP_RES_PRIORITY_PREFERRED	0
-#define PNP_RES_PRIORITY_ACCEPTABLE	1
-#define PNP_RES_PRIORITY_FUNCTIONAL	2
-#define PNP_RES_PRIORITY_INVALID	65535
-
-struct pnp_option {
-	unsigned short priority;	/* priority */
-	struct pnp_port *port;		/* first port */
-	struct pnp_irq *irq;		/* first IRQ */
-	struct pnp_dma *dma;		/* first DMA */
-	struct pnp_mem *mem;		/* first memory resource */
-	struct pnp_option *next;	/* used to chain dependent resources */
-};
