From: akpm@linux-foundation.org
Subject: - clocksource-i386-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:55 -0700
Message-ID: <200704051928.l35JSteX024043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbXDET3r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: i386 initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-i386-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: i386 initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/i386/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c    |    1 +
 arch/i386/kernel/i8253.c   |    1 +
 arch/i386/kernel/tsc.c     |    1 +
 arch/i386/kernel/vmitime.c |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/i386/kernel/hpet.c~clocksource-i386-initialize-list-value arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clocksource-i386-initialize-list-value
+++ a/arch/i386/kernel/hpet.c
@@ -217,6 +217,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 /*
diff -puN arch/i386/kernel/i8253.c~clocksource-i386-initialize-list-value arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clocksource-i386-initialize-list-value
+++ a/arch/i386/kernel/i8253.c
@@ -193,6 +193,7 @@ static struct clocksource clocksource_pi
 	.mask	= CLOCKSOURCE_MASK(32),
 	.mult	= 0,
 	.shift	= 20,
+	.list	= LIST_HEAD_INIT(clocksource_pit.list),
 };
 
 static int __init init_pit_clocksource(void)
diff -puN arch/i386/kernel/tsc.c~clocksource-i386-initialize-list-value arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-i386-initialize-list-value
+++ a/arch/i386/kernel/tsc.c
@@ -279,6 +279,7 @@ static struct clocksource clocksource_ts
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 void mark_tsc_unstable(void)
diff -puN arch/i386/kernel/vmitime.c~clocksource-i386-initialize-list-value arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~clocksource-i386-initialize-list-value
+++ a/arch/i386/kernel/vmitime.c
@@ -116,6 +116,7 @@ static struct clocksource clocksource_vm
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list			= LIST_HEAD_INIT(clocksource_vmi.list),
 };
 
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
