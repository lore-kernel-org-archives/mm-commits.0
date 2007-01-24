From: akpm@osdl.org
Subject: + make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:50:42 -0800
Message-ID: <200701240750.l0O7ogkr012037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbXAXHyQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, daniel.ritz@gmx.ch, greg@kroah.com, ink@jurassic.park.msu.ru, linux@dominikbrodowski.net, ralf@linux-mips.org


The patch titled
     Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE boot options
has been added to the -mm tree.  Its filename is
     make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE boot options
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

CARDBUS_MEM_SIZE was increased to 64MB on 2.6.20-rc2, but larger size might
result in allocation failure for the reserving itself on some platforms
(for example typical 32bit MIPS).  Make it (and CARDBUS_IO_SIZE too)
customizable by "pci=" option for such platforms.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Greg KH <greg@kroah.com>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    6 +++++
 drivers/pci/pci.c                   |    6 +++++
 drivers/pci/setup-bus.c             |   27 ++++++++++++++------------
 include/linux/pci.h                 |    3 ++
 4 files changed, 30 insertions(+), 12 deletions(-)

diff -puN Documentation/kernel-parameters.txt~make-cardbus_mem_size-and-cardbus_io_size-boot-options Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~make-cardbus_mem_size-and-cardbus_io_size-boot-options
+++ a/Documentation/kernel-parameters.txt
@@ -1269,6 +1269,12 @@ and is between 256 and 4096 characters. 
 				This sorting is done to get a device
 				order compatible with older (<= 2.4) kernels.
 		nobfsort	Don't sort PCI devices into breadth-first order.
+		cbiosize=nn[KMG]	The fixed amount of bus space which is
+				reserved for the CardBus bridge's IO window.
+				The default value is 256 bytes.
+		cbmemsize=nn[KMG]	The fixed amount of bus space which is
+				reserved for the CardBus bridge's memory
+				window. The default value is 64 megabytes.
 
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
diff -puN drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options drivers/pci/pci.c
--- a/drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options
+++ a/drivers/pci/pci.c
@@ -1212,6 +1212,12 @@ static int __devinit pci_setup(char *str
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strncmp(str, "cbiosize=", 9)) {
+				pci_cardbus_io_size =
+					memparse(str + 9, &str);
+			} else if (!strncmp(str, "cbmemsize=", 10)) {
+				pci_cardbus_mem_size =
+					memparse(str + 10, &str);
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff -puN drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options
+++ a/drivers/pci/setup-bus.c
@@ -40,8 +40,11 @@
  * FIXME: IO should be max 256 bytes.  However, since we may
  * have a P2P bridge below a cardbus bridge, we need 4K.
  */
-#define CARDBUS_IO_SIZE		(256)
-#define CARDBUS_MEM_SIZE	(64*1024*1024)
+#define DEFAULT_CARDBUS_IO_SIZE		(256)
+#define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
+/* pci=cbmemsize=nnM,cbiosize=nn can override this */
+unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
+unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 
 static void __devinit
 pbus_assign_resources_sorted(struct pci_bus *bus)
@@ -415,12 +418,12 @@ pci_bus_size_cardbus(struct pci_bus *bus
 	 * Reserve some resources for CardBus.  We reserve
 	 * a fixed amount of bus space for CardBus bridges.
 	 */
-	b_res[0].start = CARDBUS_IO_SIZE;
-	b_res[0].end = b_res[0].start + CARDBUS_IO_SIZE - 1;
+	b_res[0].start = pci_cardbus_io_size;
+	b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
 	b_res[0].flags |= IORESOURCE_IO;
 
-	b_res[1].start = CARDBUS_IO_SIZE;
-	b_res[1].end = b_res[1].start + CARDBUS_IO_SIZE - 1;
+	b_res[1].start = pci_cardbus_io_size;
+	b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
 	b_res[1].flags |= IORESOURCE_IO;
 
 	/*
@@ -440,16 +443,16 @@ pci_bus_size_cardbus(struct pci_bus *bus
 	 * twice the size.
 	 */
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
-		b_res[2].start = CARDBUS_MEM_SIZE;
-		b_res[2].end = b_res[2].start + CARDBUS_MEM_SIZE - 1;
+		b_res[2].start = pci_cardbus_mem_size;
+		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
 
-		b_res[3].start = CARDBUS_MEM_SIZE;
-		b_res[3].end = b_res[3].start + CARDBUS_MEM_SIZE - 1;
+		b_res[3].start = pci_cardbus_mem_size;
+		b_res[3].end = b_res[3].start + pci_cardbus_mem_size - 1;
 		b_res[3].flags |= IORESOURCE_MEM;
 	} else {
-		b_res[3].start = CARDBUS_MEM_SIZE * 2;
-		b_res[3].end = b_res[3].start + CARDBUS_MEM_SIZE * 2 - 1;
+		b_res[3].start = pci_cardbus_mem_size * 2;
+		b_res[3].end = b_res[3].start + pci_cardbus_mem_size * 2 - 1;
 		b_res[3].flags |= IORESOURCE_MEM;
 	}
 }
diff -puN include/linux/pci.h~make-cardbus_mem_size-and-cardbus_io_size-boot-options include/linux/pci.h
--- a/include/linux/pci.h~make-cardbus_mem_size-and-cardbus_io_size-boot-options
+++ a/include/linux/pci.h
@@ -837,5 +837,8 @@ extern int pci_pci_problems;
 #define PCIPCI_ALIMAGIK		32	/* Need low latency setting */
 #define PCIAGP_FAIL		64	/* No PCI to AGP DMA */
 
+extern unsigned long pci_cardbus_io_size;
+extern unsigned long pci_cardbus_mem_size;
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

spi-alternative-fix-for-spi_busnum_to_master.patch
git-mips.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
serial-serial_txx9-driver-update.patch
