From: akpm@linux-foundation.org
Subject: + ipmi-return-correct-value-from-ipmi_write.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:36:22 -0700
Message-ID: <200807111842.m6BIg9Oh030648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707AbYGKSr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrustad@gmail.com, MRustad@gmail.com, cminyard@mvista.com, stable@kernel.org


The patch titled
     ipmi: return correct value from ipmi_write
has been added to the -mm tree.  Its filename is
     ipmi-return-correct-value-from-ipmi_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: return correct value from ipmi_write
From: Mark Rustad <mrustad@gmail.com>

This patch corrects the handling of write operations to the IPMI watchdog to
work as intended by returning the number of characters actually processed. 
Without this patch, an "echo V >/dev/watchdog" enables the watchdog if IPMI is
providing the watchdog function.

I have not checked all of the watchdogs to see if there are others that have
this problem, but the one I was using before using the IPMI one did work
right.  It was also a big surprise how much the default watchdog timeout
varies from one to another.  Let me tell you that the 10 second default for
the IPMI watchdog was a real sore spot while tracking this problem down!  This
problem goes back at least as far as 2.6.20.

Signed-off-by: Mark Rustad <MRustad@gmail.com>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-return-correct-value-from-ipmi_write drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-return-correct-value-from-ipmi_write
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -755,9 +755,8 @@ static ssize_t ipmi_write(struct file *f
 		rv = ipmi_heartbeat();
 		if (rv)
 			return rv;
-		return 1;
 	}
-	return 0;
+	return len;
 }
 
 static ssize_t ipmi_read(struct file *file,
_

Patches currently in -mm which might be from mrustad@gmail.com are

ipmi-return-correct-value-from-ipmi_write.patch

