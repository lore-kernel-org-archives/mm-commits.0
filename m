From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch removed from -mm tree
Date: Thu, 09 May 2013 13:28:33 -0700
Message-ID: <20130509202833.866EF5A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:51019 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3EIU2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:28:34 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so330930ggl.0
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:28:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, liangs@marvell.com, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix

The "fix set time sync time issue" adds calls to udelay(), but
doesn't add the include file. End result is build breakage:

drivers/rtc/rtc-pxa.c: In function 'pxa_rtc_set_time':
drivers/rtc/rtc-pxa.c:267:2: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Leo Song <liangs@marvell.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
+++ a/drivers/rtc/rtc-pxa.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
linux-next.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch

