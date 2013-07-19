From: akpm@linux-foundation.org
Subject: +
 initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch added to -mm tree
Date: Fri, 19 Jul 2013 12:58:53 -0700
Message-ID: <51e99a7d.6zpmxwsTmS2DTsbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3GST6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:58:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, akpm@linux-foundation.org

Subject: + initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:58:53 -0700


The patch titled
     Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#56: FILE: init/do_mounts.c:623:
+	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
+	{

total: 1 errors, 0 warnings, 36 lines checked

./patches/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes init/do_mounts.c
--- a/init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes
+++ a/init/do_mounts.c
@@ -621,12 +621,12 @@ int __init init_rootfs(void)
 		return err;
 
 	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
-		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
-	{
+		(!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
 		err = shmem_init();
 		is_tmpfs = true;
-	} else
+	} else {
 		err = init_ramfs_fs();
+	}
 
 	if (err)
 		unregister_filesystem(&rootfs_fs_type);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

