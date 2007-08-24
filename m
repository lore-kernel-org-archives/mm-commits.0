From: akpm@linux-foundation.org
Subject: - x86_64-hpet-restore-vread.patch removed from -mm tree
Date: Fri, 24 Aug 2007 14:47:37 -0700
Message-ID: <200708242147.l7OLlbA0016261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760645AbXHXVs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: hpet restore vread
has been removed from the -mm tree.  Its filename was
     x86_64-hpet-restore-vread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: x86_64: hpet restore vread
From: Sebastien Dugue <sebastien.dugue@bull.net>

It seems the hpet clocksource's vread method was lost in the x86_64 conversion
to clockevents.  So here it is.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN arch/i386/kernel/hpet.c~x86_64-hpet-restore-vread arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~x86_64-hpet-restore-vread
+++ a/arch/i386/kernel/hpet.c
@@ -215,6 +215,13 @@ static cycle_t read_hpet(void)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
+#ifdef CONFIG_X86_64
+static cycle_t __vsyscall_fn vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+#endif
+
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -223,6 +230,9 @@ static struct clocksource clocksource_hp
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_start_counter,
+#ifdef CONFIG_X86_64
+	.vread		= vread_hpet,
+#endif
 };
 
 /*
_

Patches currently in -mm which might be from sebastien.dugue@bull.net are

x86_64-hpet-restore-vread.patch
