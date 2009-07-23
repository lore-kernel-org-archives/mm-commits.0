From: akpm@linux-foundation.org
Subject: + preempt_active-add-default-defines.patch added to -mm tree
Date: Thu, 23 Jul 2009 15:18:38 -0700
Message-ID: <200907232218.n6NMIcIU009642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbZGWWTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 18:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, mingo@elte.hu, tglx@linutronix.de, vapier@gentoo.org


The patch titled
     PREEMPT_ACTIVE: add default defines
has been added to the -mm tree.  Its filename is
     preempt_active-add-default-defines.patch

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
Subject: PREEMPT_ACTIVE: add default defines
From: Arnd Bergmann <arnd@arndb.de>

The PREEMPT_ACTIVE setting doesn't actually need to be arch-specific, so
set up a sane default for all arches to (hopefully) migrate to.

> if we look at linux/hardirq.h, it makes this claim:
>  * - bit 28 is the PREEMPT_ACTIVE flag
> if that's true, then why are we letting any arch set this define ?  a
> quick survey shows that half the arches (11) are using 0x10000000 (bit
> 28) while the other half (10) are using 0x4000000 (bit 26).  and then
> there is the ia64 oddity which uses bit 30.  the exact value here
> shouldnt really matter across arches though should it ?

actually alpha, arm and avr32 also use bit 30 (0x40000000), there are only
five (or eight, depending on how you count) architectures (blackfin,
h8300, m68k, s390 and sparc) using bit 26.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hardirq.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/hardirq.h~preempt_active-add-default-defines include/linux/hardirq.h
--- a/include/linux/hardirq.h~preempt_active-add-default-defines
+++ a/include/linux/hardirq.h
@@ -64,6 +64,12 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#ifndef PREEMPT_ACTIVE
+#define PREEMPT_ACTIVE_BITS	1
+#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
+#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
+#endif
+
 #if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
 #error PREEMPT_ACTIVE is too low!
 #endif
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
preempt_active-add-default-defines.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
asm-generic-remove-calling-flush_write_buffers-in-dma_sync__for_cpu.patch

