From: akpm@linux-foundation.org
Subject: +
 drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch
 added to -mm tree
Date: Thu, 22 Aug 2013 14:23:24 -0700
Message-ID: <5216814c.Vg8aOlgIAtuk7sEl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3HVVXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 17:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, jg1.han@samsung.com

Subject: + drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
To: jg1.han@samsung.com,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 14:23:24 -0700


The patch titled
     Subject: drivers/w1/masters/mxc_w1.c: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch

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
Subject: drivers/w1/masters/mxc_w1.c: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/mxc_w1.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/w1/masters/mxc_w1.c~drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata drivers/w1/masters/mxc_w1.c
--- a/drivers/w1/masters/mxc_w1.c~drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata
+++ a/drivers/w1/masters/mxc_w1.c
@@ -152,8 +152,6 @@ static int mxc_w1_remove(struct platform
 
 	clk_disable_unprepare(mdev->clk);
 
-	platform_set_drvdata(pdev, NULL);
