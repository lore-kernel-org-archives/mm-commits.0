From: akpm@linux-foundation.org
Subject: + convert-sparc-to-arch_gettimeoffset-fix.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:13:33 -0800
Message-ID: <201001140113.o0E1DXdB007536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab0ANBOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, davem@davemloft.net


The patch titled
     convert-sparc-to-arch_gettimeoffset-fix
has been added to the -mm tree.  Its filename is
     convert-sparc-to-arch_gettimeoffset-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: convert-sparc-to-arch_gettimeoffset-fix
From: john stultz <johnstul@us.ibm.com>

Move do_arch_gettimeoffset function pointer declaration to a timex_32.h

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/timex_32.h |    1 +
 arch/sparc/kernel/pcic.c          |    3 +--
 arch/sparc/kernel/time_32.c       |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/sparc/include/asm/timex_32.h~convert-sparc-to-arch_gettimeoffset-fix arch/sparc/include/asm/timex_32.h
--- a/arch/sparc/include/asm/timex_32.h~convert-sparc-to-arch_gettimeoffset-fix
+++ a/arch/sparc/include/asm/timex_32.h
@@ -12,4 +12,5 @@
 typedef unsigned long cycles_t;
 #define get_cycles()	(0)
 
+extern u32 (*do_arch_gettimeoffset)(void);
 #endif
diff -puN arch/sparc/kernel/pcic.c~convert-sparc-to-arch_gettimeoffset-fix arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c~convert-sparc-to-arch_gettimeoffset-fix
+++ a/arch/sparc/kernel/pcic.c
@@ -30,6 +30,7 @@
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/pcic.h>
+#include <asm/timex.h>
 #include <asm/timer.h>
 #include <asm/uaccess.h>
 #include <asm/irq_regs.h>
@@ -714,8 +715,6 @@ static irqreturn_t pcic_timer_handler (i
 #define USECS_PER_JIFFY  10000  /* We have 100HZ "standard" timer for sparc */
 #define TICK_TIMER_LIMIT ((100*1000000/4)/100)
 
-extern u32 (*do_arch_gettimeoffset)(void);
-
 u32 pci_gettimeoffset(void)
 {
 	/*
diff -puN arch/sparc/kernel/time_32.c~convert-sparc-to-arch_gettimeoffset-fix arch/sparc/kernel/time_32.c
--- a/arch/sparc/kernel/time_32.c~convert-sparc-to-arch_gettimeoffset-fix
+++ a/arch/sparc/kernel/time_32.c
@@ -35,6 +35,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/oplib.h>
+#include <asm/timex.h>
 #include <asm/timer.h>
 #include <asm/system.h>
 #include <asm/irq.h>
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

m68knommu-fix-invalid-flags-on-coldfire-pit-clocksource.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
convert-sparc-to-arch_gettimeoffset.patch
convert-sparc-to-arch_gettimeoffset-fix.patch
cris-convert-to-use-arch_gettimeoffset.patch

