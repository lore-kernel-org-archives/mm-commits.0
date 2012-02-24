From: akpm@linux-foundation.org
Subject: + procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch added to -mm tree
Date: Fri, 24 Feb 2012 14:11:10 -0800
Message-ID: <20120224225427.C18545C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39733 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2BXWyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 17:54:31 -0500
Received: by werb13 with SMTP id b13so105064wer.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 14:54:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, jamie@shareable.org, kosaki.motohiro@gmail.com, mpm@selenic.com, siddhesh.poyarekar@gmail.com, vapier@gentoo.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix
has been added to the -mm tree.  Its filename is
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch

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
Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix

i386 allmodconfig.  Many instances of

In file included from include/linux/scatterlist.h:6,
                 from include/linux/dmaengine.h:26,
                 from include/linux/skbuff.h:30,
                 from include/crypto/algapi.h:18,
                 from arch/x86/crypto/serpent_sse2_glue.c:37:
include/linux/mm.h: In function 'vm_is_stack_for_task':
include/linux/mm.h:1047: error: implicit declaration of function 'task_stack_page'

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 -------
 mm/memory.c        |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix include/linux/mm.h
--- a/include/linux/mm.h~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix
+++ a/include/linux/mm.h
@@ -1040,13 +1040,6 @@ static inline int stack_guard_page_end(s
 		!vma_growsup(vma->vm_next, addr);
 }
 
-/* Check if the vma is being used as a stack by this task */
-static inline int vm_is_stack_for_task(struct task_struct *t,
-				       struct vm_area_struct *vma)
-{
-	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
-}
-
 extern int
 vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
 
diff -puN mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix mm/memory.c
--- a/mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix
+++ a/mm/memory.c
@@ -112,6 +112,13 @@ __setup("norandmaps", disable_randmaps);
 unsigned long zero_pfn __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
 
+/* Check if the vma is being used as a stack by this task */
+static int vm_is_stack_for_task(struct task_struct *t,
+				struct vm_area_struct *vma)
+{
+	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
+}
+
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
_
Subject: Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
ata-unbork.patch
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
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
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

