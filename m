From: akpm@linux-foundation.org
Subject: + x86_64-hpet-restore-vread.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:08:06 -0700
Message-ID: <200706260008.l5Q086SH014471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbXFZAPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: hpet restore vread
has been added to the -mm tree.  Its filename is
     x86_64-hpet-restore-vread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -255,6 +255,13 @@ static cycle_t read_hpet(void)
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
@@ -263,6 +270,9 @@ static struct clocksource clocksource_hp
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
