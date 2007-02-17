From: akpm@linux-foundation.org
Subject: - clocksource-fixup-is_continous-changes-on-mips.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:03 -0800
Message-ID: <200702170714.l1H7E3hR021500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946599AbXBQHW2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, ralf@linux-mips.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: fixup is_continous changes on MIPS
has been removed from the -mm tree.  Its filename was
     clocksource-fixup-is_continous-changes-on-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fixup is_continous changes on MIPS
From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/kernel/time.c~clocksource-fixup-is_continous-changes-on-mips arch/mips/kernel/time.c
--- a/arch/mips/kernel/time.c~clocksource-fixup-is_continous-changes-on-mips
+++ a/arch/mips/kernel/time.c
@@ -307,7 +307,7 @@ static unsigned int __init calibrate_hpt
 struct clocksource clocksource_mips = {
 	.name		= "MIPS",
 	.mask		= 0xffffffff,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init init_mips_clocksource(void)
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
