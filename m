From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-restore-back-hard-code-wakeup-support.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:21 -0700
Message-ID: <51db1479.LC/yklRUc50oZ42D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3GHTfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, a.zummo@towertech.it, gururaja.hebbar@ti.com

Subject: [merged] rtc-omap-restore-back-hard-code-wakeup-support.patch removed from -mm tree
To: gururaja.hebbar@ti.com,a.zummo@towertech.it,khilman@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:21 -0700


The patch titled
     Subject: rtc: omap: restore back (hard-code) wakeup support
has been removed from the -mm tree.  Its filename was
     rtc-omap-restore-back-hard-code-wakeup-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
Subject: rtc: omap: restore back (hard-code) wakeup support

rtc-omap driver modules is used both by OMAP1/2, Davinci SoC platforms.

However, rtc wake support on OMAP1 is broken.  Hence the
device_init_wakeup() was removed from rtc-omap driver and moved to
platform board files that supported it (DA850/OMAP-L138).  [1]

However, recently [2] it was suggested that driver should always do a
device_init_wakeup(dev, true). Platforms that don't want/need
wakeup support can disable it from userspace via:

    echo disabled > /sys/devices/.../power/wakeup

Also, with the new DT boot-up, board file doesn't exist and hence there
is no way to have device wakeup support rtc.

The fix for above issues, is to hard code device_init_wakeup() inside
driver and let platforms that don't need this, handle it through the
sysfs power entry.

[1]
https://patchwork.kernel.org/patch/136731/

[2]
http://www.mail-archive.com/davinci-linux-open-source@linux.
davincidsp.com/msg26077.html

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-restore-back-hard-code-wakeup-support drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-restore-back-hard-code-wakeup-support
+++ a/drivers/rtc/rtc-omap.c
@@ -421,6 +421,8 @@ static int __init omap_rtc_probe(struct
 	 *    is write-only, and always reads as zero...)
 	 */
 
+	device_init_wakeup(&pdev->dev, true);
+
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
_

Patches currently in -mm which might be from gururaja.hebbar@ti.com are

origin.patch

