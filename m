From: akpm@osdl.org
Subject: + ehea-fixed-missing-tasklet_kill-call.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:10:55 -0800
Message-ID: <200701300110.l0U1AtCk005118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbXA3BLB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: Fixed missing tasklet_kill() call
has been added to the -mm tree.  Its filename is
     ehea-fixed-missing-tasklet_kill-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehea: Fixed missing tasklet_kill() call
From: Thomas Klein <osstklei@de.ibm.com>

NEQ-Tasklet wasn't killed when module is removed.

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ehea/ehea_main.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/ehea/ehea_main.c~ehea-fixed-missing-tasklet_kill-call drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fixed-missing-tasklet_kill-call
+++ a/drivers/net/ehea/ehea_main.c
@@ -2598,6 +2598,7 @@ static int __devexit ehea_remove(struct 
 	destroy_workqueue(adapter->ehea_wq);
 
 	ibmebus_free_irq(NULL, adapter->neq->attr.ist1, adapter);
+	tasklet_kill(&adapter->neq_tasklet);
 
 	ehea_destroy_eq(adapter->neq);
 
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fixed-wrong-jumbo-frames-status-query.patch
ehea-fixed-missing-tasklet_kill-call.patch
