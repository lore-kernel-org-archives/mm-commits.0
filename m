From: akpm@linux-foundation.org
Subject: + memstick-r592-fix-build-warnings-for-pm_sleep.patch added to
 -mm tree
Date: Thu, 02 Oct 2014 14:03:52 -0700
Message-ID: <542dbdb8.c8ILINShSM+NT///%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaJBVDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2014 17:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: r592: fix build warnings for !PM_SLEEP
has been added to the -mm tree.  Its filename is
     memstick-r592-fix-build-warnings-for-pm_sleep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-r592-fix-build-warnings-for-pm_sleep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-r592-fix-build-warnings-for-pm_sleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: memstick: r592: fix build warnings for !PM_SLEEP

When PM_SLEEP is not enabled, the r592_clear_interrupts() function is
never used.  If so, don't build it to prevent a compiler warning.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/memstick/host/r592.c~memstick-r592-fix-build-warnings-for-pm_sleep drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-r592-fix-build-warnings-for-pm_sleep
+++ a/drivers/memstick/host/r592.c
@@ -188,6 +188,7 @@ static void r592_host_reset(struct r592_
 	r592_set_mode(dev, dev->parallel_mode);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* Disable all hardware interrupts */
 static void r592_clear_interrupts(struct r592_device *dev)
 {
@@ -195,6 +196,7 @@ static void r592_clear_interrupts(struct
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_ACK_MASK);
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_EN_MASK);
 }
+#endif
 
 /* Tests if there is an CRC error */
 static int r592_test_io_error(struct r592_device *dev)
_

Patches currently in -mm which might be from treding@nvidia.com are

memstick-r592-fix-build-warnings-for-pm_sleep.patch
linux-next.patch

