From: akpm@linux-foundation.org
Subject: - coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:31:25 -0700
Message-ID: <200807250031.m6P0VPU7014309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYGYAbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch

This patch was dropped because it was folded into coredump-format_corename-fix-the-core_uses_pid-logic.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#50: FILE: fs/exec.c:1490:
+            && (core_uses_pid || nr_threads)) {$

total: 1 errors, 0 warnings, 36 lines checked

./patches/coredump-format_corename-fix-the-core_uses_pid-logic.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes
+++ a/fs/exec.c
@@ -1487,7 +1487,7 @@ static int format_corename(char *corenam
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern
-            && (core_uses_pid || nr_threads)) {
+	    && (core_uses_pid || nr_threads)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
devcgroup-code-cleanup.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-limit-change-shrink-usage.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

