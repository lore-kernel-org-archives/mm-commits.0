From: akpm@linux-foundation.org
Subject: - fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:34:30 -0700
Message-ID: <200807250034.m6P0YUq2014476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbYGYAeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, draconux@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs-partition-checkc-fix-return-value-warning-v2-cleanup
has been removed from the -mm tree.  Its filename was
     fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch

This patch was dropped because it was folded into fs-partition-checkc-fix-return-value-warning.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-partition-checkc-fix-return-value-warning-v2-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

multiple-return-statements-per-function are evil ;)

Cc: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/partitions/check.c~fs-partition-checkc-fix-return-value-warning-v2-cleanup fs/partitions/check.c
--- a/fs/partitions/check.c~fs-partition-checkc-fix-return-value-warning-v2-cleanup
+++ a/fs/partitions/check.c
@@ -354,8 +354,8 @@ int add_partition(struct gendisk *disk, 
 		return -ENOMEM;
 
 	if (!init_part_stats(p)) {
-		kfree(p);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out0;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -400,6 +400,7 @@ out2:
 out1:
 	put_device(&p->dev);
 	free_part_stats(p);
+out0:
 	kfree(p);
 	return err;
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
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

