From: akpm@linux-foundation.org
Subject: - jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:16:13 -0700
Message-ID: <200807250016.m6P0GD2H013609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYGYAVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmm@us.ibm.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fix
has been removed from the -mm tree.  Its filename was
     jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into jbd-fix-race-between-free-buffer-and-commit-trasanction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jan Kara <jack@suse.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix
+++ a/fs/jbd/transaction.c
@@ -1650,14 +1650,14 @@ out:
 
 /*
  * journal_try_to_free_buffers() could race with journal_commit_transaction()
- * The later might still hold the reference count to the buffers when inspecting
+ * The latter might still hold the a count on buffers when inspecting
  * them on t_syncdata_list or t_locked_list.
  *
- * Journal_try_to_free_buffers() will call this function to
+ * journal_try_to_free_buffers() will call this function to
  * wait for the current transaction to finish syncing data buffers, before
- * try to free that buffer.
+ * tryinf to free that buffer.
  *
- * Called with journal->j_state_lock hold.
+ * Called with journal->j_state_lock held.
  */
 static void journal_wait_for_transaction_sync_data(journal_t *journal)
 {
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

