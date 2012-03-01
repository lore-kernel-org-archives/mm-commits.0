From: akpm@linux-foundation.org
Subject: + ksm-cleanup-introduce-ksm_check_mm-fix.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:51:36 -0800
Message-ID: <20120301205137.24DE1A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42104 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2CAUvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:51:38 -0500
Received: by mail-we0-f202.google.com with SMTP id x9so40269wej.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:51:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hughd@google.com, kamezawa.hiroyuki@gmail.com, lliubbo@gmail.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: ksm-cleanup-introduce-ksm_check_mm-fix
has been added to the -mm tree.  Its filename is
     ksm-cleanup-introduce-ksm_check_mm-fix.patch

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
Subject: ksm-cleanup-introduce-ksm_check_mm-fix

rename ksm_check_mm to in_mergeable_anon_vma(), make it return bool

Cc: Bob Liu <lliubbo@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm-fix mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-introduce-ksm_check_mm-fix
+++ a/mm/ksm.c
@@ -375,17 +375,17 @@ static int break_ksm(struct vm_area_stru
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
@@ -401,7 +401,7 @@ static void break_cow(struct rmap_item *
 	put_anon_vma(rmap_item->anon_vma);
 
 	down_read(&mm->mmap_sem);
-	if (ksm_check_mm(mm, vma, addr))
+	if (in_mergeable_anon_vma(mm, vma, addr))
 		break_ksm(vma, addr);
 	up_read(&mm->mmap_sem);
 }
@@ -428,7 +428,7 @@ static struct page *get_mergeable_page(s
 	struct page *page;
 
 	down_read(&mm->mmap_sem);
-	if (!ksm_check_mm(mm, vma, addr))
+	if (!in_mergeable_anon_vma(mm, vma, addr))
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
_
Subject: Subject: ksm-cleanup-introduce-ksm_check_mm-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
percpu-remove-percpu_xxx-functions-fix.patch
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

