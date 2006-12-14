From: akpm@osdl.org
Subject: + hpet-avoid-warning-message-livelock.patch added to -mm tree
Date: Thu, 14 Dec 2006 14:18:39 -0800
Message-ID: <200612142218.kBEMIdZ0030514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964864AbWLNWSm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 17:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, rolandd@cisco.com


The patch titled
     hpet: avoid warning message livelock
has been added to the -mm tree.  Its filename is
     hpet-avoid-warning-message-livelock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/time_hpet.c |    5 +++--
 arch/x86_64/kernel/time.c    |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/time_hpet.c~hpet-avoid-warning-message-livelock arch/i386/kernel/time_hpet.c
--- a/arch/i386/kernel/time_hpet.c~hpet-avoid-warning-message-livelock
+++ a/arch/i386/kernel/time_hpet.c
@@ -367,8 +367,9 @@ static void hpet_rtc_timer_reinit(void)
 		if (PIE_on)
 			PIE_count += lost_ints;
 
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-		       hpet_rtc_int_freq);
+		if (printk_ratelimit())
+			printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
+			       hpet_rtc_int_freq);
 	}
 }
 
diff -puN arch/x86_64/kernel/time.c~hpet-avoid-warning-message-livelock arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~hpet-avoid-warning-message-livelock
+++ a/arch/x86_64/kernel/time.c
@@ -1216,8 +1216,9 @@ static void hpet_rtc_timer_reinit(void)
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
hpet-avoid-warning-message-livelock.patch

