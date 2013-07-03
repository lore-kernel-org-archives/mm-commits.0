From: akpm@linux-foundation.org
Subject: [merged]
 kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch removed from -mm tree
Date: Wed, 03 Jul 2013 12:32:21 -0700
Message-ID: <51d47c45.Mwbyo35NMD+wFzyt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3GCTcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 15:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sfr@canb.auug.org.au, bvanassche@acm.org, arjan@infradead.org, bart.vanassche@gmail.com

Subject: [merged] kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch removed from -mm tree
To: bart.vanassche@gmail.com,arjan@infradead.org,bvanassche@acm.org,sfr@canb.auug.org.au,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 12:32:21 -0700


The patch titled
     Subject: kernel/timer.c: fix jiffies wrap behavior of round_jiffies*()
has been removed from the -mm tree.  Its filename was
     kernel-timerc-fix-jiffies-wrap-behavior-of-round_jiffies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

