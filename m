From: akpm@linux-foundation.org
Subject: [merged] rtc-add-hardware-dependency-to-rtc-moxart.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:36 -0700
Message-ID: <53ea6d3c.nyRcSSLgLJNmkvKh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:43376 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaHLTig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:36 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2670240pab.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, a.zummo@towertech.it, jonas.jensen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/Kconfig: add hardware dependency to rtc-moxart
has been removed from the -mm tree.  Its filename was
     rtc-add-hardware-dependency-to-rtc-moxart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: drivers/rtc/Kconfig: add hardware dependency to rtc-moxart

The rtc-moxart driver is only useful on MOXA ART systems so it should
depend on ARCH_MOXART as all other MOXA ART drivers already do.  Add
COMPILE_TEST as an alternative to allow for build testing on other
systems.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~rtc-add-hardware-dependency-to-rtc-moxart drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-hardware-dependency-to-rtc-moxart
+++ a/drivers/rtc/Kconfig
@@ -1349,6 +1349,7 @@ config RTC_DRV_SIRFSOC
 
 config RTC_DRV_MOXART
 	tristate "MOXA ART RTC"
+	depends on ARCH_MOXART || COMPILE_TEST
 	help
 	   If you say yes here you get support for the MOXA ART
 	   RTC module.
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch

