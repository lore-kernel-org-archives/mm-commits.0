From: akpm@linux-foundation.org
Subject: + char-mxser-fix-isa-board-lookup.patch added to -mm tree
Date: Fri, 29 May 2009 12:33:59 -0700
Message-ID: <200905291934.n4TJXx2u014951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbZE2TfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 15:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterb@goldcircle.co.za, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, stable@kernel.org


The patch titled
     char: mxser, fix ISA board lookup
has been added to the -mm tree.  Its filename is
     char-mxser-fix-isa-board-lookup.patch

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
Subject: char: mxser, fix ISA board lookup
From: "Peter Botha" <peterb@goldcircle.co.za>

There's a bug in the mxser kernel module that still appears in the
2.6.29.4 kernel.

mxser_get_ISA_conf takes a ioaddress as it's first argument, by passing
the not of the ioaddr, you're effectively passing 0 which means it won't
be able to talk to an ISA card.  I have tested this, and removing the ! 
fixes the problem.

Cc: "Peter Botha" <peterb@goldcircle.co.za>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~char-mxser-fix-isa-board-lookup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-fix-isa-board-lookup
+++ a/drivers/char/mxser.c
@@ -2715,7 +2715,7 @@ static int __init mxser_module_init(void
 			continue;
 
 		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		retval = mxser_get_ISA_conf(ioaddr[b], brd);
 		if (retval <= 0) {
 			brd->info = NULL;
 			continue;
_

Patches currently in -mm which might be from peterb@goldcircle.co.za are

char-mxser-fix-isa-board-lookup.patch

