From: akpm@linux-foundation.org
Subject: + backlight-adp8870-use-kstrtoul.patch added to -mm tree
Date: Tue, 15 May 2012 13:22:51 -0700
Message-ID: <20120515202251.C5B39A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:51346 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab2EOUWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 16:22:54 -0400
Received: by bkty5 with SMTP id y5so334243bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 13:22:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/adp8870_bl.c: use kstrtoul()
has been added to the -mm tree.  Its filename is
     backlight-adp8870-use-kstrtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/adp8870_bl.c: use kstrtoul()

The usage of strict_strtoul() is not preferred. Thus, kstrtoul
should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-kstrtoul drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-kstrtoul
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -572,7 +572,7 @@ static ssize_t adp8870_store(struct devi
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -652,7 +652,7 @@ static ssize_t adp8870_bl_l1_daylight_ma
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct adp8870_bl *data = dev_get_drvdata(dev);
-	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
 	if (ret)
 		return ret;
 
@@ -794,7 +794,7 @@ static ssize_t adp8870_bl_ambient_light_
 	uint8_t reg_val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
_
Subject: Subject: drivers/video/backlight/adp8870_bl.c: use kstrtoul()

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch

