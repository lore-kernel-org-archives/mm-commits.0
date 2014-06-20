From: akpm@linux-foundation.org
Subject: + rtc-add-hardware-dependency-to-rtc-moxart.patch added to -mm
 tree
Date: Fri, 20 Jun 2014 15:48:38 -0700
Message-ID: <53a4ba46.5pZe7+DivqQuv6/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbaFTWsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jonas.jensen@gmail.com, a.zummo@towertech.it, jdelvare@suse.de


The patch titled
     Subject: drivers/rtc/Kconfig: add hardware dependency to rtc-moxart
has been added to the -mm tree.  Its filename is
     rtc-add-hardware-dependency-to-rtc-moxart.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-hardware-dependency-to-rtc-moxart.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-hardware-dependency-to-rtc-moxart.patch

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

maintainers-update-ibm-serveraid-raid-info.patch
rtc-move-ds2404-entry-where-it-belongs.patch
rtc-add-hardware-dependency-to-rtc-moxart.patch
linux-next.patch

