From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-remove-unused-variables.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:18:13 -0700
Message-ID: <200904291918.n3TJID96030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZD2TbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, remove unused variables
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-unused-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, remove unused variables
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-unused-variables drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-unused-variables
+++ a/drivers/char/cyclades.c
@@ -2963,7 +2963,6 @@ static void set_line_char(struct cyclade
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned cflag, iflag;
-	unsigned short chip_number;
 	int baud, baud_rate = 0;
 	int i;
 
@@ -2992,7 +2991,6 @@ static void set_line_char(struct cyclade
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	chip_number = channel / 4;
 
 	if (!cy_is_Z(card)) {
 
@@ -3212,9 +3210,7 @@ static void set_line_char(struct cyclade
 	} else {
 		struct FIRM_ID __iomem *firm_id;
 		struct ZFW_CTRL __iomem *zfw_ctrl;
-		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		struct BUF_CTRL __iomem *buf_ctrl;
 		__u32 sw_flow;
 		int retval;
 
@@ -3224,9 +3220,7 @@ static void set_line_char(struct cyclade
 
 		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
-		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
-		buf_ctrl = &zfw_ctrl->buf_ctrl[channel];
 
 		/* baud rate */
 		baud = tty_get_baud_rate(info->port.tty);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

