From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-cleanup-introduce-ksm_check_mm-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2012 15:47:02 -0800
Message-ID: <20120306234702.74050A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61370 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:47:09 -0500
Received: by ggnd2 with SMTP id d2so713969ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:47:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, lliubbo@gmail.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-cleanup-introduce-ksm_check_mm-fix
has been removed from the -mm tree.  Its filename was
     ksm-cleanup-introduce-ksm_check_mm-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-cleanup-introduce-ksm_check_mm-fix

rename ksm_check_mm to in_mergeable_anon_vma(), make it return bool

Cc: Bob Liu <lliubbo@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>				
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm-fix mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm-fix
+++ a/mm/ksm.c
@@ -374,17 +374,17 @@ static int break_ksm(struct vm_area_stru
 	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
 }
 
-static int ksm_check_mm(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long addr)
+static bool in_mergeable_anon_vma(struct mm_struct *mm,
+				 struct vm_area_struct *vma, unsigned long addr)
 {
 	if (ksm_test_exit(mm))
-		return 0;
+		return false;
 	vma = find_vma(mm, addr);
 	if (!vma || vma->vm_start > addr)
-		return 0;
+		return false;
 	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static void break_cow(struct rmap_item *rmap_item)
@@ -400,7 +400,7 @@ static void break_cow(struct rmap_item *
 	put_anon_vma(rmap_item->anon_vma);
 
 	down_read(&mm->mmap_sem);
-	if (ksm_check_mm(mm, vma, addr))
+	if (in_mergeable_anon_vma(mm, vma, addr))
 		break_ksm(vma, addr);
 	up_read(&mm->mmap_sem);
 }
@@ -427,7 +427,7 @@ static struct page *get_mergeable_page(s
 	struct page *page;
 
 	down_read(&mm->mmap_sem);
-	if (!ksm_check_mm(mm, vma, addr))
+	if (!in_mergeable_anon_vma(mm, vma, addr))
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
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
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
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

