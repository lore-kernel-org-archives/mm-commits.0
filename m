From: akpm@linux-foundation.org
Subject: [merged] ipmi-use-locks-on-watchdog-timeout-set-on-reboot.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:02 -0700
Message-ID: <20120329191402.530C9A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:35059 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab2C2TOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:04 -0400
Received: by faaa19 with SMTP id a19so23539faa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: use locks on watchdog timeout set on reboot
has been removed from the -mm tree.  Its filename was
     ipmi-use-locks-on-watchdog-timeout-set-on-reboot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: ipmi: use locks on watchdog timeout set on reboot

The IPMI watchdog timer clears or extends the timer on reboot/shutdown. 
It was using the non-locking routine for setting the watchdog timer, but
this was causing race conditions.  Instead, use the locking version to
avoid the races.  It seems to work fine.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-use-locks-on-watchdog-timeout-set-on-reboot drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-use-locks-on-watchdog-timeout-set-on-reboot
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -1167,7 +1167,7 @@ static int wdog_reboot_handler(struct no
 		if (code == SYS_POWER_OFF || code == SYS_HALT) {
 			/* Disable the WDT if we are shutting down. */
 			ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
-			panic_halt_ipmi_set_timeout();
+			ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 		} else if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
 			/* Set a long timer to let the reboot happens, but
 			   reboot if it hangs, but only if the watchdog
@@ -1175,7 +1175,7 @@ static int wdog_reboot_handler(struct no
 			timeout = 120;
 			pretimeout = 0;
 			ipmi_watchdog_state = WDOG_TIMEOUT_RESET;
-			panic_halt_ipmi_set_timeout();
+			ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 		}
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

