From: akpm@linux-foundation.org
Subject: +
 powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch added to -mm tree
Date: Fri, 16 Jun 2017 11:26:54 -0700
Message-ID: <594422ee.J38VRxNpuDm5wWUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbdFPS1A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -359,7 +359,7 @@ static int __init powerpc_watchdog_init(
 	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "powerpc/watchdog:online",
 				start_wd_on_cpu, stop_wd_on_cpu);
 	if (err < 0)
-		pr_warning("Watchdog could not be initialized");
+		pr_warn("Watchdog could not be initialized");
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
fs-introduce-filemap_range_has_page-fix.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

