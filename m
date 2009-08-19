From: akpm@linux-foundation.org
Subject: + nftl-write-support-is-broken.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:53:20 -0700
Message-ID: <200908192153.n7JLrKqS023165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbZHSVxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dimitri.gorokhovik@free.fr, dwmw2@infradead.org, scott@canonical.com, tim.gardner@canonical.com


The patch titled
     nftl: write support is broken
has been added to the -mm tree.  Its filename is
     nftl-write-support-is-broken.patch

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
Subject: nftl: write support is broken
From: dimitri.gorokhovik@free.fr

Write support is broken in NFTL. Fix it.

Signed-off-by: <dimitri.gorokhovik@free.fr>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Scott James Remnant <scott@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nftlcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nftlcore.c~nftl-write-support-is-broken drivers/mtd/nftlcore.c
--- a/drivers/mtd/nftlcore.c~nftl-write-support-is-broken
+++ a/drivers/mtd/nftlcore.c
@@ -181,7 +181,7 @@ static int nftl_write(struct mtd_info *m
 	int res;
 
 	ops.mode = MTD_OOB_PLACE;
-	ops.ooboffs = offs;
+	ops.ooboffs = offs & (mtd->writesize - 1);
 	ops.ooblen = mtd->oobsize;
 	ops.oobbuf = oob;
 	ops.datbuf = buf;
_

Patches currently in -mm which might be from dimitri.gorokhovik@free.fr are

nftl-write-support-is-broken.patch

