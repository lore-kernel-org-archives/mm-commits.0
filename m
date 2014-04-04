From: akpm@linux-foundation.org
Subject: [merged]
 backlight-l4f00242t03-remove-unnecessary-oom-messages.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:32 -0700
Message-ID: <533f090c.iKnYfVUfV8kWiPdq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDDTdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-l4f00242t03-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:32 -0700


The patch titled
     Subject: backlight: l4f00242t03: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-l4f00242t03-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: l4f00242t03: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-remove-unnecessary-oom-messages drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -181,11 +181,8 @@ static int l4f00242t03_probe(struct spi_
 
 	priv = devm_kzalloc(&spi->dev, sizeof(struct l4f00242t03_priv),
 				GFP_KERNEL);
