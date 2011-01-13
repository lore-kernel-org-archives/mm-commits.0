From: akpm@linux-foundation.org
Subject: [merged] set_rtc_mmss-show-warning-message-only-once.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:52 -0800
Message-ID: <201101132006.p0DK6Xhi029757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933650Ab1AMUH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, dhowells@redhat.com, hpa@zytor.com, ink@jurassic.park.msu.ru, lethal@linux-sh.org, mattst88@gmail.com, mingo@elte.hu, ralf@linux-mips.org, rth@twiddle.net, tglx


The patch titled
     set_rtc_mmss: show warning message only once
has been removed from the -mm tree.  Its filename was
     set_rtc_mmss-show-warning-message-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: set_rtc_mmss: show warning message only once
From: Stephen Hemminger <shemminger@vyatta.com>

Occasionally the system gets into a state where the CMOS clock has gotten
slightly ahead of current time and the periodic update of RTC fails.  The
message is a nuisance and repeats spamming the log.

  See: http://www.ntp.org/ntpfaq/NTP-s-trbl-spec.htm#Q-LINUX-SET-RTC-MMSS

Rather than just removing the message, make it show only once and reduce
severity since it indicates a normal and non urgent condition.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/time.c              |    2 +-
 arch/cris/kernel/time.c               |    2 +-
 arch/mips/dec/time.c                  |    2 +-
 arch/mips/include/asm/mc146818-time.h |    2 +-
 arch/mn10300/kernel/rtc.c             |    2 +-
 arch/sh/boards/mach-sh03/rtc.c        |    2 +-
 arch/x86/kernel/rtc.c                 |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/alpha/kernel/time.c~set_rtc_mmss-show-warning-message-only-once arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/alpha/kernel/time.c
@@ -506,7 +506,7 @@ set_rtc_mmss(unsigned long nowtime)
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
  		retval = -1;
diff -puN arch/cris/kernel/time.c~set_rtc_mmss-show-warning-message-only-once arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/cris/kernel/time.c
@@ -86,7 +86,7 @@ int set_rtc_mmss(unsigned long nowtime)
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
diff -puN arch/mips/dec/time.c~set_rtc_mmss-show-warning-message-only-once arch/mips/dec/time.c
--- a/arch/mips/dec/time.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/mips/dec/time.c
@@ -104,7 +104,7 @@ int rtc_mips_set_mmss(unsigned long nowt
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
diff -puN arch/mips/include/asm/mc146818-time.h~set_rtc_mmss-show-warning-message-only-once arch/mips/include/asm/mc146818-time.h
--- a/arch/mips/include/asm/mc146818-time.h~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/mips/include/asm/mc146818-time.h
@@ -66,7 +66,7 @@ static inline int mc146818_set_rtc_mmss(
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
diff -puN arch/mn10300/kernel/rtc.c~set_rtc_mmss-show-warning-message-only-once arch/mn10300/kernel/rtc.c
--- a/arch/mn10300/kernel/rtc.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/mn10300/kernel/rtc.c
@@ -89,7 +89,7 @@ static int set_rtc_mmss(unsigned long no
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
diff -puN arch/sh/boards/mach-sh03/rtc.c~set_rtc_mmss-show-warning-message-only-once arch/sh/boards/mach-sh03/rtc.c
--- a/arch/sh/boards/mach-sh03/rtc.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/sh/boards/mach-sh03/rtc.c
@@ -108,7 +108,7 @@ static int set_rtc_mmss(unsigned long no
 		__raw_writeb(real_minutes % 10, RTC_MIN1);
 		__raw_writeb(real_minutes / 10, RTC_MIN10);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
diff -puN arch/x86/kernel/rtc.c~set_rtc_mmss-show-warning-message-only-once arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~set_rtc_mmss-show-warning-message-only-once
+++ a/arch/x86/kernel/rtc.c
@@ -76,7 +76,7 @@ int mach_set_rtc_mmss(unsigned long nowt
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
-		printk(KERN_WARNING
+		printk_once(KERN_NOTICE
 		       "set_rtc_mmss: can't update from %d to %d\n",
 		       cmos_minutes, real_minutes);
 		retval = -1;
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch

