From: akpm@linux-foundation.org
Subject: - clocksource-x86_64-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:59 -0700
Message-ID: <200704051928.l35JSxSU024046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767222AbXDETar (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: x86_64 initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-x86_64-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: x86_64 initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/x86_64/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/hpet.c |    1 +
 arch/x86_64/kernel/tsc.c  |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/x86_64/kernel/hpet.c~clocksource-x86_64-initialize-list-value arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~clocksource-x86_64-initialize-list-value
+++ a/arch/x86_64/kernel/hpet.c
@@ -131,6 +131,7 @@ struct clocksource clocksource_hpet = {
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.vread		= vread_hpet,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 int hpet_arch_init(void)
diff -puN arch/x86_64/kernel/tsc.c~clocksource-x86_64-initialize-list-value arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~clocksource-x86_64-initialize-list-value
+++ a/arch/x86_64/kernel/tsc.c
@@ -197,6 +197,7 @@ static struct clocksource clocksource_ts
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 	.vread			= vread_tsc,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 void mark_tsc_unstable(void)
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
