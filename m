From: akpm@linux-foundation.org
Subject: - asm-h8300-parentheses-around-definition-clock_tick_rate.patch removed from -mm tree
Date: Tue, 11 Dec 2007 14:41:44 -0800
Message-ID: <200712112241.lBBMfi8K012555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755996AbXLKWmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     asm-h8300: parentheses around definition CLOCK_TICK_RATE
has been removed from the -mm tree.  Its filename was
     asm-h8300-parentheses-around-definition-clock_tick_rate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: asm-h8300: parentheses around definition CLOCK_TICK_RATE
From: Roel Kluin <12o3l@tiscali.nl>

Some places where CLOCK_TICK_RATE may be used incorrectly:

arch/arm/mach-mx3/time.c:125:   __raw_writel((v / CLOCK_TICK_RATE) - 1, MXC_GPT_GPTPR);
drivers/watchdog/davinci_wdt.c:103:     timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
drivers/watchdog/davinci_wdt.c:105:     timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
drivers/watchdog/ks8695_wdt.c:64:       unsigned long tval = wdt_time * CLOCK_TICK_RATE;

I'm not sure whether this definition is used there, but adding parentheses
should be good anyway.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/timex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-h8300/timex.h~asm-h8300-parentheses-around-definition-clock_tick_rate include/asm-h8300/timex.h
--- a/include/asm-h8300/timex.h~asm-h8300-parentheses-around-definition-clock_tick_rate
+++ a/include/asm-h8300/timex.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_H8300_TIMEX_H
 #define _ASM_H8300_TIMEX_H
 
-#define CLOCK_TICK_RATE CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
+#define CLOCK_TICK_RATE (CONFIG_CPU_CLOCK*1000/8192) /* Timer input freq. */
 
 typedef unsigned long cycles_t;
 extern short h8300_timer_count;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-dvb.patch
git-mips.patch
git-netdev-all.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
