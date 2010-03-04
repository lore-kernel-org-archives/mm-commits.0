From: akpm@linux-foundation.org
Subject: + xtensa-fix-unnecessary-setting-of-xtime.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:53:22 -0800
Message-ID: <201003042153.o24LrMiL032113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab0CDVxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, chris@zankel.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     xtensa: fix unnecessary setting of xtime
has been added to the -mm tree.  Its filename is
     xtensa-fix-unnecessary-setting-of-xtime.patch

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
Subject: xtensa: fix unnecessary setting of xtime
From: John Stultz <johnstul@us.ibm.com>

xtensa supports read_persisitent_clock(), so there is no reason for the
arch specific code to be setting xtime.  Setting xtime will be done by the
generic timekeeping code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/xtensa/kernel/time.c~xtensa-fix-unnecessary-setting-of-xtime arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~xtensa-fix-unnecessary-setting-of-xtime
+++ a/arch/xtensa/kernel/time.c
@@ -60,11 +60,6 @@ static struct irqaction timer_irqaction 
 
 void __init time_init(void)
 {
-	/* FIXME: xtime&wall_to_monotonic are set in timekeeping_init. */
-	read_persistent_clock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
