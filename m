From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time.patch added to -mm tree
Date: Tue, 14 Oct 2014 15:21:04 -0700
Message-ID: <543da1d0.YT/c9iVQoHZaCgzs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaJNWVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 18:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ciogenis@gmail.com, a.zummo@towertech.it, hyogi.gim@lge.com, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: check the validation of rtc_time in __rtc_read_time
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyogi Gim <ciogenis@gmail.com>
Subject: drivers/rtc/interface.c: check the validation of rtc_time in __rtc_read_time

Some rtc devices always return '0' when rtc_class_ops.read_time is called.
So if rtc_time isn't verified in callback, rtc interface cannot know
whether rtc_time is valid.

Check rtc_time by using 'rtc_valid_tm' in '__rtc_read_time'.  And add the
message for debugging.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time
+++ a/drivers/rtc/interface.c
@@ -30,6 +30,14 @@ static int __rtc_read_time(struct rtc_de
 	else {
 		memset(tm, 0, sizeof(struct rtc_time));
 		err = rtc->ops->read_time(rtc->dev.parent, tm);
+		if (err < 0) {
+			dev_err(&rtc->dev, "read_time: fail to read\n");
+			return err;
+		}
+
+		err = rtc_valid_tm(tm);
+		if (err < 0)
+			dev_err(&rtc->dev, "read_time: rtc_time isn't valid\n");
 	}
 	return err;
 }
_

Patches currently in -mm which might be from ciogenis@gmail.com are

drivers-rtc-interfacec-check-the-validation-of-rtc_time-in-__rtc_read_time.patch

