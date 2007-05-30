From: akpm@linux-foundation.org
Subject: + potential-parse-error-in-ifdef-update.patch added to -mm tree
Date: Wed, 30 May 2007 12:20:08 -0700
Message-ID: <200705301920.l4UJK8pE002679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756650AbXE3TUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 15:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padator@wanadoo.fr, James.Bottomley@steeleye.com, akpm@linux-foundation.org, ink@jurassic.park.msu.ru, jack@ucw.cz, jeff@garzik.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, rth@twiddle.net, tony.luck@intel.com


The patch titled
     parse errors in ifdefs
has been added to the -mm tree.  Its filename is
     potential-parse-error-in-ifdef-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parse errors in ifdefs
From: Yoann Padioleau <padator@wanadoo.fr>

Fix various bits of obviously-busted code which we're not happening to
compile, due to ifdefs.

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ia64/aliasing-test.c    |    2 +-
 arch/alpha/boot/tools/mkbb.c          |    2 +-
 arch/arm/mm/alignment.c               |    2 +-
 arch/mips/jmr3927/rbhma3100/kgdb_io.c |    2 +-
 arch/mips/pci/pci-ocelot.c            |   14 +++++++-------
 drivers/mtd/nand/ppchameleonevb.c     |    4 ++--
 drivers/net/fec_8xx/fec_main.c        |    2 +-
 drivers/scsi/NCR5380.c                |    2 +-
 fs/udf/super.c                        |    2 +-
 9 files changed, 16 insertions(+), 16 deletions(-)

diff -puN Documentation/ia64/aliasing-test.c~potential-parse-error-in-ifdef-update Documentation/ia64/aliasing-test.c
--- a/Documentation/ia64/aliasing-test.c~potential-parse-error-in-ifdef-update
+++ a/Documentation/ia64/aliasing-test.c
@@ -197,7 +197,7 @@ skip:
 	return rc;
 }
 
-main()
+int main()
 {
 	int rc;
 
diff -puN arch/alpha/boot/tools/mkbb.c~potential-parse-error-in-ifdef-update arch/alpha/boot/tools/mkbb.c
--- a/arch/alpha/boot/tools/mkbb.c~potential-parse-error-in-ifdef-update
+++ a/arch/alpha/boot/tools/mkbb.c
@@ -81,7 +81,7 @@ typedef union __bootblock {
 #define	bootblock_label		__u1.__label
 #define bootblock_checksum	__u2.__checksum
 
-main(int argc, char ** argv)
+int main(int argc, char ** argv)
 {
     bootblock		bootblock_from_disk;
     bootblock		bootloader_image;
diff -puN arch/arm/mm/alignment.c~potential-parse-error-in-ifdef-update arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~potential-parse-error-in-ifdef-update
+++ a/arch/arm/mm/alignment.c
@@ -630,7 +630,7 @@ do_alignment(unsigned long addr, unsigne
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
-	if thumb_mode(regs) {
+	if (thumb_mode(regs)) {
 		fault = __get_user(tinstr, (u16 *)(instrptr & ~1));
 		if (!(fault))
 			instr = thumb2arm(tinstr);
diff -puN arch/mips/jmr3927/rbhma3100/kgdb_io.c~potential-parse-error-in-ifdef-update arch/mips/jmr3927/rbhma3100/kgdb_io.c
--- a/arch/mips/jmr3927/rbhma3100/kgdb_io.c~potential-parse-error-in-ifdef-update
+++ a/arch/mips/jmr3927/rbhma3100/kgdb_io.c
@@ -36,7 +36,7 @@
 #define TIMEOUT       0xffffff
 
 static int remoteDebugInitialized = 0;
-static void debugInit(int baud)
+static void debugInit(int baud);
 
 int putDebugChar(unsigned char c)
 {
diff -puN arch/mips/pci/pci-ocelot.c~potential-parse-error-in-ifdef-update arch/mips/pci/pci-ocelot.c
--- a/arch/mips/pci/pci-ocelot.c~potential-parse-error-in-ifdef-update
+++ a/arch/mips/pci/pci-ocelot.c
@@ -71,19 +71,19 @@ static inline void pci0WriteConfigReg(un
 }
 
 static struct resource ocelot_mem_resource = {
-	start	= GT_PCI_MEM_BASE;
-	end	= GT_PCI_MEM_BASE + GT_PCI_MEM_BASE - 1;
+	.start	= GT_PCI_MEM_BASE,
+	.end	= GT_PCI_MEM_BASE + GT_PCI_MEM_BASE - 1,
 };
 
 static struct resource ocelot_io_resource = {
-	start	= GT_PCI_IO_BASE;
-	end	= GT_PCI_IO_BASE + GT_PCI_IO_SIZE - 1;
+	.start	= GT_PCI_IO_BASE,
+	.end	= GT_PCI_IO_BASE + GT_PCI_IO_SIZE - 1,
 };
 
 static struct pci_controller ocelot_pci_controller = {
-	.pci_ops	= gt64xxx_pci0_ops;
-	.mem_resource	= &ocelot_mem_resource;
-	.io_resource	= &ocelot_io_resource;
+	.pci_ops	= gt64xxx_pci0_ops,
+	.mem_resource	= &ocelot_mem_resource,
+	.io_resource	= &ocelot_io_resource,
 };
 
 static int __init ocelot_pcibios_init(void)
diff -puN drivers/mtd/nand/ppchameleonevb.c~potential-parse-error-in-ifdef-update drivers/mtd/nand/ppchameleonevb.c
--- a/drivers/mtd/nand/ppchameleonevb.c~potential-parse-error-in-ifdef-update
+++ a/drivers/mtd/nand/ppchameleonevb.c
@@ -424,9 +424,9 @@ static void __exit ppchameleonevb_cleanu
 
 	/* Release iomaps */
 	this = (struct nand_chip *) &ppchameleon_mtd[1];
-	iounmap((void *) this->IO_ADDR_R;
+	iounmap((void *) this->IO_ADDR_R);
 	this = (struct nand_chip *) &ppchameleonevb_mtd[1];
-	iounmap((void *) this->IO_ADDR_R;
+	iounmap((void *) this->IO_ADDR_R);
 
 	/* Free the MTD device structure */
 	kfree (ppchameleon_mtd);
diff -puN drivers/net/fec_8xx/fec_main.c~potential-parse-error-in-ifdef-update drivers/net/fec_8xx/fec_main.c
--- a/drivers/net/fec_8xx/fec_main.c~potential-parse-error-in-ifdef-update
+++ a/drivers/net/fec_8xx/fec_main.c
@@ -550,7 +550,7 @@ static int fec_enet_rx_common(struct net
 				skbn = dev_alloc_skb(pkt_len + 2);
 				if (skbn != NULL) {
 					skb_reserve(skbn, 2);	/* align IP header */
-					skb_copy_from_linear_data(skb
+					skb_copy_from_linear_data(skb,
 								  skbn->data,
 								  pkt_len);
 					/* swap */
diff -puN drivers/scsi/NCR5380.c~potential-parse-error-in-ifdef-update drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~potential-parse-error-in-ifdef-update
+++ a/drivers/scsi/NCR5380.c
@@ -2627,7 +2627,7 @@ static void NCR5380_reselect(struct Scsi
 #ifdef REAL_DMA
 static void NCR5380_dma_complete(NCR5380_instance * instance) {
 	NCR5380_local_declare();
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata * instance->hostdata);
+	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int transferred;
 	NCR5380_setup(instance);
 
diff -puN fs/udf/super.c~potential-parse-error-in-ifdef-update fs/udf/super.c
--- a/fs/udf/super.c~potential-parse-error-in-ifdef-update
+++ a/fs/udf/super.c
@@ -1352,7 +1352,7 @@ udf_load_partition(struct super_block *s
 
 	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
 	{
-		switch UDF_SB_PARTTYPE(sb, i)
+		switch (UDF_SB_PARTTYPE(sb, i))
 		{
 			case UDF_VIRTUAL_MAP15:
 			case UDF_VIRTUAL_MAP20:
_

Patches currently in -mm which might be from padator@wanadoo.fr are

atari_pamsnetc-old-declaration-ritchie-style-fix.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-update.patch
