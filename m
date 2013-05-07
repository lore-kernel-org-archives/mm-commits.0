From: akpm@linux-foundation.org
Subject: [merged] aoe-replace-kmalloc-and-then-memcpy-with-kmemdup.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:12 -0700
Message-ID: <20130507175012.79C3131C448@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:40568 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3EGRuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:13 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so86268qcz.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mihneadb@gmail.com, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: replace kmalloc and then memcpy with kmemdup
has been removed from the -mm tree.  Its filename was
     aoe-replace-kmalloc-and-then-memcpy-with-kmemdup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

