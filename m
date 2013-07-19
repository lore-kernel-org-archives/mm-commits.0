From: akpm@linux-foundation.org
Subject: +
 initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch added to
 -mm tree
Date: Fri, 19 Jul 2013 12:57:49 -0700
Message-ID: <51e99a3d.GhmyKJ0PwaKhTr8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3GST5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, rob@landley.net, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, akpm@linux-foundation.org

Subject: + initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch added to -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rob@landley.net,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:57:49 -0700


The patch titled
     Subject: initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix
has been added to the -mm tree.  Its filename is
     initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch

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
Subject: initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix

using bit 1 was odd

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix
+++ a/fs/ramfs/inode.c
@@ -249,7 +249,7 @@ static struct dentry *rootfs_mount(struc
 {
 	static unsigned long once;
 
-	if (test_and_set_bit(1, &once))
+	if (test_and_set_bit(0, &once))
 		return ERR_PTR(-ENODEV);
 
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
@@ -278,7 +278,7 @@ static int __init init_ramfs_fs(void)
 	static unsigned long once;
 	int err;
 
-	if (test_and_set_bit(1, &once))
+	if (test_and_set_bit(0, &once))
 		return 0;
 
 	err = bdi_init(&ramfs_backing_dev_info);
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

