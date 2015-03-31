From: akpm@linux-foundation.org
Subject: + rtc-__rtc_read_time-reduce-log-level.patch added to -mm tree
Date: Tue, 31 Mar 2015 16:32:38 -0700
Message-ID: <551b2e96.HdIjutUtwyIRGI9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbbCaXcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 19:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: __rtc_read_time: reduce log level
has been added to the -mm tree.  Its filename is
     rtc-__rtc_read_time-reduce-log-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-__rtc_read_time-reduce-log-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-__rtc_read_time-reduce-log-level.patch

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
Subject: drivers/rtc/interface.c: __rtc_read_time: reduce log level

__rtc_read_time logs should be debug logs instead of error logs.

For example, when the RTC clock is not set, it's not really useful
to print a kernel error log every time someone tries to read the clock:

	~ # hwclock -r
	[  604.508263] rtc rtc0: read_time: fail to read
	hwclock: RTC_RD_TIME: Invalid argument

If there's a real error, it's likely that lower level or higher level
code will tell it anyway. Make these logs debug logs, and also print
the error code for the read failure.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-__rtc_read_time-reduce-log-level drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-__rtc_read_time-reduce-log-level
+++ a/drivers/rtc/interface.c
@@ -31,13 +31,14 @@ static int __rtc_read_time(struct rtc_de
 		memset(tm, 0, sizeof(struct rtc_time));
 		err = rtc->ops->read_time(rtc->dev.parent, tm);
 		if (err < 0) {
-			dev_err(&rtc->dev, "read_time: fail to read\n");
+			dev_dbg(&rtc->dev, "read_time: fail to read: %d\n",
+				err);
 			return err;
 		}
 
 		err = rtc_valid_tm(tm);
 		if (err < 0)
-			dev_err(&rtc->dev, "read_time: rtc_time isn't valid\n");
+			dev_dbg(&rtc->dev, "read_time: rtc_time isn't valid\n");
 	}
 	return err;
 }
_

Patches currently in -mm which might be from aaro.koskinen@iki.fi are

rtc-initialize-rtc-name-early.patch
rtc-__rtc_read_time-reduce-log-level.patch
rtc-hctosys-use-function-name-in-the-error-log.patch
linux-next.patch

