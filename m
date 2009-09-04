From: akpm@linux-foundation.org
Subject: [merged] nftl-write-support-is-broken.patch removed from -mm tree
Date: Fri, 04 Sep 2009 11:36:39 -0700
Message-ID: <200909041836.n84Iad2l011413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933748AbZIDSgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 14:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dimitri.gorokhovik@free.fr, dwmw2@infradead.org, scott@canonical.com, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     nftl: write support is broken
has been removed from the -mm tree.  Its filename was
     nftl-write-support-is-broken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nftl: write support is broken
From: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>

Write support is broken in NFTL. Fix it.

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
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

linux-next.patch

