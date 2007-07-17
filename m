From: akpm@linux-foundation.org
Subject: - char-cyclades-fix-sparse-warning.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:13 -0700
Message-ID: <200707172306.l6HN6DcD011994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762558AbXGQXPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix sparse warning
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, fix sparse warning
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, fix sparse warning

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-sparse-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-sparse-warning
+++ a/drivers/char/cyclades.c
@@ -1890,11 +1890,11 @@ static void cyz_poll(unsigned long arg)
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	static struct FIRM_ID *firm_id;
-	static struct ZFW_CTRL *zfw_ctrl;
-	static struct BOARD_CTRL *board_ctrl;
-	static struct CH_CTRL *ch_ctrl;
-	static struct BUF_CTRL *buf_ctrl;
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
+	struct BUF_CTRL __iomem *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
 	int card, port;
 
@@ -2038,7 +2038,6 @@ static int startup(struct cyclades_port 
 		struct ZFW_CTRL __iomem *zfw_ctrl;
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		int retval;
 
 		base_addr = card->base_addr;
 
@@ -2410,7 +2409,6 @@ block_til_ready(struct tty_struct *tty, 
 		struct ZFW_CTRL __iomem *zfw_ctrl;
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		int retval;
 
 		base_addr = cinfo->base_addr;
 		firm_id = base_addr + ID_ADDRESS;
@@ -4902,7 +4900,7 @@ static int __devinit cyz_load_fw(struct 
 	struct FIRM_ID __iomem *fid = base_addr + ID_ADDRESS;
 	struct CUSTOM_REG __iomem *cust = base_addr;
 	struct ZFW_CTRL __iomem *pt_zfwctrl;
-	u8 *tmp;
+	void __iomem *tmp;
 	u32 mailbox, status;
 	unsigned int i;
 	int retval;
@@ -4964,13 +4962,13 @@ static int __devinit cyz_load_fw(struct 
 	udelay(100);
 
 	/* clear memory */
-	for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+	for (tmp = base_addr; tmp < base_addr + RAM_SIZE; tmp++)
 		cy_writeb(tmp, 255);
 	if (mailbox != 0) {
 		/* set window to last 512K of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM + RAM_SIZE);
 		//sleep(1);
-		for (tmp = base_addr; (void *)tmp < base_addr + RAM_SIZE; tmp++)
+		for (tmp = base_addr; tmp < base_addr + RAM_SIZE; tmp++)
 			cy_writeb(tmp, 255);
 		/* set window to beginning of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
