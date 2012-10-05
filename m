From: akpm@linux-foundation.org
Subject: [merged] rtc-recycle-id-when-unloading-a-rtc-driver.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:42 -0700
Message-ID: <20121005201642.9F62C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48125 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2JEUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:43 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so236935qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vpalatin@chromium.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: recycle id when unloading a rtc driver
has been removed from the -mm tree.  Its filename was
     rtc-recycle-id-when-unloading-a-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

