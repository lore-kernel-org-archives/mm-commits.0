From: akpm@linux-foundation.org
Subject: + drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch added to -mm tree
Date: Thu, 30 Jul 2009 13:43:50 -0700
Message-ID: <200907302043.n6UKhoLJ021943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbZG3UoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgayda2@uiuc.edu, johnpol@2ka.mipt.ru


The patch titled
     drivers/w1/masters/omap_hdq.c: fix missing mutex unlock
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-w1-masters-omap_hdqc-fix-missing-mutex-unlock.patch
linux-next.patch

