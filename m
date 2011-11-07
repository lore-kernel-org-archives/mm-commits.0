From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-potential-null-deref-in-rio_setup_device.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:38 -0800
Message-ID: <201111072028.pA7KSc48005127@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, error27@gmail.com, galak@kernel.crashing.org, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: RapidIO: fix potential null deref in rio_setup_device()
has been removed from the -mm tree.  Its filename was
     rapidio-fix-potential-null-deref-in-rio_setup_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: RapidIO: fix potential null deref in rio_setup_device()

The "goto cleanup" path can deference "rswitch" when it is NULL.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Chul Kim <chul.kim@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-in-rio_setup_device drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-in-rio_setup_device
+++ a/drivers/rapidio/rio-scan.c
@@ -516,7 +516,7 @@ static struct rio_dev __devinit *rio_set
 	return rdev;
 
 cleanup:
-	if (rio_is_switch(rdev))
+	if (rswitch)
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

