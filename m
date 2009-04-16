From: akpm@linux-foundation.org
Subject: + char-cyclades-dont-kill-fw.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:51:23 -0700
Message-ID: <200904162351.n3GNpNgU032508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757869AbZDPXxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     char: cyclades, don't kill FW
has been added to the -mm tree.  Its filename is
     char-cyclades-dont-kill-fw.patch

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
