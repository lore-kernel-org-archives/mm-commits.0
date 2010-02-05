From: akpm@linux-foundation.org
Subject: [merged] isdn-misdn-dont-compile-unused-stuff.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:54 -0800
Message-ID: <201002051958.o15JwsVo017908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933840Ab0BET67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     isdn: mISDN, don't compile unused stuff
has been removed from the -mm tree.  Its filename was
     isdn-misdn-dont-compile-unused-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: mISDN, don't compile unused stuff
From: Jiri Slaby <jirislaby@gmail.com>

Remove these compiler warnings:

drivers/isdn/hardware/mISDN/w6692.c:534: warning: `setvolume' defined but not used
drivers/isdn/hardware/mISDN/w6692.c:561: warning: `enable_pots' defined but not used

by moving the functions inside #if 0 ...  #endif.  And an alternative is
to remove them completely if nobody has plans to use them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/w6692.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/isdn/hardware/mISDN/w6692.c~isdn-misdn-dont-compile-unused-stuff drivers/isdn/hardware/mISDN/w6692.c
--- a/drivers/isdn/hardware/mISDN/w6692.c~isdn-misdn-dont-compile-unused-stuff
+++ a/drivers/isdn/hardware/mISDN/w6692.c
@@ -529,6 +529,7 @@ W6692_fill_Bfifo(struct w6692_ch *wch)
 	}
 }
 
+#if 0
 static int
 setvolume(struct w6692_ch *wch, int mic, struct sk_buff *skb)
 {
@@ -571,6 +572,7 @@ enable_pots(struct w6692_ch *wch)
 	WriteW6692(card, W_PCTL, card->pctl);
 	return 0;
 }
+#endif
 
 static int
 disable_pots(struct w6692_ch *wch)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
agp-amd64-fix-pci-reference-leaks.patch
reiser4.patch

