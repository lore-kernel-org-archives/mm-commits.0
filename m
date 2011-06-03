From: akpm@linux-foundation.org
Subject: + drivers-misc-cs5535-mfgptc-fix-wrong-if-condition.patch added to -mm tree
Date: Fri, 03 Jun 2011 16:14:26 -0700
Message-ID: <201106032314.p53NEQFs013547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab1FCXO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christian.gmeiner@gmail.com, dilinger@queued.net


The patch titled
     drivers/misc/cs5535-mfgpt.c: fix wrong if condition
has been added to the -mm tree.  Its filename is
     drivers-misc-cs5535-mfgptc-fix-wrong-if-condition.patch

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
Subject: drivers/misc/cs5535-mfgpt.c: fix wrong if condition
From: Christian Gmeiner <christian.gmeiner@gmail.com>

Fix the wrong `if' condition for the check if the requested timer is
available.

The bitmap avail is used to store if a timer is used already.  test_bit()
is used to check if the requested timer is available.  If a bit in the
avail bitmap is set it means that the timer is available.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/cs5535-mfgpt.c~drivers-misc-cs5535-mfgptc-fix-wrong-if-condition drivers/misc/cs5535-mfgpt.c
--- a/drivers/misc/cs5535-mfgpt.c~drivers-misc-cs5535-mfgptc-fix-wrong-if-condition
+++ a/drivers/misc/cs5535-mfgpt.c
@@ -174,7 +174,7 @@ struct cs5535_mfgpt_timer *cs5535_mfgpt_
 		timer_nr = t < max ? (int) t : -1;
 	} else {
 		/* check if the requested timer's available */
-		if (test_bit(timer_nr, mfgpt->avail))
+               if (!test_bit(timer_nr, mfgpt->avail))
 			timer_nr = -1;
 	}
 
_

Patches currently in -mm which might be from christian.gmeiner@gmail.com are

drivers-misc-cs5535-mfgptc-fix-wrong-if-condition.patch

