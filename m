From: akpm@linux-foundation.org
Subject: - block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:35:05 -0700
Message-ID: <200807250035.m6P0Z6dH014493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbYGYAfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, draconux@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block-ioctlc-and-fs-partition-checkc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch

This patch was dropped because it was folded into block-ioctlc-and-fs-partition-checkc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block-ioctlc-and-fs-partition-checkc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#30: FILE: block/ioctl.c:65:
+			err = add_partition(disk, part, start, length, ADDPART_FLAG_NONE);

WARNING: printk() should include KERN_ facility level
#48: FILE: fs/partitions/check.c:508:
+			printk(" %s: p%d could not be added. got error %d\n",

total: 0 errors, 2 warnings, 33 lines checked

./patches/block-ioctlc-and-fs-partition-checkc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/partitions/check.c~block-ioctlc-and-fs-partition-checkc-checkpatch-fixes fs/partitions/check.c
--- a/fs/partitions/check.c~block-ioctlc-and-fs-partition-checkc-checkpatch-fixes
+++ a/fs/partitions/check.c
@@ -499,13 +499,13 @@ int rescan_partitions(struct gendisk *di
 		if (!size)
 			continue;
 		if (from + size > get_capacity(disk)) {
-			printk(" %s: p%d exceeds device capacity\n",
+			printk(KERN_ERR " %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
 			continue;
 		}
 		res = add_partition(disk, p, from, size, state->parts[p].flags);
 		if (res) {
-			printk(" %s: p%d could not be added. got error %d\n",
+			printk(KERN_ERR " %s: p%d could not be added: %d\n",
 				disk->disk_name, p, -res);
 			continue;
 		}
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
workqueues-make-get_online_cpus-useable-for-work-func.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-rewrite-undo-list-locking.patch
fs-partition-checkc-fix-return-value-warning.patch
block-ioctlc-and-fs-partition-checkc.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

