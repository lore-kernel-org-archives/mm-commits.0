From: akpm@linux-foundation.org
Subject: - completely-remove-deprecated-irq-flags-sa_.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:33 -0700
Message-ID: <200710180701.l9I71XRt031185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760833AbXJRHib (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, James.Bottomley@steeleye.com, ralf@linux-mips.org, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     Completely remove deprecated IRQ flags (SA_*)
has been removed from the -mm tree.  Its filename was
     completely-remove-deprecated-irq-flags-sa_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Completely remove deprecated IRQ flags (SA_*)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Only very little files use the deprecated SA_* IRQ flags in latest pull.  This
patch series removes such macros from the tree and transfrom old code to the
new IRQF_* flags.

I've grepped the whole tree to make sure that no more files than the patched
ones use such deprecated macros.  I hope this series won't introduce build
errors.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |   22 ----------------------
 1 file changed, 22 deletions(-)

diff -puN include/linux/interrupt.h~completely-remove-deprecated-irq-flags-sa_ include/linux/interrupt.h
--- a/include/linux/interrupt.h~completely-remove-deprecated-irq-flags-sa_
+++ a/include/linux/interrupt.h
@@ -55,28 +55,6 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 
-/*
- * Migration helpers. Scheduled for removal in 9/2007
- * Do not use for new code !
- */
-static inline
-unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
-{
-	return flag;
-}
-
-#define SA_INTERRUPT		deprecated_irq_flag(IRQF_DISABLED)
-#define SA_SAMPLE_RANDOM	deprecated_irq_flag(IRQF_SAMPLE_RANDOM)
-#define SA_SHIRQ		deprecated_irq_flag(IRQF_SHARED)
-#define SA_PROBEIRQ		deprecated_irq_flag(IRQF_PROBE_SHARED)
-#define SA_PERCPU		deprecated_irq_flag(IRQF_PERCPU)
-
-#define SA_TRIGGER_LOW		deprecated_irq_flag(IRQF_TRIGGER_LOW)
-#define SA_TRIGGER_HIGH		deprecated_irq_flag(IRQF_TRIGGER_HIGH)
-#define SA_TRIGGER_FALLING	deprecated_irq_flag(IRQF_TRIGGER_FALLING)
-#define SA_TRIGGER_RISING	deprecated_irq_flag(IRQF_TRIGGER_RISING)
-#define SA_TRIGGER_MASK		deprecated_irq_flag(IRQF_TRIGGER_MASK)
-
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 struct irqaction {
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
