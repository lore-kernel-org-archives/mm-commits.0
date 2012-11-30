From: akpm@linux-foundation.org
Subject: [merged] proc-check-vma-vm_file-before-dereferencing.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:24 -0800
Message-ID: <20121130212824.AAED5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63186 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:25 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so103672qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, gorcunov@openvz.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: check vma->vm_file before dereferencing
has been removed from the -mm tree.  Its filename was
     proc-check-vma-vm_file-before-dereferencing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: proc: check vma->vm_file before dereferencing

7b540d0646ce ("proc_map_files_readdir(): don't bother with grabbing
files") switched proc_map_files_readdir() to use @f_mode directly instead
of grabbing @file reference, but same time the test for @vm_file presence
was lost leading to nil dereference.  The patch brings the test back.

The all proc_map_files feature is CONFIG_CHECKPOINT_RESTORE wrapped (which
is set to 'n' by default) so the bug doesn't affect regular kernels.

The regression is 3.7-rc1 only as far as I can tell.

[gorcunov@openvz.org: provided changelog]
Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-check-vma-vm_file-before-dereferencing fs/proc/base.c
--- a/fs/proc/base.c~proc-check-vma-vm_file-before-dereferencing
+++ a/fs/proc/base.c
@@ -1877,8 +1877,9 @@ static struct dentry *proc_map_files_loo
 	if (!vma)
 		goto out_no_vma;
 
-	result = proc_map_files_instantiate(dir, dentry, task,
-			(void *)(unsigned long)vma->vm_file->f_mode);
+	if (vma->vm_file)
+		result = proc_map_files_instantiate(dir, dentry, task,
+				(void *)(unsigned long)vma->vm_file->f_mode);
 
 out_no_vma:
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch
linux-next.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch
ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch
ipc-simplify-free_copy-call.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
ipc-simplify-message-copying.patch
ipc-add-more-comments-to-message-copying-related-code.patch

