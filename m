From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch added to -mm tree
Date: Mon, 07 Jul 2014 15:28:07 -0700
Message-ID: <53bb1ef7.tIjQ21FQMXkqmqNw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:59866 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGW2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 18:28:08 -0400
Received: by mail-ie0-f201.google.com with SMTP id rl12so660014iec.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 15:28:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hyogi.gim@lge.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

