From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 11 May 2020 11:44:56 -0700
Message-ID: <20200511184456.acTo0ot6O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbgEKSo4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 14:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c |    8 --------
 fs/splice.c       |    9 ---------
 2 files changed, 17 deletions(-)

--- a/drivers/base/dd.c~linux-next-git-rejects
+++ a/drivers/base/dd.c
@@ -259,11 +259,7 @@ int driver_deferred_probe_check_state(st
 	}
 
 	if (!driver_deferred_probe_timeout && initcalls_done) {
-<<<<<<< HEAD
-		dev_warn(dev, "deferred probe timeout, ignoring dependency");
-=======
 		dev_warn(dev, "deferred probe timeout, ignoring dependency\n");
->>>>>>> linux-next/akpm-base
 		return -ETIMEDOUT;
 	}
 
@@ -279,11 +275,7 @@ static void deferred_probe_timeout_work_
 	flush_work(&deferred_probe_work);
 
 	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-<<<<<<< HEAD
-		dev_info(private->device, "deferred probe pending");
-=======
 		dev_info(private->device, "deferred probe pending\n");
->>>>>>> linux-next/akpm-base
 	wake_up(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
--- a/fs/splice.c~linux-next-git-rejects
+++ a/fs/splice.c
@@ -1118,17 +1118,8 @@ long do_splice(struct file *in, loff_t _
 	loff_t offset;
 	long ret;
 
-<<<<<<< HEAD
-	if (unlikely(!(in->f_mode & FMODE_READ) ||
-		     !(out->f_mode & FMODE_WRITE)))
-		return -EBADF;
-
-	ipipe = get_pipe_info(in);
-	opipe = get_pipe_info(out);
-=======
 	ipipe = get_pipe_info(in, true);
 	opipe = get_pipe_info(out, true);
->>>>>>> linux-next/akpm-base
 
 	if (ipipe && opipe) {
 		if (off_in || off_out)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch
linux-next-rejects.patch
arch-x86-makefile-use-config_shell.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
