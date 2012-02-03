From: akpm@linux-foundation.org
Subject: + ipmi-use-locks-on-watchdog-timeout-set-on-reboot.patch added to -mm tree
Date: Fri, 03 Feb 2012 11:52:26 -0800
Message-ID: <20120203195227.13A6CA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36687 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2BCTw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 14:52:29 -0500
Received: by bkas6 with SMTP id s6so164227bka.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 11:52:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     Subject: ipmi: use locks on watchdog timeout set on reboot
has been added to the -mm tree.  Its filename is
     ipmi-use-locks-on-watchdog-timeout-set-on-reboot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: ipmi: use locks on watchdog timeout set on reboot

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-decreases-the-ipmi-message-transaction-time-in-interrupt-mode.patch
ipmi-increase-kcs-timeouts.patch
ipmi-use-a-tasklet-for-handling-received-messages.patch
ipmi-fix-message-handling-during-panics.patch
ipmi-simplify-locking.patch
ipmi-use-locks-on-watchdog-timeout-set-on-reboot.patch

