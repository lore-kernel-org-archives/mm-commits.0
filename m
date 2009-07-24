From: akpm@linux-foundation.org
Subject: + mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch added to -mm tree
Date: Thu, 23 Jul 2009 17:20:29 -0700
Message-ID: <200907240020.n6O0KTxW008036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbZGXAVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 20:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, manuel.lauss@googlemail.com, ralf@linux-mips.org


The patch titled
     mips: decrease size of au1xxx_dbdma_pm_regs[][]
has been added to the -mm tree.  Its filename is
     mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

