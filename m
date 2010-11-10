From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-omapc-fix-a-memory-leak.patch added to -mm tree
Date: Wed, 10 Nov 2010 12:54:33 -0800
Message-ID: <201011102054.oAAKsXRZ005369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab0KJUy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 15:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, khilman@deeprootsystems.com, nsekhar@ti.com, tony@atomide.com


The patch titled
     drivers/rtc/rtc-omap.c: fix a memory leak
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

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

linux-next.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
backlight-s6e63m0-fix-section-mismatch.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

