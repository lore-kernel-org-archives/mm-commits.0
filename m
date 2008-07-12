From: akpm@linux-foundation.org
Subject: - ipmi-return-correct-value-from-ipmi_write.patch removed from -mm tree
Date: Sat, 12 Jul 2008 13:25:23 -0700
Message-ID: <200807122025.m6CKPNof020314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbYGLU1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 16:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mrustad@gmail.com, MRustad@gmail.com, cminyard@mvista.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: return correct value from ipmi_write
has been removed from the -mm tree.  Its filename was
     ipmi-return-correct-value-from-ipmi_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


