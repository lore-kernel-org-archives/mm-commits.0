From: akpm@linux-foundation.org
Subject: + fix-jiffies-clocksource-inittime.patch added to -mm tree
Date: Wed, 04 Apr 2007 13:43:18 -0700
Message-ID: <200704042043.l34KhI9f030620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXDDUpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 16:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     fix jiffies clocksource inittime
has been added to the -mm tree.  Its filename is
     fix-jiffies-clocksource-inittime.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix jiffies clocksource inittime
From: john stultz <johnstul@us.ibm.com>

In debugging a problem w/ the -rt tree, I noticed that on systems that mark
the tsc as unstable before it is registered, the TSC would still be
selected and used for a short period of time.  Digging in it looks to be a
result of the mix of the clocksource list changes and my clocksource
initialization changes.

With the -rt tree, using a bad TSC, even for a short period of time can
results in a hang at boot.  I was not able to reproduce this hang w/
mainline, but I'm not completely certain that someone won't trip on it.

This patch resolves the issue by initializing the jiffies clocksource
earlier so a bad TSC won't get selected just because nothing else is yet
registered.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/jiffies.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/jiffies.c~fix-jiffies-clocksource-inittime kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~fix-jiffies-clocksource-inittime
+++ a/kernel/time/jiffies.c
@@ -69,4 +69,4 @@ static int __init init_jiffies_clocksour
 	return clocksource_register(&clocksource_jiffies);
 }
 
-module_init(init_jiffies_clocksource);
+core_initcall(init_jiffies_clocksource);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
fix-jiffies-clocksource-inittime.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
declare-struct-ktime.patch
clocksource-arm-initialize-list-value.patch
clocksource-parisc-initialize-list-value.patch
clocksource-avr32-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
