From: akpm@linux-foundation.org
Subject: + isdn-misdn-dont-compile-unused-stuff.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:18:55 -0800
Message-ID: <201002012018.o11KItX8009994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0BAUTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:19:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, isdn@linux-pingi.de


The patch titled
     isdn: mISDN, don't compile unused stuff
has been added to the -mm tree.  Its filename is
     isdn-misdn-dont-compile-unused-stuff.patch

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
isdn-misdn-dont-compile-unused-stuff.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

