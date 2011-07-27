From: akpm@linux-foundation.org
Subject: + drivers-watchdog-shwdtc-fix-usage-of-mod_timer.patch added to -mm tree
Date: Wed, 27 Jul 2011 16:53:27 -0700
Message-ID: <201107272353.p6RNrRU0015896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab1G0XyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 19:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.engraf@sysgo.com, lethal@linux-sh.org, stable@kernel.org, wim@iguana.be


The patch titled
     drivers/watchdog/shwdt.c: fix usage of mod_timer
has been added to the -mm tree.  Its filename is
     drivers-watchdog-shwdtc-fix-usage-of-mod_timer.patch

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
Subject: drivers/watchdog/shwdt.c: fix usage of mod_timer
From: David Engraf <david.engraf@sysgo.com>

Fix the usage of mod_timer() and make the driver usable.  mod_timer() must
be called with an absolute timeout in jiffies.  The old implementation
used a relative timeout thus the hardware watchdog was never triggered.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/shwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/shwdt.c~drivers-watchdog-shwdtc-fix-usage-of-mod_timer drivers/watchdog/shwdt.c
--- a/drivers/watchdog/shwdt.c~drivers-watchdog-shwdtc-fix-usage-of-mod_timer
+++ a/drivers/watchdog/shwdt.c
@@ -64,7 +64,7 @@
  * misses its deadline, the kernel timer will allow the WDT to overflow.
  */
 static int clock_division_ratio = WTCSR_CKS_4096;
-#define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
+#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
 
 static const struct watchdog_info sh_wdt_info;
 static struct platform_device *sh_wdt_dev;
_

Patches currently in -mm which might be from david.engraf@sysgo.com are

drivers-watchdog-shwdtc-fix-usage-of-mod_timer.patch

