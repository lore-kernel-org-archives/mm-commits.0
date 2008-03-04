From: akpm@linux-foundation.org
Subject: + m68knommu-declare-do_irq.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:33:40 -0800
Message-ID: <200803040933.m249XeYd001530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbYCDJep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: declare do_IRQ()
has been added to the -mm tree.  Its filename is
     m68knommu-declare-do_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: declare do_IRQ()
From: Greg Ungerer <gerg@snapgear.com>

Need a declaration of do_IRQ for the 68328 interrupt handling code.
It is common to all m68knommu targets, so a common declaration makes
sense.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/machdep.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-m68knommu/machdep.h~m68knommu-declare-do_irq include/asm-m68knommu/machdep.h
--- a/include/asm-m68knommu/machdep.h~m68knommu-declare-do_irq
+++ a/include/asm-m68knommu/machdep.h
@@ -21,4 +21,6 @@ extern void (*mach_power_off)( void );
 
 extern void config_BSP(char *command, int len);
 
+extern void do_IRQ(int irq, struct pt_regs *fp);
+
 #endif /* _M68KNOMMU_MACHDEP_H */
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-update-defconfig.patch
m68knommu-remove-duplicate-hw_tick-code.patch
m68knommu-declare-do_irq.patch
m68knommu-fix-fec-driver-interrupt-races.patch

