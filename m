From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-ia64.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:17 -0700
Message-ID: <200705090256.l492uH6F010028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032448AbXEIC4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on IA64
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on IA64
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL for the timer interrupt on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/time.c~add-irqf_irqpoll-flag-on-ia64 arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~add-irqf_irqpoll-flag-on-ia64
+++ a/arch/ia64/kernel/time.c
@@ -235,7 +235,7 @@ ia64_init_itm (void)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
 	.name =		"timer"
 };
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
