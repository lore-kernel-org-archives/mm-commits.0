From: akpm@linux-foundation.org
Subject: [merged] aoe-cleanup-remove-unused-ata_scnt-function.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:55 -0800
Message-ID: <20121218200956.1670E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:48139 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:58 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so63565lag.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: cleanup: remove unused ata_scnt function
has been removed from the -mm tree.  Its filename was
     aoe-cleanup-remove-unused-ata_scnt-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: cleanup: remove unused ata_scnt function

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-cleanup-remove-unused-ata_scnt-function drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-cleanup-remove-unused-ata_scnt-function
+++ a/drivers/block/aoe/aoecmd.c
@@ -552,16 +552,6 @@ sthtith(struct aoedev *d)
 	return 1;
 }
 
-static inline unsigned char
-ata_scnt(unsigned char *packet) {
-	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
-
-	h = (struct aoe_hdr *) packet;
-	ah = (struct aoe_atahdr *) (h+1);
-	return ah->scnt;
-}
