From: akpm@linux-foundation.org
Subject: - m68knommu-declare-do_irq.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:57 -0800
Message-ID: <200803042009.m24K9vcZ026799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933364AbYCDUKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: declare do_IRQ()
has been removed from the -mm tree.  Its filename was
     m68knommu-declare-do_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

