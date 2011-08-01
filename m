From: akpm@linux-foundation.org
Subject: [merged] drivers-watchdog-shwdtc-fix-usage-of-mod_timer.patch removed from -mm tree
Date: Mon, 01 Aug 2011 11:49:12 -0700
Message-ID: <201108011847.p71Il4g3005612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab1HASr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 14:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.engraf@sysgo.com, lethal@linux-sh.org, stable@kernel.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     drivers/watchdog/shwdt.c: fix usage of mod_timer
has been removed from the -mm tree.  Its filename was
     drivers-watchdog-shwdtc-fix-usage-of-mod_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

