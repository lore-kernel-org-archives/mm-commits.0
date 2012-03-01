From: akpm@linux-foundation.org
Subject: + procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch added to -mm tree
Date: Thu, 01 Mar 2012 15:18:09 -0800
Message-ID: <20120301231809.E0D4BA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61663 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2CAXSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 18:18:11 -0500
Received: by yenq2 with SMTP id q2so153405yen.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 15:18:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, jamie@shareable.org, kosaki.motohiro@gmail.com, mpm@selenic.com, oleg@redhat.com, siddhesh.poyarekar@gmail.com, vapier@gentoo.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: procfs-mark-stack-vma-with-pid-of-the-owning-task-fix
has been added to the -mm tree.  Its filename is
     procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch

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
Subject: procfs-mark-stack-vma-with-pid-of-the-owning-task-fix

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   45 ++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task-fix
+++ a/fs/proc/task_mmu.c
@@ -222,6 +222,7 @@ show_map_vma(struct seq_file *m, struct 
 	unsigned long start, end;
 	dev_t dev = 0;
 	int len;
+	const char *name;
 
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
@@ -255,31 +256,33 @@ show_map_vma(struct seq_file *m, struct 
 	if (file) {
 		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "\n");
-	} else {
-		const char *name = arch_vma_name(vma);
-		if (!name) {
-			if (mm) {
-				if (vma->vm_start <= mm->brk &&
-						vma->vm_end >= mm->start_brk) {
-					name = "[heap]";
-				} else {
-					pid_t tid =
-						vm_is_stack(task, vma, is_pid);
-					if (tid != 0) {
-						pad_len_spaces(m, len);
-						seq_printf(m, "[stack:%d]",
-								tid);
-					}
-				}
+		goto out;
+	}
+
+	name = arch_vma_name(vma);
+	if (!name) {
+		if (mm) {
+			if (vma->vm_start <= mm->brk &&
+					vma->vm_end >= mm->start_brk) {
+				name = "[heap]";
 			} else {
-				name = "[vdso]";
+				pid_t tid;
+
+				tid = vm_is_stack(task, vma, is_pid);
+				if (tid != 0) {
+					pad_len_spaces(m, len);
+					seq_printf(m, "[stack:%d]", tid);
+				}
 			}
-		}
-		if (name) {
-			pad_len_spaces(m, len);
-			seq_puts(m, name);
+		} else {
+			name = "[vdso]";
 		}
 	}
+	if (name) {
+		pad_len_spaces(m, len);
+		seq_puts(m, name);
+	}
+out:
 	seq_putc(m, '\n');
 }
 
_
Subject: Subject: procfs-mark-stack-vma-with-pid-of-the-owning-task-fix

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
drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
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
procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch
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

