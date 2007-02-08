From: akpm@linux-foundation.org
Subject: - hpet-avoid-warning-message-livelock.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:53:15 -0800
Message-ID: <200702082153.l18LrF9H027693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423468AbXBHVxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     hpet: avoid warning message livelock
has been removed from the -mm tree.  Its filename was
     hpet-avoid-warning-message-livelock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpet: avoid warning message livelock
From: Roland Dreier <rdreier@cisco.com>

I've seen my box paralyzed by an endless spew of

    rtc: lost some interrupts at 1024Hz.

messages on the serial console.  What seems to be happening is that
something real causes an interrupt to be lost and triggers the
message.  But then printing the message to the serial console (from
the hpet interrupt handler) takes more than 1/1024th of a second, and
then some more interrupts are lost, so the message triggers again....

Fix this by adding a printk_ratelimit() before printing the warning.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/time.c~hpet-avoid-warning-message-livelock arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~hpet-avoid-warning-message-livelock
+++ a/arch/x86_64/kernel/time.c
@@ -1226,8 +1226,9 @@ static void hpet_rtc_timer_reinit(void)
 		if (PIE_on)
 			PIE_count += lost_ints;
 
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-		       hpet_rtc_int_freq);
+		if (printk_ratelimit())
+			printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
+			       hpet_rtc_int_freq);
 	}
 }
 
_

Patches currently in -mm which might be from rdreier@cisco.com are

infiniband-work-around-gcc-bug-on-sparc64.patch
