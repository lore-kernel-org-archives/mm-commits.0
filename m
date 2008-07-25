From: akpm@linux-foundation.org
Subject: - edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:37:18 -0700
Message-ID: <200807250037.m6P0bIKX014626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbYGYAhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

This patch was dropped because it was folded into edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#42: FILE: drivers/edac/mpc85xx_edac.c:216:
+ ^Idev_set_drvdata(&op->dev, pci);$

ERROR: code indent should use tabs where possible
#43: FILE: drivers/edac/mpc85xx_edac.c:217:
+ ^Ipci->dev = &op->dev;$

ERROR: code indent should use tabs where possible
#69: FILE: drivers/edac/mpc85xx_edac.c:238:
+ ^I^I^I^I     r.end - r.start + 1, pdata->name)) {$

total: 3 errors, 0 warnings, 154 lines checked

./patches/edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Jiang <djiang@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes
+++ a/drivers/edac/mpc85xx_edac.c
@@ -213,8 +213,8 @@ static int __devinit mpc85xx_pci_err_pro
 	pdata = pci->pvt_info;
 	pdata->name = "mpc85xx_pci_err";
 	pdata->irq = NO_IRQ;
- 	dev_set_drvdata(&op->dev, pci);
- 	pci->dev = &op->dev;
+	dev_set_drvdata(&op->dev, pci);
+	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
 	pci->dev_name = op->dev.bus_id;
@@ -235,7 +235,7 @@ static int __devinit mpc85xx_pci_err_pro
 	r.start += 0xe00;
 
 	if (!devm_request_mem_region(&op->dev, r.start,
- 				     r.end - r.start + 1, pdata->name)) {
+					r.end - r.start + 1, pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
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
edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

