From: akpm@linux-foundation.org
Subject: + backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 14:24:18 -0700
Message-ID: <52435482.VdSHxBEz9awRLtFB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3IYVYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 17:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, dan.carpenter@oracle.com

Subject: + backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch added to -mm tree
To: dan.carpenter@oracle.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 14:24:18 -0700


The patch titled
     Subject: drivers/video/backlight/lm3630a_bl.c: fix signedness bug in lm3630a_chip_init()
has been added to the -mm tree.  Its filename is
     backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/backlight/lm3630a_bl.c: fix signedness bug in lm3630a_chip_init()

"rval" needs to be signed for the error handling to work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630a_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-signedness-bug-in-lm3630a_chip_init drivers/video/backlight/lm3630a_bl.c
--- a/drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-signedness-bug-in-lm3630a_chip_init
+++ a/drivers/video/backlight/lm3630a_bl.c
@@ -105,7 +105,7 @@ static int lm3630a_chip_init(struct lm36
 /* interrupt handling */
 static void lm3630a_delayed_func(struct work_struct *work)
 {
-	unsigned int rval;
+	int rval;
 	struct lm3630a_chip *pchip;
 
 	pchip = container_of(work, struct lm3630a_chip, work.work);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
linux-next.patch

