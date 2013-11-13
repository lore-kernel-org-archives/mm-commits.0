From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3630-apply-chip-revision-fix.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:40:36 -0800
Message-ID: <5283e3c4.P5hy/2vMlk9nu+Za%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, gshark.jeong@gmail.com

Subject: [merged] backlight-lm3630-apply-chip-revision-fix.patch removed from -mm tree
To: gshark.jeong@gmail.com,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:36 -0800


The patch titled
     Subject: backlight: lm3630: fix sparse warning
has been removed from the -mm tree.  Its filename was
     backlight-lm3630-apply-chip-revision-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Jeong <gshark.jeong@gmail.com>
Subject: backlight: lm3630: fix sparse warning

This patch is to fix sparse warning due to mixing different enum type.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630a_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-apply-chip-revision-fix drivers/video/backlight/lm3630a_bl.c
--- a/drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-apply-chip-revision-fix
+++ a/drivers/video/backlight/lm3630a_bl.c
@@ -90,8 +90,8 @@ static int lm3630a_chip_init(struct lm36
 	/* set current B */
 	rval |= lm3630a_write(pchip, REG_I_B, 0x1F);
 	/* set control */
-	rval |=
-	    lm3630a_write(pchip, REG_CTRL, pdata->leda_ctrl | pdata->ledb_ctrl);
+	rval |= lm3630a_update(pchip, REG_CTRL, 0x14, pdata->leda_ctrl);
+	rval |= lm3630a_update(pchip, REG_CTRL, 0x0B, pdata->ledb_ctrl);
 	usleep_range(1000, 2000);
 	/* set brightness A and B */
 	rval |= lm3630a_write(pchip, REG_BRT_A, pdata->leda_init_brt);
_

Patches currently in -mm which might be from gshark.jeong@gmail.com are

origin.patch
linux-next.patch

