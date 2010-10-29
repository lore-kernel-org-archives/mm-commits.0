From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch added to -mm tree
Date: Fri, 29 Oct 2010 12:25:43 -0700
Message-ID: <201010291925.o9TJPhsq012629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab0J2T0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 15:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, rpurdie@rpsys.net, sfr@canb.auug.org.au, vapier@gentoo.org


The patch titled
     drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch

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
Subject: drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value
From: Michael Hennerich <michael.hennerich@analog.com>

Handle return value, strict_strtoul is declared with attribute
warn_unused_result.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -502,8 +502,10 @@ static ssize_t adp8860_bl_l1_daylight_ma
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct adp8860_bl *data = dev_get_drvdata(dev);
+	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	if (ret)
+		return ret;
 
-	strict_strtoul(buf, 10, &data->cached_daylight_max);
 	return adp8860_store(dev, buf, count, ADP8860_BLMX1);
 }
 static DEVICE_ATTR(l1_daylight_max, 0664, adp8860_bl_l1_daylight_max_show,
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch

