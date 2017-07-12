From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:19:59 -0700
Message-ID: <5966927f.PaN/ujHoWSUkitv4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753539AbdGLVUA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch

This patch was dropped because it was folded into powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes

WARNING: line over 80 characters
#97: FILE: arch/powerpc/include/asm/smp.h:59:
+extern int smp_send_nmi_ipi(int cpu, void (*fn)(struct pt_regs *), u64 delay_us);

WARNING: line over 80 characters
#119: FILE: arch/powerpc/kernel/exceptions-64s.S:1276:
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) && defined(CONFIG_HAVE_HARDLOCKUP_DETECTOR_ARCH)

ERROR: do not initialise statics to 0
#317: FILE: arch/powerpc/kernel/watchdog.c:62:
+static unsigned long __wd_smp_lock = 0;

WARNING: memory barrier without comment
#554: FILE: arch/powerpc/kernel/watchdog.c:299:
+	smp_wmb();

WARNING: Prefer pr_warn(... to pr_warning(...
#617: FILE: arch/powerpc/kernel/watchdog.c:362:
+		pr_warning("Watchdog could not be initialized");

total: 1 errors, 4 warnings, 543 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes arch/powerpc/kernel/watchdog.c
--- a/arch/powerpc/kernel/watchdog.c~powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes
+++ a/arch/powerpc/kernel/watchdog.c
@@ -59,7 +59,7 @@ static DEFINE_PER_CPU(u64, wd_timer_tb);
  * This will work best with NMI IPIs for crash code so the stuck CPUs
  * can be pulled out to get their backtraces.
  */
-static unsigned long __wd_smp_lock = 0;
+static unsigned long __wd_smp_lock;
 static cpumask_t wd_smp_cpus_pending;
 static cpumask_t wd_smp_cpus_stuck;
 static u64 wd_smp_last_reset_tb;
@@ -357,7 +357,7 @@ static int __init powerpc_watchdog_init(
 	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "powerpc/watchdog:online",
 				start_wd_on_cpu, stop_wd_on_cpu);
 	if (err < 0)
-		pr_warning("Watchdog could not be initialized");
+		pr_warn("Watchdog could not be initialized");
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch

