From: akpm@linux-foundation.org
Subject: [merged] char-mxser-fix-isa-board-lookup.patch removed from -mm tree
Date: Tue, 16 Jun 2009 12:31:08 -0700
Message-ID: <200906161931.n5GJV8ol021240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbZFPTcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 15:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterb@goldcircle.co.za, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     char: mxser, fix ISA board lookup
has been removed from the -mm tree.  Its filename was
     char-mxser-fix-isa-board-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: mxser, fix ISA board lookup
From: "Peter Botha" <peterb@goldcircle.co.za>

There's a bug in the mxser kernel module that still appears in the
2.6.29.4 kernel.

mxser_get_ISA_conf takes a ioaddress as its first argument, by passing the
not of the ioaddr, you're effectively passing 0 which means it won't be
able to talk to an ISA card.  I have tested this, and removing the ! 
fixes the problem.

Cc: "Peter Botha" <peterb@goldcircle.co.za>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~char-mxser-fix-isa-board-lookup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-fix-isa-board-lookup
+++ a/drivers/char/mxser.c
@@ -2711,7 +2711,7 @@ static int __init mxser_module_init(void
 			continue;
 
 		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		retval = mxser_get_ISA_conf(ioaddr[b], brd);
 		if (retval <= 0) {
 			brd->info = NULL;
 			continue;
_

Patches currently in -mm which might be from peterb@goldcircle.co.za are


