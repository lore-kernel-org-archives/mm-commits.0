From: akpm@linux-foundation.org
Subject: + rtc-hctosys-use-function-name-in-the-error-log.patch added to
 -mm tree
Date: Tue, 31 Mar 2015 16:32:40 -0700
Message-ID: <551b2e98.lAhDb4j+BkOs3cO9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbCaXcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 19:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: hctosys: use function name in the error log
has been added to the -mm tree.  Its filename is
     rtc-hctosys-use-function-name-in-the-error-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-hctosys-use-function-name-in-the-error-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-hctosys-use-function-name-in-the-error-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: rtc: hctosys: use function name in the error log

Use function name in the error log instead of __FILE__.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/hctosys.c~rtc-hctosys-use-function-name-in-the-error-log drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-hctosys-use-function-name-in-the-error-log
+++ a/drivers/rtc/hctosys.c
@@ -33,7 +33,7 @@ static int __init rtc_hctosys(void)
 
 	if (rtc == NULL) {
 		pr_info("%s: unable to open rtc device (%s)\n",
-			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
+			__func__, CONFIG_RTC_HCTOSYS_DEVICE);
 		goto err_open;
 	}
 
_

Patches currently in -mm which might be from aaro.koskinen@iki.fi are

rtc-initialize-rtc-name-early.patch
rtc-__rtc_read_time-reduce-log-level.patch
rtc-hctosys-use-function-name-in-the-error-log.patch
linux-next.patch

