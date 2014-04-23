From: akpm@linux-foundation.org
Subject: +
 kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
 added to -mm tree
Date: Wed, 23 Apr 2014 14:14:15 -0700
Message-ID: <53582d27.pFCDt5RkOQroUp0+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaDWVOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 17:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, mguzik@redhat.com, dzickus@redhat.com, davem@davemloft.net, atomlin@redhat.com, akpm@linux-foundation.org

Subject: + kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch added to -mm tree
To: akpm@linux-foundation.org,atomlin@redhat.com,davem@davemloft.net,dzickus@redhat.com,mguzik@redhat.com,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 14:14:15 -0700


The patch titled
     Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch

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
Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix

additional CONFIG_SMP=n optimisations

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 --
 kernel/watchdog.c   |    5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/nmi.h~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix include/linux/nmi.h
--- a/include/linux/nmi.h~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
+++ a/include/linux/nmi.h
@@ -57,9 +57,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
-#ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
-#endif
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
diff -puN kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
+++ a/kernel/watchdog.c
@@ -31,7 +31,12 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+#ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
+#else
+#define sysctl_softlockup_all_cpu_backtrace 0
+#endif
+
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
sysrq-rcu-ify-__handle_sysrq-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

