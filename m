From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-unused-variables.patch added to -mm tree
Date: Thu, 23 Apr 2009 14:32:30 -0700
Message-ID: <200904232132.n3NLWUlv025632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbZDWVfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 17:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl


The patch titled
     char: cyclades, remove unused variables
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-unused-variables.patch

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
char-cyclades-plx9060-casts-cleanup.patch
char-cyclades-cache-hw-version.patch
char-cyclades-convert-macros-to-inlines.patch
char-cyclades-remove-typedefs.patch
char-cyclades-fix-nports-handling.patch
char-cyclades-remove-unused-variables.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

