From: akpm@linux-foundation.org
Subject: + git-net-fix-a-compile-problem-in-macbc.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:31:20 -0700
Message-ID: <200710032031.l93KVKMX007269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbXJCUbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hjk@linutronix.de, davem@davemloft.net


The patch titled
     git-net: fix a compile problem in macb.c
has been added to the -mm tree.  Its filename is
     git-net-fix-a-compile-problem-in-macbc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-net: fix a compile problem in macb.c
From: Hans J. Koch <hjk@linutronix.de>

Compiling macb.c fails because the type of parameter 2 of macb_poll()
was changed from int* to int. Furthermore, a local variable was removed
but was still used inside the function. This patch fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/macb.c~git-net-fix-a-compile-problem-in-macbc drivers/net/macb.c
--- a/drivers/net/macb.c~git-net-fix-a-compile-problem-in-macbc
+++ a/drivers/net/macb.c
@@ -492,7 +492,7 @@ static int macb_poll(struct napi_struct 
 	}
 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
-		(unsigned long)status, *budget);
+		(unsigned long)status, budget);
 
 	if (!(status & MACB_BIT(REC))) {
 		dev_warn(&bp->pdev->dev,
@@ -503,7 +503,7 @@ static int macb_poll(struct napi_struct 
 	}
 
 	work_done = macb_rx(bp, budget);
-	if (work_done < orig_budget)
+	if (work_done < budget)
 		netif_rx_complete(dev, napi);
 
 	/*
_

Patches currently in -mm which might be from hjk@linutronix.de are

git-dvb.patch
git-hwmon.patch
git-net-fix-a-compile-problem-in-macbc.patch
pxafb-add-support-for-other-palette-formats.patch
