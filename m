From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
 removed from -mm tree
Date: Mon, 23 Jun 2014 13:10:14 -0700
Message-ID: <53a889a6.LJYFpQL7R6y6it/1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, mguzik@redhat.com, dzickus@redhat.com, davem@davemloft.net, atomlin@redhat.com, akpm@linux-foundation.org


The patch titled
     Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch

This patch was dropped because it was folded into kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch

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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

