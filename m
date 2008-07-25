From: akpm@linux-foundation.org
Subject: - lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:10:22 -0700
Message-ID: <200807250010.m6P0AMqn013359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYGYAKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: consider using strict_strtoull in preference to simple_strtoull
#42: FILE: lib/cmdline.c:133:
+	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);

WARNING: braces {} are not necessary for single statement blocks
#58: FILE: lib/cmdline.c:150:
+	if (retptr) {
+		*retptr = endptr;
+	}

total: 0 errors, 2 warnings, 37 lines checked

./patches/lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes lib/cmdline.c
--- a/lib/cmdline.c~lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes
+++ a/lib/cmdline.c
@@ -126,7 +126,7 @@ char *get_options(const char *str, int n
  *	megabyte, or one gigabyte, respectively.
  */
 
-unsigned long long memparse (char *ptr, char **retptr)
+unsigned long long memparse(char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
 
@@ -147,9 +147,8 @@ unsigned long long memparse (char *ptr, 
 		break;
 	}
 
-	if (retptr) {
+	if (retptr)
 		*retptr = endptr;
-	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

