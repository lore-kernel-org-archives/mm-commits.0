From: akpm@linux-foundation.org
Subject: - clocksource-keep-track-of-original-clocksource-frequency.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:42 -0700
Message-ID: <200808261845.m7QIjgDv021422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453AbYHZSya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: keep track of original clocksource frequency
has been removed from the -mm tree.  Its filename was
     clocksource-keep-track-of-original-clocksource-frequency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: keep track of original clocksource frequency
From: John Stultz <johnstul@us.ibm.com>

The clocksource frequency is represented by
clocksource->mult/2^(clocksource->shift).  Currently, when NTP makes
adjustments to the clock frequency, they are made directly to the mult
value.

This has the drawback that once changed, we cannot know what the orignal
mult value was, or how much adjustment has been applied.

This property causes problems in calculating proper ntp intervals when
switching back and forth between clocksources.

This patch separates the current mult value into a mult and mult_orig
pair.  The mult_orig value stays constant, while the ntp clocksource
adjustments are done only to the mult value.

This allows for correct ntp interval calculation and additionally lays the
groundwork for a new notion of time, what I'm calling the monotonic-raw
time, which is introduced in a following patch.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   11 +++++++----
 kernel/time/clocksource.c   |    3 +++
 kernel/time/jiffies.c       |    1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN include/linux/clocksource.h~clocksource-keep-track-of-original-clocksource-frequency include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-keep-track-of-original-clocksource-frequency
+++ a/include/linux/clocksource.h
@@ -45,7 +45,8 @@ struct clocksource;
  * @read:		returns a cycle value
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
- * @mult:		cycle to nanosecond multiplier
+ * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
+ * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
@@ -63,6 +64,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
+	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
@@ -201,16 +203,17 @@ static inline void clocksource_calculate
 {
 	u64 tmp;
 
-	/* XXX - All of this could use a whole lot of optimization */
+	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = length_nsec;
 	tmp <<= c->shift;
-	tmp += c->mult/2;
-	do_div(tmp, c->mult);
+	tmp += c->mult_orig/2;
+	do_div(tmp, c->mult_orig);
 
 	c->cycle_interval = (cycle_t)tmp;
 	if (c->cycle_interval == 0)
 		c->cycle_interval = 1;
 
+	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
 	c->xtime_interval = (u64)c->cycle_interval * c->mult;
 }
 
diff -puN kernel/time/clocksource.c~clocksource-keep-track-of-original-clocksource-frequency kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-keep-track-of-original-clocksource-frequency
+++ a/kernel/time/clocksource.c
@@ -325,6 +325,9 @@ int clocksource_register(struct clocksou
 	unsigned long flags;
 	int ret;
 
+	/* save mult_orig on registration */
+	c->mult_orig = c->mult;
+
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
diff -puN kernel/time/jiffies.c~clocksource-keep-track-of-original-clocksource-frequency kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~clocksource-keep-track-of-original-clocksource-frequency
+++ a/kernel/time/jiffies.c
@@ -61,6 +61,7 @@ struct clocksource clocksource_jiffies =
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
+	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-improve-adjtimex-frequency-rounding.patch

