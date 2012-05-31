From: akpm@linux-foundation.org
Subject: [merged] backlight-adp5520-use-kstrtoul.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:39 -0700
Message-ID: <20120531191839.55FB9A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56267 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2EaTSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:40 -0400
Received: by yhgm50 with SMTP id m50so146945yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp5520_bl.c: use kstrtoul()
has been removed from the -mm tree.  Its filename was
     backlight-adp5520-use-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/adp5520_bl.c: use kstrtoul()

The usage of strict_strtoul() is not preferred. Thus, kstrtoul
should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp5520_bl.c~backlight-adp5520-use-kstrtoul drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-adp5520-use-kstrtoul
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -160,7 +160,7 @@ static ssize_t adp5520_store(struct devi
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -214,7 +214,7 @@ static ssize_t adp5520_bl_daylight_max_s
 	struct adp5520_bl *data = dev_get_drvdata(dev);
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	ret = kstrtoul(buf, 10, &data->cached_daylight_max);
 	if (ret < 0)
 		return ret;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

