From: akpm@linux-foundation.org
Subject: [merged] mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch removed from -mm tree
Date: Thu, 01 Oct 2009 11:44:37 -0700
Message-ID: <200910011844.n91IibaR013325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687AbZJASon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 14:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, manuel.lauss@googlemail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: decrease size of au1xxx_dbdma_pm_regs[][]
has been removed from the -mm tree.  Its filename was
     mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: decrease size of au1xxx_dbdma_pm_regs[][]
From: Roel Kluin <roel.kluin@gmail.com>

There are 16 individual channels (NUM_DBDMA_CHANS) to save/restore plus
the global ddma block config (the +1).  The last register in a channel can
be skipped since it's read-only (at offset 0x18).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/alchemy/common/dbdma.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/mips/alchemy/common/dbdma.c~mips-decrease-size-of-au1xxx_dbdma_pm_regs arch/mips/alchemy/common/dbdma.c
--- a/arch/mips/alchemy/common/dbdma.c~mips-decrease-size-of-au1xxx_dbdma_pm_regs
+++ a/arch/mips/alchemy/common/dbdma.c
@@ -175,7 +175,7 @@ static dbdev_tab_t dbdev_tab[] = {
 #define DBDEV_TAB_SIZE	ARRAY_SIZE(dbdev_tab)
 
 #ifdef CONFIG_PM
-static u32 au1xxx_dbdma_pm_regs[NUM_DBDMA_CHANS + 1][8];
+static u32 au1xxx_dbdma_pm_regs[NUM_DBDMA_CHANS + 1][6];
 #endif
 
 
@@ -993,14 +993,13 @@ void au1xxx_dbdma_suspend(void)
 	au1xxx_dbdma_pm_regs[0][3] = au_readl(addr + 0x0c);
 
 	/* save channel configurations */
-	for (i = 1, addr = DDMA_CHANNEL_BASE; i < NUM_DBDMA_CHANS; i++) {
+	for (i = 1, addr = DDMA_CHANNEL_BASE; i <= NUM_DBDMA_CHANS; i++) {
 		au1xxx_dbdma_pm_regs[i][0] = au_readl(addr + 0x00);
 		au1xxx_dbdma_pm_regs[i][1] = au_readl(addr + 0x04);
 		au1xxx_dbdma_pm_regs[i][2] = au_readl(addr + 0x08);
 		au1xxx_dbdma_pm_regs[i][3] = au_readl(addr + 0x0c);
 		au1xxx_dbdma_pm_regs[i][4] = au_readl(addr + 0x10);
 		au1xxx_dbdma_pm_regs[i][5] = au_readl(addr + 0x14);
-		au1xxx_dbdma_pm_regs[i][6] = au_readl(addr + 0x18);
 
 		/* halt channel */
 		au_writel(au1xxx_dbdma_pm_regs[i][0] & ~1, addr + 0x00);
@@ -1027,14 +1026,13 @@ void au1xxx_dbdma_resume(void)
 	au_writel(au1xxx_dbdma_pm_regs[0][3], addr + 0x0c);
 
 	/* restore channel configurations */
-	for (i = 1, addr = DDMA_CHANNEL_BASE; i < NUM_DBDMA_CHANS; i++) {
+	for (i = 1, addr = DDMA_CHANNEL_BASE; i <= NUM_DBDMA_CHANS; i++) {
 		au_writel(au1xxx_dbdma_pm_regs[i][0], addr + 0x00);
 		au_writel(au1xxx_dbdma_pm_regs[i][1], addr + 0x04);
 		au_writel(au1xxx_dbdma_pm_regs[i][2], addr + 0x08);
 		au_writel(au1xxx_dbdma_pm_regs[i][3], addr + 0x0c);
 		au_writel(au1xxx_dbdma_pm_regs[i][4], addr + 0x10);
 		au_writel(au1xxx_dbdma_pm_regs[i][5], addr + 0x14);
-		au_writel(au1xxx_dbdma_pm_regs[i][6], addr + 0x18);
 		au_sync();
 		addr += 0x100;	/* next channel base */
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
random-kmalloc-failure-ignored-in-init_std_data.patch

