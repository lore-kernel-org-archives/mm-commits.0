From: akpm@linux-foundation.org
Subject: - clocksource-fixup-is_continous-changes-on-avr32.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:57 -0800
Message-ID: <200702170713.l1H7Dv4J021494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946445AbXBQHOl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:14:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, hskinnemoen@atmel.com, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: fixup is_continous changes on AVR32
has been removed from the -mm tree.  Its filename was
     clocksource-fixup-is_continous-changes-on-avr32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fixup is_continous changes on AVR32
From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/kernel/time.c~clocksource-fixup-is_continous-changes-on-avr32 arch/avr32/kernel/time.c
--- a/arch/avr32/kernel/time.c~clocksource-fixup-is_continous-changes-on-avr32
+++ a/arch/avr32/kernel/time.c
@@ -37,7 +37,7 @@ static struct clocksource clocksource_av
 	.read		= read_cycle_count,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
