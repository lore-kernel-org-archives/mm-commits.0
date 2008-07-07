From: akpm@linux-foundation.org
Subject: - cpumask-introduce-new-apis.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:23 -0700
Message-ID: <200807070305.m6735N2e004815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbYGGDFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpumask: introduce new APIs
has been removed from the -mm tree.  Its filename was
     cpumask-introduce-new-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: introduce new APIs
From: Stephen Rothwell <sfr@canb.auug.org.au>

In linux-next there is a commit ("x86: Add performance variants of cpumask
operators") which, as part of the 4096 cpu support work adds some new APIs
for dealing with cpu masks.  Add trivial versions of these now so that
subsystems can update in a timely manner and avoid conflicts in linux-next
and the next merge window.

Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/cpumask.h~cpumask-introduce-new-apis include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-introduce-new-apis
+++ a/include/linux/cpumask.h
@@ -353,6 +353,10 @@ static inline void __cpus_fold(cpumask_t
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
 #endif /* NR_CPUS */
 
+#define next_cpu_nr(n, src)		next_cpu(n, src)
+#define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
+#define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+
 /*
  * The following particular system cpumasks and operations manage
  * possible, present and online cpus.  Each of them is a fixed size
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

revert-introduce-rculisth.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch

