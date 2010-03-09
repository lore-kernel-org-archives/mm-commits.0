From: akpm@linux-foundation.org
Subject: [merged] rtc-core-fix-memory-leak.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:35 -0800
Message-ID: <201003091910.o29JAZ6D031602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab0CITWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@nokia.com, a.zummo@towertech.it, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc-core: fix memory leak
has been removed from the -mm tree.  Its filename was
     rtc-core-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-core: fix memory leak
From: Aaro Koskinen <aaro.koskinen@nokia.com>

The idr should be destroyed when the module is unloaded. Found with
kmemleak.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/class.c~rtc-core-fix-memory-leak drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-core-fix-memory-leak
+++ a/drivers/rtc/class.c
@@ -226,6 +226,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
+	idr_destroy(&rtc_idr);
 }
 
 subsys_initcall(rtc_init);
_

Patches currently in -mm which might be from aaro.koskinen@nokia.com are

linux-next.patch

