From: akpm@linux-foundation.org
Subject: + paride-pgc-xs-confusion.patch added to -mm tree
Date: Mon, 12 Jan 2009 13:41:47 -0800
Message-ID: <200901122141.n0CLflol019497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbZALVmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 16:42:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, bzolnier@gmail.com, jens.axboe@oracle.com


The patch titled
     paride/pg.c: xs(): &&/|| confusion
has been added to the -mm tree.  Its filename is
     paride-pgc-xs-confusion.patch

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
Subject: paride/pg.c: xs(): &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

&&/|| confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/paride/pg.c~paride-pgc-xs-confusion drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c~paride-pgc-xs-confusion
+++ a/drivers/block/paride/pg.c
@@ -422,7 +422,7 @@ static void xs(char *buf, char *targ, in
 
 	for (k = 0; k < len; k++) {
 		char c = *buf++;
-		if (c != ' ' || c != l)
+		if (c != ' ' && c != l)
 			l = *targ++ = c;
 	}
 	if (l == ' ')
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
paride-pgc-xs-confusion.patch
ufs-sector_t-cannot-be-negative.patch

