From: akpm@linux-foundation.org
Subject: + mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:17:11 -0700
Message-ID: <20120620221711.DE0DDA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35868 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab2FTWRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:17:14 -0400
Received: by eeit10 with SMTP id t10so445006eei.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:17:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
has been added to the -mm tree.  Its filename is
     mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

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
Subject: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"

arch/mn10300/kernel/irq.c:173:7: warning: "CONFIG_MN10300_TTYSM1_TIMER9" is not defined [-Wundef]
arch/mn10300/kernel/irq.c:175:7: warning: "CONFIG_MN10300_TTYSM1_TIMER3" is not defined [-Wundef]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mn10300/kernel/irq.c~mn10300-use-elif-definedconfig_-instead-of-elif-config_ arch/mn10300/kernel/irq.c
--- a/arch/mn10300/kernel/irq.c~mn10300-use-elif-definedconfig_-instead-of-elif-config_
+++ a/arch/mn10300/kernel/irq.c
@@ -170,9 +170,9 @@ mn10300_cpupic_setaffinity(struct irq_da
 	case SC1TXIRQ:
 #ifdef CONFIG_MN10300_TTYSM1_TIMER12
 	case TM12IRQ:
-#elif CONFIG_MN10300_TTYSM1_TIMER9
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER9)
 	case TM9IRQ:
-#elif CONFIG_MN10300_TTYSM1_TIMER3
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER3)
 	case TM3IRQ:
 #endif /* CONFIG_MN10300_TTYSM1_TIMER12 */
 #endif /* CONFIG_MN10300_TTYSM1 */
_
Subject: Subject: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
xtensa-replace-xtensa-specific-_fdatatext-by-_sdatatext.patch
xtensa-use-test-e-instead-of-bashism-test-a.patch
xtensa-use-the-declarations-provided-by-asm-sectionsh.patch
h8300-fix-use-of-extinct-_sbss-and-_ebss.patch
h8300-use-the-declarations-provided-by-asm-sectionsh.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

