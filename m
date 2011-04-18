From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure.patch added to -mm tree
Date: Mon, 18 Apr 2011 15:19:43 -0700
Message-ID: <201104182219.p3IMJhM2028216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892Ab1DRWUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 18:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it


The patch titled
     drivers/rtc/rtc-omap.c: fix a leak of the IRQ during init failure
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure.patch

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
Subject: drivers/rtc/rtc-omap.c: fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>

In omap_rtc_probe error path, free_irq() was using NULL rather than the
driver data as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure
+++ a/drivers/rtc/rtc-omap.c
@@ -394,7 +394,7 @@ static int __init omap_rtc_probe(struct 
 	return 0;
 
 fail2:
-	free_irq(omap_rtc_timer, NULL);
+	free_irq(omap_rtc_timer, rtc);
 fail1:
 	rtc_device_unregister(rtc);
 fail0:
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-omapc-fix-a-leak-of-the-irq-during-init-failure.patch

