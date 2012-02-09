From: akpm@linux-foundation.org
Subject: + smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch added to -mm tree
Date: Wed, 08 Feb 2012 16:03:59 -0800
Message-ID: <20120209000400.258F4A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:36248 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab2BIAED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 19:04:03 -0500
Received: by faaa19 with SMTP id a19so35330faa.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 16:04:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gilad@benyossef.com, mina86@mina86.com, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
has been added to the -mm tree.  Its filename is
     smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch

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
Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix

- avoid double-evaluation of `info' (per Michal)
- parenthesise evaluation of `cond_func'

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
+++ a/include/linux/smp.h
@@ -168,10 +168,11 @@ static inline int up_smp_call_function(s
  */
 #define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
 	do {							\
+		void *__info = (info);				\
 		preempt_disable();				\
-		if (cond_func(0, info)) {			\
+		if ((cond_func)(0, __info)) {			\
 			local_irq_disable();			\
-			(func)(info);				\
+			(func)(__info);				\
 			local_irq_enable();			\
 		}						\
 		preempt_enable();				\
_
Subject: Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
fs-btrfs-inode-mapc-fix-warnings.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

