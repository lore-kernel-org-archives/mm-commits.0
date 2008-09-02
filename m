From: akpm@linux-foundation.org
Subject: - anondev-init-idr-statically.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:56 -0700
Message-ID: <200809022041.m82KfuIS011673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbYIBUl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     anondev: init IDR statically
has been removed from the -mm tree.  Its filename was
     anondev-init-idr-statically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: anondev: init IDR statically
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |    7 +------
 include/linux/fs.h |    1 -
 init/main.c        |    1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/super.c~anondev-init-idr-statically fs/super.c
--- a/fs/super.c~anondev-init-idr-statically
+++ a/fs/super.c
@@ -682,7 +682,7 @@ void emergency_remount(void)
  * filesystems which don't use real block-devices.  -- jrs
  */
 
-static struct idr unnamed_dev_idr;
+static DEFINE_IDR(unnamed_dev_idr);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
 
 int set_anon_super(struct super_block *s, void *data)
@@ -726,11 +726,6 @@ void kill_anon_super(struct super_block 
 
 EXPORT_SYMBOL(kill_anon_super);
 
-void __init unnamed_dev_init(void)
-{
-	idr_init(&unnamed_dev_idr);
-}
-
 void kill_litter_super(struct super_block *sb)
 {
 	if (sb->s_root)
diff -puN include/linux/fs.h~anondev-init-idr-statically include/linux/fs.h
--- a/include/linux/fs.h~anondev-init-idr-statically
+++ a/include/linux/fs.h
@@ -1568,7 +1568,6 @@ extern int get_sb_pseudo(struct file_sys
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
-void unnamed_dev_init(void);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
diff -puN init/main.c~anondev-init-idr-statically init/main.c
--- a/init/main.c~anondev-init-idr-statically
+++ a/init/main.c
@@ -686,7 +686,6 @@ asmlinkage void __init start_kernel(void
 	fork_init(num_physpages);
 	proc_caches_init();
 	buffer_init();
-	unnamed_dev_init();
 	key_init();
 	security_init();
 	vfs_caches_init(num_physpages);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

