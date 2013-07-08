From: akpm@linux-foundation.org
Subject: +
 revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch added to -mm tree
Date: Mon, 08 Jul 2013 11:51:55 -0700
Message-ID: <51db0a4b.cyQ9I2VpZ5bQ5Yb4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3GHSv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 14:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, david.daney@cavium.com, akpm@linux-foundation.org

Subject: + revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch added to -mm tree
To: akpm@linux-foundation.org,david.daney@cavium.com,geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 11:51:54 -0700


The patch titled
     Subject: include/linux/smp.h:on_each_cpu(): switch back to a C function
has been added to the -mm tree.  Its filename is
     revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch

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
Subject: include/linux/smp.h:on_each_cpu(): switch back to a C function

Revert c846ef7deba2d4f751 ("include/linux/smp.h:on_each_cpu(): switch back
to a macro").  It turns out that the problematic linux/irqflags.h include
was fixed within ia64 and mn10300.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <david.daney@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN include/linux/smp.h~revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro include/linux/smp.h
--- a/include/linux/smp.h~revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro
+++ a/include/linux/smp.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -139,14 +140,17 @@ static inline int up_smp_call_function(s
 }
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-#define on_each_cpu(func, info, wait)		\
-	({					\
-		unsigned long __flags;		\
-		local_irq_save(__flags);	\
-		func(info);			\
-		local_irq_restore(__flags);	\
-		0;				\
-	})
+
+static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
dump_stack-serialize-the-output-from-dump_stack.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
dev-oldmem-remove-the-interface.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch

