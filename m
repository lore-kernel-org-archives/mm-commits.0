From: akpm@linux-foundation.org
Subject: + ipmi-change-timeout-and-event-poll-to-one-second.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:22 -0700
Message-ID: <201005042254.o44MsMnl023818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934496Ab0EDWyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: change timeout and event poll to one second
has been added to the -mm tree.  Its filename is
     ipmi-change-timeout-and-event-poll-to-one-second.patch

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
Subject: ipmi: change timeout and event poll to one second
From: Corey Minyard <cminyard@mvista.com>

The timeouts in IPMI are in the 1-5 second range in message handling, so a
1 second timeout is a reasonable thing to do.  This should help with
reducing power consumption on idle systems.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-change-timeout-and-event-poll-to-one-second drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-change-timeout-and-event-poll-to-one-second
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -4037,8 +4037,8 @@ static void ipmi_request_event(void)
 
 static struct timer_list ipmi_timer;
 
-/* Call every ~100 ms. */
-#define IPMI_TIMEOUT_TIME	100
+/* Call every ~1000 ms. */
+#define IPMI_TIMEOUT_TIME	1000
 
 /* How many jiffies does it take to get to the timeout time. */
 #define IPMI_TIMEOUT_JIFFIES	((IPMI_TIMEOUT_TIME * HZ) / 1000)
_

Patches currently in -mm which might be from cminyard@mvista.com are

linux-next.patch
ipmi-change-addr_source-to-an-enum-rather-than-strings.patch
ipmi-split-device-discovery-and-registration.patch
ipmi-only-register-one-si-per-bmc.patch
ipmi-change-device-discovery-order.patch
ipmi-reduce-polling-when-interrupts-are-available.patch
ipmi-reduce-polling.patch
ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch
ipmi-change-timeout-and-event-poll-to-one-second.patch

