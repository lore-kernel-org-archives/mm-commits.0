From: akpm@linux-foundation.org
Subject: + genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
 added to -mm tree
Date: Mon, 19 Aug 2013 16:45:02 -0700
Message-ID: <5212adfe.GUvwgpcrBm2LRujL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab3HSXpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 19:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, geert@linux-m68k.org

Subject: + genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch added to -mm tree
To: geert@linux-m68k.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 16:45:02 -0700


The patch titled
     Subject: genirq: correct fuzzy and fragile IRQ_RETVAL() definition
has been added to the -mm tree.  Its filename is
     genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
lz4-fix-compression-decompression-signedness-mismatch.patch
linux-next.patch

