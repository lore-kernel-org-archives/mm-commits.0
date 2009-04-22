From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-dont-kill-fw.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:34 -0700
Message-ID: <200904221831.n3MIVYv4006844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbZDVSeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, don't kill FW
has been removed from the -mm tree.  Its filename was
     char-cyclades-dont-kill-fw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, don't kill FW
From: Jiri Slaby <jirislaby@gmail.com>

Don't reset the PLX chip after FW load, which effectively kills the FW, so
that user had to boot manually.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-dont-kill-fw drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-dont-kill-fw
+++ a/drivers/char/cyclades.c
@@ -4932,8 +4932,6 @@ static int __devinit cyz_load_fw(struct 
 	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) |
 			0x00030800UL);
 
-	plx_init(pdev, irq, ctl_addr);
