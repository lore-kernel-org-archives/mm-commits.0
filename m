From: akpm@linux-foundation.org
Subject: + ipmi-set-schedule_timeout_wait-value-back-to-one.patch added to -mm tree
Date: Wed, 16 Jun 2010 13:32:24 -0700
Message-ID: <201006162032.o5GKWOYv026272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759463Ab0FPUdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jun 2010 16:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: martin.wilck@ts.fujitsu.com, cminyard@mvista.com, stable@kernel.org, thomas.jarosch@intra2net.com


The patch titled
     ipmi: set schedule_timeout_wait() value back to one
has been added to the -mm tree.  Its filename is
     ipmi-set-schedule_timeout_wait-value-back-to-one.patch

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
Subject: ipmi: set schedule_timeout_wait() value back to one
From: Martin Wilck <martin.wilck@ts.fujitsu.com>

Fix a regression introduced by ae74e823cb7d ("ipmi: add parameter to limit
CPU usage in kipmid").

Some systems were seeing CPU usage go up dramatically with the recent
changes to try to reduce timer usage in the IPMI driver.  This was traced
down to schedule_timeout_interruptible(1) being changed to
schedule_timeout_interruptbile(0).  Revert that part of the change.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16147

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: <stable@kernel.org>		[2.6.34.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-set-schedule_timeout_wait-value-back-to-one drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-set-schedule_timeout_wait-value-back-to-one
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1024,7 +1024,7 @@ static int ipmi_thread(void *data)
 		else if (smi_result == SI_SM_IDLE)
 			schedule_timeout_interruptible(100);
 		else
-			schedule_timeout_interruptible(0);
+			schedule_timeout_interruptible(1);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from martin.wilck@ts.fujitsu.com are

ipmi-set-schedule_timeout_wait-value-back-to-one.patch

