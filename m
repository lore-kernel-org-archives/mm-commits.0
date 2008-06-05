From: akpm@linux-foundation.org
Subject: + pnp-make-resource-option-structures-private-to-pnp-subsystem.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:57:12 -0700
Message-ID: <200806050557.m555vCN6028345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbYFEF6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 01:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: make resource option structures private to PNP subsystem
has been added to the -mm tree.  Its filename is
     pnp-make-resource-option-structures-private-to-pnp-subsystem.patch

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
-
 /*
  * Device Management
  */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
provide-rtc_cmos-platform-device-take-2.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnpacpi-fix-shareable-irq-encode-decode.patch
pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch
pnp-whitespace-coding-style-fixes.patch
pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem.patch
pnp-make-resource-option-structures-private-to-pnp-subsystem.patch
pnp-introduce-pnp_irq_mask_t-typedef.patch
pnp-increase-i-o-port-memory-option-address-sizes.patch
pnp-improve-resource-assignment-debug.patch
pnp-in-debug-resource-dump-make-empty-list-obvious.patch
pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure.patch
pnp-remove-redundant-pnp_can_configure-check.patch
pnp-centralize-resource-option-allocations.patch
pnpacpi-ignore-_prs-interrupt-numbers-larger-than-pnp_irq_nr.patch
pnp-rename-pnp_register__resource-local-variables.patch
pnp-support-optional-irq-resources.patch
pnp-remove-extra-0x100-bit-from-option-priority.patch
isapnp-handle-independent-options-following-dependent-ones.patch
pnp-convert-resource-options-to-single-linked-list.patch
make-pnp_add_card_id-static.patch

