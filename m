From: akpm@linux-foundation.org
Subject: [merged] backlight-hx8357-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:26 -0700
Message-ID: <533f0906.Ixde9gzREAHWMAVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDTd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com, jg1.han@samsung.com

Subject: [merged] backlight-hx8357-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,maxime.ripard@free-electrons.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:26 -0700


The patch titled
     Subject: backlight: hx8357: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-hx8357-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: hx8357: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/hx8357.c~backlight-hx8357-remove-unnecessary-oom-messages drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~backlight-hx8357-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/hx8357.c
@@ -587,10 +587,8 @@ static int hx8357_probe(struct spi_devic
 	int i, ret;
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(*lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "Couldn't allocate lcd internal structure!\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

