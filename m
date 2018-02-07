From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?rapidio-delete-an-error-message-for-a-failed-memory-allocat?=
 =?US-ASCII?Q?ion-in-rio=5Finit=5Fmports.patch?= removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:17 -0800
Message-ID: <20180207195817.jHuIwHvOo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754397AbeBGT6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: delete an error message for a failed memory allocation in rio_init_mports()
has been removed from the -mm tree.  Its filename was
     rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: delete an error message for a failed memory allocation in rio_init_mports()

Patch series "RapidIO: Adjustments for some function implementations".

This patch (of 7):

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/dfd6887b-2521-cbf2-af5b-e70b5fa4c33c@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports
+++ a/drivers/rapidio/rio.c
@@ -2189,7 +2189,6 @@ int rio_init_mports(void)
 
 	work = kcalloc(n, sizeof *work, GFP_KERNEL);
 	if (!work) {
-		pr_err("RIO: no memory for work struct\n");
 		destroy_workqueue(rio_wq);
 		goto no_disc;
 	}
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


