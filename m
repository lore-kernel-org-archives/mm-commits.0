From: akpm@linux-foundation.org
Subject: + pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch added to -mm tree
Date: Thu, 02 Feb 2012 16:10:56 -0800
Message-ID: <20120203001056.D5CB9A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44049 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2BCAK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 19:10:59 -0500
Received: by wicr5 with SMTP id r5so123179wic.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 16:10:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mtk.manpages@gmail.com, oleg@redhat.com, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
has been added to the -mm tree.  Its filename is
     pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch

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
Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix

tweak and add comments

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    2 +-
 kernel/sys.c                  |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/pid_namespace.h~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
+++ a/include/linux/pid_namespace.h
@@ -32,7 +32,7 @@ struct pid_namespace {
 #endif
 	gid_t pid_gid;
 	int hide_pid;
-	int reboot;
+	int reboot;	/* group exit code if this pidns was rebooted */
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN kernel/sys.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix kernel/sys.c
--- a/kernel/sys.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
+++ a/kernel/sys.c
@@ -444,9 +444,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	                magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
-	/* In case the pid namespaces are enabled, the current task is in a
-	 * child pid_namespace and the command is handled by 'reboot_pid_ns',
-	 * this one will invoke 'do_exit'.
+	/*
+	 * If pid namespaces are enabled and the current task is in a child
+	 * pid_namespace, the command is handled by reboot_pid_ns() which will
+	 * call do_exit().
 	 */
 	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
 	if (ret)
_
Subject: Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-cpufreq-gx-suspmodc-fix-build.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
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
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

