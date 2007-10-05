From: akpm@linux-foundation.org
Subject: - git-net-fix-a-compile-problem-in-macbc.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:23 -0700
Message-ID: <200710051957.l95JvNqG022461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763192AbXJEUBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjk@linutronix.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     git-net: fix a compile problem in macb.c
has been removed from the -mm tree.  Its filename was
     git-net-fix-a-compile-problem-in-macbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
pxafb-add-support-for-other-palette-formats.patch
