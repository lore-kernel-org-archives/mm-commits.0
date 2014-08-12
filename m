From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:42 -0700
Message-ID: <53ea6d42.mbflXHrhgtiJXr4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:38794 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaHLTim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:42 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2667005pab.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hyogi.gim@lge.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hyogi Gim <hyogi.gim@lge.com>
Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()

In __rtc_set_alarm(), the error after __rtc_read_time() is not checked.
If rtc device fail to read time, we cannot guarantee the following process.

Add the verification code for returned __rtc_read_time() error.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time
+++ a/drivers/rtc/interface.c
@@ -348,6 +348,8 @@ static int __rtc_set_alarm(struct rtc_de
 
 	/* Make sure we're not setting alarms in the past */
 	err = __rtc_read_time(rtc, &tm);
+	if (err)
+		return err;
 	rtc_tm_to_time(&tm, &now);
 	if (scheduled <= now)
 		return -ETIME;
_

Patches currently in -mm which might be from hyogi.gim@lge.com are

origin.patch

