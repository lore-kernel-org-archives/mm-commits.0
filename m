From: akpm@linux-foundation.org
Subject: + drivers-rtc-classc-fix-device_register-error-handling.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:22:04 -0700
Message-ID: <201009212222.o8LMM4LJ006094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503Ab0IUWWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     drivers/rtc/class.c: fix device_register() error handling
has been added to the -mm tree.  Its filename is
     drivers-rtc-classc-fix-device_register-error-handling.patch

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
Subject: drivers/rtc/class.c: fix device_register() error handling
From: Vasiliy Kulikov <segooon@gmail.com>

If device_register() fails then call put_device().  See comment to
device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/class.c~drivers-rtc-classc-fix-device_register-error-handling drivers/rtc/class.c
--- a/drivers/rtc/class.c~drivers-rtc-classc-fix-device_register-error-handling
+++ a/drivers/rtc/class.c
@@ -158,8 +158,10 @@ struct rtc_device *rtc_device_register(c
 	rtc_dev_prepare(rtc);
 
 	err = device_register(&rtc->dev);
-	if (err)
+	if (err) {
+		put_device(&rtc->dev);
 		goto exit_kfree;
+	}
 
 	rtc_dev_add_device(rtc);
 	rtc_sysfs_add_device(rtc);
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
md-check-return-code-of-read_sb_page.patch
mm-mempolicy-check-return-code-of-check_range.patch
drivers-rtc-classc-fix-device_register-error-handling.patch
memstick-core-fix-device_register-error-handling.patch

