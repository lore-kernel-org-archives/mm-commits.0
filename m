From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:31:07 -0800
Message-ID: <201011161934.oAGJYJ68003193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab0KPTe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, rpurdie@linux.intel.com, sfr@canb.auug.org.au, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp8860_blc-check-strict_strtoul-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value
From: Michael Hennerich <michael.hennerich@analog.com>

Handle return value, strict_strtoul is declared with attribute
warn_unused_result.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
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

linux-next.patch

