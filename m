From: akpm@linux-foundation.org
Subject: - gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:15:08 -0700
Message-ID: <200807250015.m6P0F8sk013567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYGYAPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, mb@bu3sch.de, mchehab@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup
has been removed from the -mm tree.  Its filename was
     gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch

This patch was dropped because it was folded into gpio-add-bt8xxgpio-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Be conventional.

Cc: David Brownell <david-b@pacbell.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/bt8xxgpio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/bt8xxgpio.c~gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup drivers/gpio/bt8xxgpio.c
--- a/drivers/gpio/bt8xxgpio.c~gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup
+++ a/drivers/gpio/bt8xxgpio.c
@@ -308,6 +308,9 @@ static int bt8xxgpio_resume(struct pci_d
 
 	return 0;
 }
+#else
+#define bt8xxgpio_suspend NULL
+#define bt8xxgpio_resume NULL
 #endif /* CONFIG_PM */
 
 static struct pci_device_id bt8xxgpio_pci_tbl[] = {
@@ -324,10 +327,8 @@ static struct pci_driver bt8xxgpio_pci_d
 	.id_table	= bt8xxgpio_pci_tbl,
 	.probe		= bt8xxgpio_probe,
 	.remove		= bt8xxgpio_remove,
-#ifdef CONFIG_PM
 	.suspend	= bt8xxgpio_suspend,
 	.resume		= bt8xxgpio_resume,
-#endif
 };
 
 static int bt8xxgpio_init(void)
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

