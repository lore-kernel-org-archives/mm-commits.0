From: akpm@linux-foundation.org
Subject: [merged] mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:28 -0700
Message-ID: <20120712193629.082D320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62141 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2GLTgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:31 -0400
Received: by bkcjc3 with SMTP id jc3so145577bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
has been removed from the -mm tree.  Its filename was
     mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

