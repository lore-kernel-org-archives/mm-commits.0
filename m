From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch added to -mm tree
Date: Wed, 09 Jan 2013 13:20:12 -0800
Message-ID: <20130109212013.3A04F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:51060 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3AIVUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 16:20:16 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so80832wib.4
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 13:20:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, liangs@marvell.com


The patch titled
     Subject: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix

The "fix set time sync time issue" adds calls to udelay(), but
doesn't add the include file. End result is build breakage:

drivers/rtc/rtc-pxa.c: In function 'pxa_rtc_set_time':
drivers/rtc/rtc-pxa.c:267:2: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Leo Song <liangs@marvell.com>
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
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch

