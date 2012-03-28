From: akpm@linux-foundation.org
Subject: [folded] fs-hardlink-creation-restrictions-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 15:14:11 -0700
Message-ID: <20120328221411.5AE32A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44723 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2C1WOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 18:14:12 -0400
Received: by yenq2 with SMTP id q2so197162yen.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 15:14:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-hardlink-creation-restrictions-fix
has been removed from the -mm tree.  Its filename was
     fs-hardlink-creation-restrictions-fix.patch

This patch was dropped because it was folded into fs-hardlink-creation-restrictions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-hardlink-creation-restrictions-fix

uninline may_linkat() and audit_log_link_denied().

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/namei.c~fs-hardlink-creation-restrictions-fix fs/namei.c
--- a/fs/namei.c~fs-hardlink-creation-restrictions-fix
+++ a/fs/namei.c
@@ -629,8 +629,7 @@ int sysctl_protected_symlinks __read_mos
 int sysctl_protected_hardlinks __read_mostly =
 	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
 
-static inline void
-audit_log_link_denied(const char *operation, struct path *link)
+static void audit_log_link_denied(const char *operation, struct path *link)
 {
 	struct audit_buffer *ab;
 
@@ -709,7 +708,7 @@ static inline int may_follow_link(struct
  *
  * Returns 0 if successful, -ve on error.
  */
-static inline int may_linkat(struct path *link)
+static int may_linkat(struct path *link)
 {
 	int error = 0;
 	const struct cred *cred;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
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

