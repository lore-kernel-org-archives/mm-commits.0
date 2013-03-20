From: akpm@linux-foundation.org
Subject: + aoe-replace-kmalloc-and-then-memcpy-with-kmemdup.patch added to -mm tree
Date: Wed, 20 Mar 2013 14:17:18 -0700
Message-ID: <20130320211718.707A631C2B0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:50931 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3CTVRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 17:17:19 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so199876ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 14:17:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mihneadb@gmail.com, ecashin@coraid.com


The patch titled
     Subject: aoe: replace kmalloc and then memcpy with kmemdup
has been added to the -mm tree.  Its filename is
     aoe-replace-kmalloc-and-then-memcpy-with-kmemdup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: aoe: replace kmalloc and then memcpy with kmemdup

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoechr.c~aoe-replace-kmalloc-and-then-memcpy-with-kmemdup drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-replace-kmalloc-and-then-memcpy-with-kmemdup
+++ a/drivers/block/aoe/aoechr.c
@@ -139,13 +139,12 @@ bail:		spin_unlock_irqrestore(&emsgs_loc
 		return;
 	}
 
-	mp = kmalloc(n, GFP_ATOMIC);
+	mp = kmemdup(msg, n, GFP_ATOMIC);
 	if (mp == NULL) {
 		printk(KERN_ERR "aoe: allocation failure, len=%ld\n", n);
 		goto bail;
 	}
 
-	memcpy(mp, msg, n);
 	em->msg = mp;
 	em->flags |= EMFL_VALID;
 	em->len = n;
_

Patches currently in -mm which might be from mihneadb@gmail.com are

linux-next.patch
aoe-replace-kmalloc-and-then-memcpy-with-kmemdup.patch

