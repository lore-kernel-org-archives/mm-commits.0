From: akpm@linux-foundation.org
Subject: + i386-hpet-check-if-the-counter-works.patch added to -mm tree
Date: Fri, 11 May 2007 11:22:29 -0700
Message-ID: <200705111822.l4BIMTVk023058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbXEKSX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 14:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, stable@kernel.org


The patch titled
     i386: HPET, check if the counter works
has been added to the -mm tree.  Its filename is
     i386-hpet-check-if-the-counter-works.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: HPET, check if the counter works
From: Thomas Gleixner <tglx@linutronix.de>

Some systems have a HPET which is not incrementing, which leads to a
complete hang.  Detect it during HPET setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-check-if-the-counter-works arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-hpet-check-if-the-counter-works
+++ a/arch/i386/kernel/hpet.c
@@ -226,7 +226,8 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
-	u64 tmp;
+	u64 tmp, start, now;
+	cycle_t t1;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -273,6 +274,27 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = read_hpet();
+	rdtscll(start);
+
+	/*
+	 * We don't know the TSC frequency yet, but waiting for
+	 * 200000 TSC cycles is safe:
+	 * 4 GHz == 50us
+	 * 1 GHz == 200us
+	 */
+	do {
+		rep_nop();
+		rdtscll(now);
+	} while ((now - start) < 200000UL);
+
+	if (t1 == read_hpet()) {
+		printk(KERN_WARNING
+		       "HPET counter not counting. HPET disabled\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
