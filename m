From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-omapc-fix-a-memory-leak.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:18 -0800
Message-ID: <201101132009.p0DK9xC3029998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933683Ab1AMUKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, khilman@deeprootsystems.com, mgreer@mvista.com, nsekhar@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-omap.c: fix a memory leak
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-omap.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

request_mem_region() will call kzalloc to allocate memory for struct
resource.  release_resource() unregisters the resource but does not free
the allocated memory, thus use release_mem_region() instead to fix the
memory leak.

Also add a missing iounmap() in omap_rtc_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Tony Lindgren <tony@atomide.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-memory-leak drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-memory-leak
+++ a/drivers/rtc/rtc-omap.c
@@ -429,13 +429,14 @@ fail1:
 fail0:
 	iounmap(rtc_base);
 fail:
-	release_resource(mem);
+	release_mem_region(mem->start, resource_size(mem));
 	return -EIO;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device	*rtc = platform_get_drvdata(pdev);
+	struct resource		*mem = dev_get_drvdata(&rtc->dev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
@@ -447,8 +448,9 @@ static int __exit omap_rtc_remove(struct
 	if (omap_rtc_timer != omap_rtc_alarm)
 		free_irq(omap_rtc_alarm, rtc);
 
-	release_resource(dev_get_drvdata(&rtc->dev));
 	rtc_device_unregister(rtc);
+	iounmap(rtc_base);
+	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

