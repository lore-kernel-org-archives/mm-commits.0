From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-volatiles.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:35 -0700
Message-ID: <200705090256.l492uZtF010073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032571AbXEIC4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove volatiles
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-volatiles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove volatiles
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, remove volatiles

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   52 ++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-volatiles drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-volatiles
+++ a/drivers/char/cyclades.c
@@ -967,7 +967,7 @@ do_softint(struct work_struct *work)
  */
 static int cyy_issue_cmd(void __iomem * base_addr, u_char cmd, int index)
 {
-	volatile int i;
+	unsigned int i;
 
 	/* Check to see that the previous command has completed */
 	for (i = 0; i < 100; i++) {
@@ -1043,7 +1043,7 @@ static void cyy_intr_chip(struct cyclade
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	volatile int char_count;
+	int char_count;
 	int i, j, len, mdm_change, mdm_status, outch;
 	int save_xir, channel, save_car;
 	char data;
@@ -1551,20 +1551,19 @@ cyz_issue_cmd(struct cyclades_card *cinf
 }				/* cyz_issue_cmd */
 
 static void
-cyz_handle_rx(struct cyclades_port *info,
-		volatile struct CH_CTRL __iomem * ch_ctrl,
-		volatile struct BUF_CTRL __iomem * buf_ctrl)
+cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = &cy_card[info->card];
 	struct tty_struct *tty = info->tty;
-	volatile int char_count;
+	int char_count;
 	int len;
 #ifdef BLOCKMOVE
 	int small_count;
 #else
 	char data;
 #endif
-	volatile __u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+	__u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
 
 	rx_get = new_rx_get = readl(&buf_ctrl->rx_get);
 	rx_put = readl(&buf_ctrl->rx_put);
@@ -1648,18 +1647,17 @@ cyz_handle_rx(struct cyclades_port *info
 }
 
 static void
-cyz_handle_tx(struct cyclades_port *info,
-		volatile struct CH_CTRL __iomem * ch_ctrl,
-		volatile struct BUF_CTRL __iomem * buf_ctrl)
+cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = &cy_card[info->card];
 	struct tty_struct *tty = info->tty;
 	char data;
-	volatile int char_count;
+	int char_count;
 #ifdef BLOCKMOVE
 	int small_count;
 #endif
-	volatile __u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
+	__u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
 
 	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
 		return;
@@ -1739,11 +1737,11 @@ static void cyz_handle_cmd(struct cyclad
 {
 	struct tty_struct *tty;
 	struct cyclades_port *info;
-	static volatile struct FIRM_ID __iomem *firm_id;
-	static volatile struct ZFW_CTRL __iomem *zfw_ctrl;
-	static volatile struct BOARD_CTRL __iomem *board_ctrl;
-	static volatile struct CH_CTRL __iomem *ch_ctrl;
-	static volatile struct BUF_CTRL __iomem *buf_ctrl;
+	static struct FIRM_ID __iomem *firm_id;
+	static struct ZFW_CTRL __iomem *zfw_ctrl;
+	static struct BOARD_CTRL __iomem *board_ctrl;
+	static struct CH_CTRL __iomem *ch_ctrl;
+	static struct BUF_CTRL __iomem *buf_ctrl;
 	__u32 channel;
 	__u8 cmd;
 	__u32 param;
@@ -1900,11 +1898,11 @@ static void cyz_poll(unsigned long arg)
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	static volatile struct FIRM_ID *firm_id;
-	static volatile struct ZFW_CTRL *zfw_ctrl;
-	static volatile struct BOARD_CTRL *board_ctrl;
-	static volatile struct CH_CTRL *ch_ctrl;
-	static volatile struct BUF_CTRL *buf_ctrl;
+	static struct FIRM_ID *firm_id;
+	static struct ZFW_CTRL *zfw_ctrl;
+	static struct BOARD_CTRL *board_ctrl;
+	static struct CH_CTRL *ch_ctrl;
+	static struct BUF_CTRL *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
 	int card, port;
 
@@ -3003,12 +3001,12 @@ static int cy_chars_in_buffer(struct tty
 		return info->xmit_cnt;
 #ifdef Z_EXT_CHARS_IN_BUFFER
 	} else {
-		static volatile struct FIRM_ID *firm_id;
-		static volatile struct ZFW_CTRL *zfw_ctrl;
-		static volatile struct CH_CTRL *ch_ctrl;
-		static volatile struct BUF_CTRL *buf_ctrl;
+		static struct FIRM_ID *firm_id;
+		static struct ZFW_CTRL *zfw_ctrl;
+		static struct CH_CTRL *ch_ctrl;
+		static struct BUF_CTRL *buf_ctrl;
 		int char_count;
-		volatile __u32 tx_put, tx_get, tx_bufsize;
+		__u32 tx_put, tx_get, tx_bufsize;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		zfw_ctrl = cy_card[card].base_addr +
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
