From: akpm@linux-foundation.org
Subject: [merged] tmpfs-depend-on-shmem.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:19 -0700
Message-ID: <200909222043.n8MKhJGs011371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZIVUn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: depend on shmem
has been removed from the -mm tree.  Its filename was
     tmpfs-depend-on-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: depend on shmem
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

CONFIG_SHMEM off gives you (ramfs masquerading as) tmpfs, even when
CONFIG_TMPFS is off: that's a little anomalous, and I'd intended to make
more sense of it by removing CONFIG_TMPFS altogether, always enabling its
code when CONFIG_SHMEM; but so many defconfigs have CONFIG_SHMEM on
CONFIG_TMPFS off that we'd better leave that as is.

But there is no point in asking for CONFIG_TMPFS if CONFIG_SHMEM is off:
make TMPFS depend on SHMEM, which also prevents TMPFS_POSIX_ACL
shmem_acl.o being pointlessly built into the kernel when SHMEM is off.

And a selfish change, to prevent the world from being rebuilt when I
switch between CONFIG_SHMEM on and off: the only CONFIG_SHMEM in the
header files is mm.h shmem_lock() - give that a shmem.c stub instead.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig         |    1 +
 include/linux/mm.h |   11 +----------
 mm/shmem.c         |    5 +++++
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/Kconfig~tmpfs-depend-on-shmem fs/Kconfig
--- a/fs/Kconfig~tmpfs-depend-on-shmem
+++ a/fs/Kconfig
@@ -109,6 +109,7 @@ source "fs/sysfs/Kconfig"
 
 config TMPFS
 	bool "Virtual memory file system support (former shm fs)"
+	depends on SHMEM
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.
 
diff -puN include/linux/mm.h~tmpfs-depend-on-shmem include/linux/mm.h
--- a/include/linux/mm.h~tmpfs-depend-on-shmem
+++ a/include/linux/mm.h
@@ -702,17 +702,8 @@ extern void pagefault_out_of_memory(void
 
 extern void show_free_areas(void);
 
-#ifdef CONFIG_SHMEM
-extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
-#else
-static inline int shmem_lock(struct file *file, int lock,
-			    struct user_struct *user)
-{
-	return 0;
-}
-#endif
+int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
-
 int shmem_zero_setup(struct vm_area_struct *);
 
 #ifndef CONFIG_MMU
diff -puN mm/shmem.c~tmpfs-depend-on-shmem mm/shmem.c
--- a/mm/shmem.c~tmpfs-depend-on-shmem
+++ a/mm/shmem.c
@@ -2593,6 +2593,11 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
+int shmem_lock(struct file *file, int lock, struct user_struct *user)
+{
+	return 0;
+}
+
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

