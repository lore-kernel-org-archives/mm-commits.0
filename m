From: akpm@linux-foundation.org
Subject: + backlight-lm3630-apply-chip-revision-fix.patch added to -mm
 tree
Date: Thu, 03 Oct 2013 14:04:18 -0700
Message-ID: <524ddbd2.CAgLC9sP+nfg8Ybj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3JCVET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 17:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, gshark.jeong@gmail.com

Subject: + backlight-lm3630-apply-chip-revision-fix.patch added to -mm tree
To: gshark.jeong@gmail.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 14:04:18 -0700


The patch titled
     Subject: backlight: lm3630: fix sparse warning
has been added to the -mm tree.  Its filename is
     backlight-lm3630-apply-chip-revision-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lm3630-apply-chip-revision-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lm3630-apply-chip-revision-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

backlight-lm3630-apply-chip-revision.patch
backlight-lm3630-apply-chip-revision-fix.patch

