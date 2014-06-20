From: akpm@linux-foundation.org
Subject: + rtc-move-ds2404-entry-where-it-belongs.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:48:37 -0700
Message-ID: <53a4ba45.YF/GAmU1wrlCAv4i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbaFTWsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, svens@stackframe.org, a.zummo@towertech.it, jdelvare@suse.de


The patch titled
     Subject: drivers/rtc/Kconfig: move DS2404 entry where it belongs
has been added to the -mm tree.  Its filename is
     rtc-move-ds2404-entry-where-it-belongs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-move-ds2404-entry-where-it-belongs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-move-ds2404-entry-where-it-belongs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: drivers/rtc/Kconfig: move DS2404 entry where it belongs

Move the DS2404 entry together with the other Dallas entries, and add
Maxim so that it looks nicer (and more correct, too.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-move-ds2404-entry-where-it-belongs drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-move-ds2404-entry-where-it-belongs
+++ a/drivers/rtc/Kconfig
@@ -760,6 +760,15 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
+config RTC_DRV_DS2404
+	tristate "Maxim/Dallas DS2404"
+	help
+	  If you say yes here you get support for the
+	  Dallas DS2404 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds2404.
+
 config RTC_DRV_DA9052
 	tristate "Dialog DA9052/DA9053 RTC"
 	depends on PMIC_DA9052
@@ -873,15 +882,6 @@ config RTC_DRV_V3020
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-v3020.
 
-config RTC_DRV_DS2404
-	tristate "Dallas DS2404"
-	help
-	  If you say yes here you get support for the
-	  Dallas DS2404 RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds2404.
