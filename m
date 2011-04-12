From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch added to -mm tree
Date: Tue, 12 Apr 2011 15:00:21 -0700
Message-ID: <201104122200.p3CM0L3b005278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932322Ab1DLWAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 18:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tailai.ly@taobao.com, lethal@linux-sh.org, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/adp5520_bl.c: check strict_strtoul() return value
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch

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
Subject: drivers/video/backlight/adp5520_bl.c: check strict_strtoul() return value
From: Liu Yuan <tailai.ly@taobao.com>

It should check if strict_strtoul() succeeds.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -212,7 +212,9 @@ static ssize_t adp5520_bl_daylight_max_s
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
 
-	strict_strtoul(buf, 10, &data->cached_daylight_max);
+	if (strict_strtoul(buf, 10, &data->cached_daylight_max) < 0)
+		return -EINVAL;
+
 	return adp5520_store(dev, buf, count, ADP5520_DAYLIGHT_MAX);
 }
 static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
_

Patches currently in -mm which might be from tailai.ly@taobao.com are

drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch

