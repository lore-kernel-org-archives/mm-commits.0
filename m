From: akpm@linux-foundation.org
Subject: + coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch added to -mm tree
Date: Thu, 08 Mar 2012 15:06:31 -0800
Message-ID: <20120308230631.EF332A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:36793 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2CHXGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 18:06:34 -0500
Received: by wgbdt11 with SMTP id dt11so35526wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 15:06:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com, jbaron@redhat.com, roland@hack.frob.com


The patch titled
     Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
has been added to the -mm tree.  Its filename is
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch

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
Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix

s/MADV_NODUMP/MADV_DONTDUMP/, s/MADV_CLEAR_NODUMP/MADV_DODUMP/, per Roland

Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/mman-common.h |    4 ++--
 mm/madvise.c                      |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
+++ a/include/asm-generic/mman-common.h
@@ -48,9 +48,9 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
-#define MADV_NODUMP 16			/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
-#define MADV_CLEAR_NODUMP 17		/* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix mm/madvise.c
--- a/mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
+++ a/mm/madvise.c
@@ -65,10 +65,10 @@ static long madvise_behavior(struct vm_a
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
-	case MADV_NODUMP:
+	case MADV_DONTDUMP:
 		new_flags |= VM_NODUMP;
 		break;
-	case MADV_CLEAR_NODUMP:
+	case MADV_DODUMP:
 		new_flags &= ~VM_NODUMP;
 		break;
 	case MADV_MERGEABLE:
@@ -299,8 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
-	case MADV_NODUMP:
-	case MADV_CLEAR_NODUMP:
+	case MADV_DONTDUMP:
+	case MADV_DODUMP:
 		return 1;
 
 	default:
_
Subject: Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

