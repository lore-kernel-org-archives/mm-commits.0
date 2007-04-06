From: akpm@linux-foundation.org
Subject: + deprecate-sa_xxx-interrupt-flags-v2.patch added to -mm tree
Date: Fri, 06 Apr 2007 12:23:10 -0700
Message-ID: <200704061923.l36JNAue016925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXDFTXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 15:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de


The patch titled
     Deprecate SA_xxx interrupt flags -V2
has been added to the -mm tree.  Its filename is
     deprecate-sa_xxx-interrupt-flags-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    2 -
 include/linux/interrupt.h                  |   30 +++++++++++--------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-sa_xxx-interrupt-flags-v2 Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-sa_xxx-interrupt-flags-v2
+++ a/Documentation/feature-removal-schedule.txt
@@ -171,7 +171,7 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
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
git-ieee1394.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
