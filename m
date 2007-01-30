From: akpm@osdl.org
Subject: - ehea-fixed-missing-tasklet_kill-call.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:49 -0800
Message-ID: <200701302147.l0ULlnZM030216@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXA3Vrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osstklei@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehea: Fixed missing tasklet_kill() call
has been removed from the -mm tree.  Its filename was
     ehea-fixed-missing-tasklet_kill-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
