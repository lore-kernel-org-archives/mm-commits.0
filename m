From: akpm@linux-foundation.org
Subject: - pm-fix-compiler-error-of-ppc-dart_iommu.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:15 -0700
Message-ID: <200707290611.l6T6BF2X010971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274AbXG2GLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: fix compiler error of PPC dart_iommu
has been removed from the -mm tree.  Its filename was
     pm-fix-compiler-error-of-ppc-dart_iommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: fix compiler error of PPC dart_iommu
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

A dummy inline function of register_nosave_region_late was accidentally
removed by the recent PM patch that introduced suspend notifiers.
This elimination causes the following compiler error on PPC machines.

  CC      arch/powerpc/sysdev/dart_iommu.o
arch/powerpc/sysdev/dart_iommu.c: In function 'iommu_init_late_dart':
arch/powerpc/sysdev/dart_iommu.c:376: error: implicit declaration of function
'register_nosave_region_late'
make[1]: *** [arch/powerpc/sysdev/dart_iommu.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2

This patch fixes the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/suspend.h~pm-fix-compiler-error-of-ppc-dart_iommu include/linux/suspend.h
--- a/include/linux/suspend.h~pm-fix-compiler-error-of-ppc-dart_iommu
+++ a/include/linux/suspend.h
@@ -125,6 +125,9 @@ static inline int unregister_pm_notifier
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
 }
+static inline void register_nosave_region_late(unsigned long b, unsigned long e)
+{
+}
 #endif
 
 #endif /* _LINUX_SWSUSP_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch
