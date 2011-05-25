From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch removed from -mm tree
Date: Wed, 25 May 2011 13:26:59 -0700
Message-ID: <201105252025.p4PKPMN0014389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab1EYU0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tailai.ly@taobao.com, lethal@linux-sh.org, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/adp5520_bl.c: check strict_strtoul() return value
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/adp5520_bl.c: check strict_strtoul() return value
From: Liu Yuan <tailai.ly@taobao.com>

It should check if strict_strtoul() succeeds.

[akpm@linux-foundation.org: don't override strict_strtoul() return value]
Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -211,8 +211,12 @@ static ssize_t adp5520_bl_daylight_max_s
 			const char *buf, size_t count)
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	if (ret < 0)
+		return ret;
 
-	strict_strtoul(buf, 10, &data->cached_daylight_max);
 	return adp5520_store(dev, buf, count, ADP5520_DAYLIGHT_MAX);
 }
 static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
_

Patches currently in -mm which might be from tailai.ly@taobao.com are

origin.patch
linux-next.patch

