From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:04 -0700
Message-ID: <200908101927.n7AJR4ZV025187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbZHJT1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgayda2@uiuc.edu, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/w1/masters/omap_hdq.c: fix missing mutex unlock
has been removed from the -mm tree.  Its filename was
     drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/w1/masters/omap_hdq.c: fix missing mutex unlock
From: Stoyan Gaydarov <sgayda2@uiuc.edu>

This was found using a semantic patch, more info can be found at:
http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/masters/omap_hdq.c~drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock
+++ a/drivers/w1/masters/omap_hdq.c
@@ -687,6 +687,7 @@ static int omap_hdq_remove(struct platfo
 
 	if (hdq_data->hdq_usecount) {
 		dev_dbg(&pdev->dev, "removed when use count is not zero\n");
+		mutex_unlock(&hdq_data->hdq_mutex);
 		return -EBUSY;
 	}
 
_

Patches currently in -mm which might be from sgayda2@uiuc.edu are

origin.patch
linux-next.patch

