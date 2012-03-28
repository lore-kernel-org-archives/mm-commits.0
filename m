From: akpm@linux-foundation.org
Subject: [folded] pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:32:41 -0700
Message-ID: <20120328213242.1EC60A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:49076 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:32:43 -0400
Received: by yhgm50 with SMTP id m50so192565yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:32:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mtk.manpages@gmail.com, oleg@redhat.com, serge.hallyn@canonical.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
has been removed from the -mm tree.  Its filename was
     pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch

This patch was dropped because it was folded into pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -33,7 +33,7 @@ struct pid_namespace {
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

