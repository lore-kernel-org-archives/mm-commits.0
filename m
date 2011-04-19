From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure.patch removed from -mm tree
Date: Tue, 19 Apr 2011 10:59:21 -0700
Message-ID: <201104191755.p3JHtOtg014106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1DSR42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 13:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-omap.c: fix a leak of the IRQ during init failure
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-omap.c: fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>

In omap_rtc_probe error path, free_irq() was using NULL rather than the
driver data as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure
+++ a/drivers/rtc/rtc-omap.c
@@ -394,7 +394,7 @@ static int __init omap_rtc_probe(struct 
 	return 0;
 
 fail2:
-	free_irq(omap_rtc_timer, NULL);
+	free_irq(omap_rtc_timer, rtc);
 fail1:
 	rtc_device_unregister(rtc);
 fail0:
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

