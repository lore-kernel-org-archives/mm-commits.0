From: akpm@linux-foundation.org
Subject: + rtc-recycle-id-when-unloading-a-rtc-driver.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:32:26 -0700
Message-ID: <20120815223226.B2D99100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56805 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2HOWc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:32:27 -0400
Received: by obbwc20 with SMTP id wc20so1511540obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:32:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vpalatin@chromium.org, a.zummo@towertech.it


The patch titled
     Subject: rtc: recycle id when unloading a rtc driver
has been added to the -mm tree.  Its filename is
     rtc-recycle-id-when-unloading-a-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincent Palatin <vpalatin@chromium.org>
Subject: rtc: recycle id when unloading a rtc driver

When calling rtc_device_unregister, we are not freeing the id used by the
driver.  So when doing a unload/load cycle for a RTC driver (e.g.  rmmod
rtc_cmos && modprobe rtc_cmos), its id is incremented by one.  As a
consequence, we no longer have neither an rtc0 driver nor a
/proc/driver/rtc (as it only exists for the first driver).

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/class.c~rtc-recycle-id-when-unloading-a-rtc-driver drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-recycle-id-when-unloading-a-rtc-driver
+++ a/drivers/rtc/class.c
@@ -238,6 +238,7 @@ void rtc_device_unregister(struct rtc_de
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
+		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}
_

Patches currently in -mm which might be from vpalatin@chromium.org are

rtc-recycle-id-when-unloading-a-rtc-driver.patch

