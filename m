From: akpm@linux-foundation.org
Subject: + m68k-coldfire-move-inline-before-return-type.patch added to -mm tree
Date: Wed, 05 Jul 2017 13:45:18 -0700
Message-ID: <595d4fde.HwQBZV+lbogMbL8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbdGEUpY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, gerg@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: coldfire: move inline before return type
has been added to the -mm tree.  Its filename is
     m68k-coldfire-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-coldfire-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-coldfire-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: m68k: coldfire: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/14db9c166d5b68efa77e337cfe49bb9b29bca3f7.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/coldfire/intc-simr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m68k/coldfire/intc-simr.c~m68k-coldfire-move-inline-before-return-type arch/m68k/coldfire/intc-simr.c
--- a/arch/m68k/coldfire/intc-simr.c~m68k-coldfire-move-inline-before-return-type
+++ a/arch/m68k/coldfire/intc-simr.c
@@ -35,7 +35,7 @@
 #define	EINT7	67	/* EDGE Port interrupt 7 */
 
 static unsigned int irqebitmap[] = { 0, 1, 4, 7 };
-static unsigned int inline irq2ebit(unsigned int irq)
+static inline unsigned int irq2ebit(unsigned int irq)
 {
 	return irqebitmap[irq - EINT0];
 }
@@ -51,7 +51,7 @@ static unsigned int inline irq2ebit(unsi
 #define	EINT1	65	/* EDGE Port interrupt 1 */
 #define	EINT7	71	/* EDGE Port interrupt 7 */
 
-static unsigned int inline irq2ebit(unsigned int irq)
+static inline unsigned int irq2ebit(unsigned int irq)
 {
 	return irq - EINT0;
 }
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

