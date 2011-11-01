From: akpm@linux-foundation.org
Subject: [merged] driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:58 -0700
Message-ID: <201111012113.pA1LDw77019645@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhbird.choi@samsung.com, dg77.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: driver/misc/fsa9480.c fix potential null-pointer dereference
has been removed from the -mm tree.  Its filename was
     driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonghwan Choi <jhbird.choi@samsung.com>
Subject: driver/misc/fsa9480.c fix potential null-pointer dereference

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fsa9480.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/fsa9480.c~driver-misc-fsa9480c-fix-potential-null-pointer-dereference drivers/misc/fsa9480.c
--- a/drivers/misc/fsa9480.c~driver-misc-fsa9480c-fix-potential-null-pointer-dereference
+++ a/drivers/misc/fsa9480.c
@@ -400,7 +400,8 @@ static int fsa9480_irq_init(struct fsa94
 			return ret;
 		}
 
-		device_init_wakeup(&client->dev, pdata->wakeup);
+		if (pdata)
+			device_init_wakeup(&client->dev, pdata->wakeup);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

origin.patch
linux-next.patch

