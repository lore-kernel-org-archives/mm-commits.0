From: akpm@linux-foundation.org
Subject: + rtc-core-fix-memory-leak.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:13:25 -0800
Message-ID: <201002192113.o1JLDPLl004580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab0BSVON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaro.koskinen@nokia.com, a.zummo@towertech.it, stable@kernel.org


The patch titled
     rtc-core: fix memory leak
has been added to the -mm tree.  Its filename is
     rtc-core-fix-memory-leak.patch

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
Subject: rtc-core: fix memory leak
From: Aaro Koskinen <aaro.koskinen@nokia.com>

The idr should be destroyed when the module is unloaded. Found with
kmemleak.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/class.c~rtc-core-fix-memory-leak drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-core-fix-memory-leak
+++ a/drivers/rtc/class.c
@@ -226,6 +226,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
+	idr_destroy(&rtc_idr);
 }
 
 subsys_initcall(rtc_init);
_

Patches currently in -mm which might be from aaro.koskinen@nokia.com are

linux-next.patch
rtc-core-fix-memory-leak.patch

