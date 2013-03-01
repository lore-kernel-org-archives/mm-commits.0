From: akpm@linux-foundation.org
Subject: + shmem-fix-build-regression-fix.patch added to -mm tree
Date: Thu, 28 Feb 2013 16:31:39 -0800
Message-ID: <20130301003139.DB3075A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:50335 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3CAAbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 19:31:41 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so277168qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 16:31:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, wsa@the-dreams.de


The patch titled
     Subject: shmem-fix-build-regression-fix
has been added to the -mm tree.  Its filename is
     shmem-fix-build-regression-fix.patch

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
Subject: shmem-fix-build-regression-fix

avoid CONFIG_MMU=y warning, nuke the ifdefs

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ramfs.h |    8 +++++++-
 mm/shmem.c            |   12 ++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/ramfs.h~shmem-fix-build-regression-fix include/linux/ramfs.h
--- a/include/linux/ramfs.h~shmem-fix-build-regression-fix
+++ a/include/linux/ramfs.h
@@ -6,7 +6,13 @@ struct inode *ramfs_get_inode(struct sup
 extern struct dentry *ramfs_mount(struct file_system_type *fs_type,
 	 int flags, const char *dev_name, void *data);
 
-#ifndef CONFIG_MMU
+#ifdef CONFIG_MMU
+static inline int
+ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
+{
+	return 0;
+}
+#else
 extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long addr,
diff -puN mm/shmem.c~shmem-fix-build-regression-fix mm/shmem.c
--- a/mm/shmem.c~shmem-fix-build-regression-fix
+++ a/mm/shmem.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/ramfs.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/mm.h>
@@ -2830,8 +2831,6 @@ out4:
  * effectively equivalent, but much lighter weight.
  */
 
-#include <linux/ramfs.h>
-
 static struct file_system_type shmem_fs_type = {
 	.name		= "tmpfs",
 	.mount		= ramfs_mount,
@@ -2897,7 +2896,6 @@ static struct dentry_operations anon_ops
  */
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
-	int error;
 	struct file *res;
 	struct inode *inode;
 	struct path path;
@@ -2932,12 +2930,10 @@ struct file *shmem_file_setup(const char
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
 	clear_nlink(inode);	/* It is unlinked */
-#ifndef CONFIG_MMU
-	error = ramfs_nommu_expand_for_mapping(inode, size);
-	res = ERR_PTR(error);
-	if (error)
+
+	res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
+	if (IS_ERR(res))
 		goto put_dentry;
-#endif
 
 	res = alloc_file(&path, FMODE_WRITE | FMODE_READ,
 		  &shmem_file_operations);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
shmem-fix-build-regression-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

