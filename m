From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:32 -0800
Message-ID: <5283e3c0.kQjWQaesX5ckAJEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, dan.carpenter@oracle.com

Subject: [merged] backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch removed from -mm tree
To: dan.carpenter@oracle.com,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:32 -0800


The patch titled
     Subject: drivers/video/backlight/lm3630a_bl.c: fix signedness bug in lm3630a_chip_init()
has been removed from the -mm tree.  Its filename was
     backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
framework-for-version-lvb-remove-some-impossible-checks.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
linux-next.patch

