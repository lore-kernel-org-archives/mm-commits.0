From: akpm@linux-foundation.org
Subject: + kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch
 added to -mm tree
Date: Wed, 29 May 2013 16:01:58 -0700
Message-ID: <51a688e6.uL/kOZpD01DJ8z/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967138Ab3E2XB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 19:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sfr@canb.auug.org.au, bvanassche@acm.org, arjan@infradead.org, bart.vanassche@gmail.com

Subject: + kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch added to -mm tree
To: bart.vanassche@gmail.com,arjan@infradead.org,bvanassche@acm.org,sfr@canb.auug.org.au,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 16:01:58 -0700


The patch titled
     Subject: kernel/timer.c: fix jiffies wrap behavior of round_jiffies*()
has been added to the -mm tree.  Its filename is
     kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: kernel/timer.c: fix jiffies wrap behavior of round_jiffies*()

Make sure that the round_jiffies*() functions return a time that is
in the future when the jiffies counter has recently wrapped.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/timer.c~kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies
+++ a/kernel/timer.c
@@ -149,9 +149,7 @@ static unsigned long round_jiffies_commo
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
_

Patches currently in -mm which might be from bart.vanassche@gmail.com are

kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch

