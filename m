From: akpm@linux-foundation.org
Subject: + aoe-cleanup-remove-unused-ata_scnt-function.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:46 -0700
Message-ID: <20121017221047.1C6E11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49039 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so1005723yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: cleanup: remove unused ata_scnt function
has been added to the -mm tree.  Its filename is
     aoe-cleanup-remove-unused-ata_scnt-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
