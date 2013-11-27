From: akpm@linux-foundation.org
Subject: [merged]
 genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch removed from
 -mm tree
Date: Wed, 27 Nov 2013 12:26:29 -0800
Message-ID: <52965575.bhN6DQ00PDDZZd9h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab3K0U0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 15:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, geert@linux-m68k.org

Subject: [merged] genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch removed from -mm tree
To: geert@linux-m68k.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 12:26:29 -0800


The patch titled
     Subject: genirq: correct fuzzy and fragile IRQ_RETVAL() definition
has been removed from the -mm tree.  Its filename was
     genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: genirq: correct fuzzy and fragile IRQ_RETVAL() definition

commit bedd30d986a0 ("genirq: make irqreturn_t an enum") blindly replaced
"0" by "IRQ_NONE" in the "IRQ_RETVAL(x)" macro definition.

However, as "x" is a condition, "0" meant "boolean false", not an
irqreturn_t value.

All of this worked, and kept working after the addition of IRQ_WAKE_THREAD,
as
  - both "boolean false" and "IRQ_NONE" are "0" (for the comparison),
  - "boolean true" and "boolean false" nicely map to the correct values of
    "IRQ_HANDLED" and "IRQ_NONE" (for the return value).

Correct the macro definition for clarity and future-proofness.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqreturn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/irqreturn.h~genirq-correct-fuzzy-and-fragile-irq_retval-definition include/linux/irqreturn.h
--- a/include/linux/irqreturn.h~genirq-correct-fuzzy-and-fragile-irq_retval-definition
+++ a/include/linux/irqreturn.h
@@ -14,6 +14,6 @@ enum irqreturn {
 };
 
 typedef enum irqreturn irqreturn_t;
-#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
+#define IRQ_RETVAL(x)	((x) ? IRQ_HANDLED : IRQ_NONE)
 
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
fork-no-need-to-initialize-child-exit_state.patch

