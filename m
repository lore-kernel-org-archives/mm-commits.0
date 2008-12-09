From: akpm@linux-foundation.org
Subject: - drivers-parisc-make-code-static.patch removed from -mm tree
Date: Tue, 09 Dec 2008 10:45:53 -0800
Message-ID: <200812091845.mB9Ijr6r027127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546AbYLISqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 13:46:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     drivers/parisc/: make code static
has been removed from the -mm tree.  Its filename was
     drivers-parisc-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/parisc/: make code static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global code static:

- asp.c: asp_init_chip()
- ccio-dma.c: ccio_io_pdir_entry()
- dino.c: struct dino_port_ops
- dino.c: struct dino_bios_ops
- hppb.c: struct hppb_card_head
- lasi.c: lasi_led_init()
- lasi.c: lasi_init_chip()
- lba_pci.c: struct lba_bios_ops
- sba_iommu.c: sba_io_pdir_entry()
- sba_iommu.c: sba_driver_callback()
- sba_iommu.c: sba_driver_callback()
- wax.c: wax_init_chip()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/asp.c       |    3 +--
 drivers/parisc/ccio-dma.c  |    2 +-
 drivers/parisc/dino.c      |    4 ++--
 drivers/parisc/hppb.c      |    2 +-
 drivers/parisc/lasi.c      |    5 ++---
 drivers/parisc/lba_pci.c   |    2 +-
 drivers/parisc/sba_iommu.c |    7 +++----
 drivers/parisc/wax.c       |    3 +--
 8 files changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/parisc/asp.c~drivers-parisc-make-code-static drivers/parisc/asp.c
--- a/drivers/parisc/asp.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/asp.c
@@ -71,8 +71,7 @@ static void asp_choose_irq(struct parisc
  */
 #define ASP_INTERRUPT_ADDR 0xf0800000
 
-int __init
-asp_init_chip(struct parisc_device *dev)
+static int __init asp_init_chip(struct parisc_device *dev)
 {
 	struct gsc_irq gsc_irq;
 	int ret;
diff -puN drivers/parisc/ccio-dma.c~drivers-parisc-make-code-static drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/ccio-dma.c
@@ -555,7 +555,7 @@ static u32 hint_lookup[] = {
  * (Load Coherence Index) instruction.  The 8 bits used for the virtual
  * index are bits 12:19 of the value returned by LCI.
  */ 
-void CCIO_INLINE
+static void CCIO_INLINE
 ccio_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
 		   unsigned long hints)
 {
diff -puN drivers/parisc/dino.c~drivers-parisc-make-code-static drivers/parisc/dino.c
--- a/drivers/parisc/dino.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/dino.c
@@ -287,7 +287,7 @@ DINO_PORT_OUT(b,  8, 3)
 DINO_PORT_OUT(w, 16, 2)
 DINO_PORT_OUT(l, 32, 0)
 
-struct pci_port_ops dino_port_ops = {
+static struct pci_port_ops dino_port_ops = {
 	.inb	= dino_in8,
 	.inw	= dino_in16,
 	.inl	= dino_in32,
@@ -690,7 +690,7 @@ dino_fixup_bus(struct pci_bus *bus)
 }
 
 
-struct pci_bios_ops dino_bios_ops = {
+static struct pci_bios_ops dino_bios_ops = {
 	.init		= dino_bios_init,
 	.fixup_bus	= dino_fixup_bus
 };
diff -puN drivers/parisc/hppb.c~drivers-parisc-make-code-static drivers/parisc/hppb.c
--- a/drivers/parisc/hppb.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/hppb.c
@@ -29,7 +29,7 @@ struct hppb_card {
 	struct hppb_card *next;
 };
 
-struct hppb_card hppb_card_head = {
+static struct hppb_card hppb_card_head = {
 	.hpa = 0,
 	.next = NULL,
 };
diff -puN drivers/parisc/lasi.c~drivers-parisc-make-code-static drivers/parisc/lasi.c
--- a/drivers/parisc/lasi.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/lasi.c
@@ -107,7 +107,7 @@ lasi_init_irq(struct gsc_asic *this_lasi
 
 #else
 
-void __init lasi_led_init(unsigned long lasi_hpa)
+static void __init lasi_led_init(unsigned long lasi_hpa)
 {
 	unsigned long datareg;
 
@@ -163,8 +163,7 @@ static void lasi_power_off(void)
 	gsc_writel(0x02, datareg);
 }
 
-int __init
-lasi_init_chip(struct parisc_device *dev)
+static int __init lasi_init_chip(struct parisc_device *dev)
 {
 	extern void (*chassis_power_off)(void);
 	struct gsc_asic *lasi;
diff -puN drivers/parisc/lba_pci.c~drivers-parisc-make-code-static drivers/parisc/lba_pci.c
--- a/drivers/parisc/lba_pci.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/lba_pci.c
@@ -824,7 +824,7 @@ lba_fixup_bus(struct pci_bus *bus)
 }
 
 
-struct pci_bios_ops lba_bios_ops = {
+static struct pci_bios_ops lba_bios_ops = {
 	.init =		lba_bios_init,
 	.fixup_bus =	lba_fixup_bus,
 };
diff -puN drivers/parisc/sba_iommu.c~drivers-parisc-make-code-static drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/sba_iommu.c
@@ -561,7 +561,7 @@ typedef unsigned long space_t;
  * IOMMU uses little endian for the pdir.
  */
 
-void SBA_INLINE
+static void SBA_INLINE
 sba_io_pdir_entry(u64 *pdir_ptr, space_t sid, unsigned long vba,
 		  unsigned long hint)
 {
@@ -1874,7 +1874,7 @@ static struct parisc_device_id sba_tbl[]
 	{ 0, }
 };
 
-int sba_driver_callback(struct parisc_device *);
+static int sba_driver_callback(struct parisc_device *);
 
 static struct parisc_driver sba_driver = {
 	.name =		MODULE_NAME,
@@ -1887,8 +1887,7 @@ static struct parisc_driver sba_driver =
 ** If so, initialize the chip and tell other partners in crime they
 ** have work to do.
 */
-int
-sba_driver_callback(struct parisc_device *dev)
+static int sba_driver_callback(struct parisc_device *dev)
 {
 	struct sba_device *sba_dev;
 	u32 func_class;
diff -puN drivers/parisc/wax.c~drivers-parisc-make-code-static drivers/parisc/wax.c
--- a/drivers/parisc/wax.c~drivers-parisc-make-code-static
+++ a/drivers/parisc/wax.c
@@ -68,8 +68,7 @@ wax_init_irq(struct gsc_asic *wax)
 //	gsc_writel(0xFFFFFFFF, base+0x2000); /* RS232-B on Wax */
 }
 
-int __init
-wax_init_chip(struct parisc_device *dev)
+static int __init wax_init_chip(struct parisc_device *dev)
 {
 	struct gsc_asic *wax;
 	struct parisc_device *parent;
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m68knommu-set-no_dma.patch
reiser4.patch

