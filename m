From: akpm@linux-foundation.org
Subject: - deprecate-sa_xxx-interrupt-flags-v2.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:59 -0700
Message-ID: <200705090248.l492mx9c009173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966107AbXEICtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Deprecate SA_xxx interrupt flags -V2
has been removed from the -mm tree.  Its filename was
     deprecate-sa_xxx-interrupt-flags-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Deprecate SA_xxx interrupt flags -V2
From: Thomas Gleixner <tglx@linutronix.de>

The deprecation of the SA_xxx interrupt flags did not emit deprecated
warnings. Andrew said about the removal of the deprecated flag defines:

> This is going to break a lot of external stuff.  We should have found
> a way to make usage of SA_* emit deprecated warnings (or _some_
> warning) to warn people of impending doom.  But I can't immediately
> find a way of doing that. if we _can_ find a way of doing this, I
> suspect we'll need to do it, and give people another six months.  It's
> going to get ugly out there.  We shall see...

Define the deprecated flags as a call to a __deprecated inline function
so a warning is emitted on compile time.

Extend the reprieve of out of tree drivers to 9/2007.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    2 -
 include/linux/interrupt.h                  |   30 +++++++++++--------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-sa_xxx-interrupt-flags-v2 Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-sa_xxx-interrupt-flags-v2
+++ a/Documentation/feature-removal-schedule.txt
@@ -156,7 +156,7 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
 ---------------------------
 
 What:	Interrupt only SA_* flags
-When:	Januar 2007
+When:	September 2007
 Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
 	out of the signal namespace.
 
diff -puN include/linux/interrupt.h~deprecate-sa_xxx-interrupt-flags-v2 include/linux/interrupt.h
--- a/include/linux/interrupt.h~deprecate-sa_xxx-interrupt-flags-v2
+++ a/include/linux/interrupt.h
@@ -54,20 +54,26 @@
 #define IRQF_NOBALANCING	0x00000800
 
 /*
- * Migration helpers. Scheduled for removal in 1/2007
+ * Migration helpers. Scheduled for removal in 9/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+static inline
+unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
+{
+	return flag;
+}
+
+#define SA_INTERRUPT		deprecated_irq_flag(IRQF_DISABLED)
+#define SA_SAMPLE_RANDOM	deprecated_irq_flag(IRQF_SAMPLE_RANDOM)
+#define SA_SHIRQ		deprecated_irq_flag(IRQF_SHARED)
+#define SA_PROBEIRQ		deprecated_irq_flag(IRQF_PROBE_SHARED)
+#define SA_PERCPU		deprecated_irq_flag(IRQF_PERCPU)
+
+#define SA_TRIGGER_LOW		deprecated_irq_flag(IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_HIGH		deprecated_irq_flag(IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_FALLING	deprecated_irq_flag(IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_RISING	deprecated_irq_flag(IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_MASK		deprecated_irq_flag(IRQF_TRIGGER_MASK)
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
git-mtd.patch
s390-spinlock-initializer-cleanup.patch
fix-printk-format-warnings-in-timer_listc.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
