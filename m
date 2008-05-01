From: akpm@linux-foundation.org
Subject: - mm-bdi-add-separate-writeback-accounting-capability.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:52 -0700
Message-ID: <200805010931.m419Vqti030912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758040AbYEAJcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: add separate writeback accounting capability
has been removed from the -mm tree.  Its filename was
     mm-bdi-add-separate-writeback-accounting-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: add separate writeback accounting capability
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new BDI capability flag: BDI_CAP_NO_ACCT_WB.  If this flag is
set, then don't update the per-bdi writeback stats from
test_set_page_writeback() and test_clear_page_writeback().

Misc cleanups:

 - convert bdi_cap_writeback_dirty() and friends to static inline functions
 - create a flag that includes all three dirty/writeback related flags,
   since almst all users will want to have them toghether

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/inode.c         |    2 
 fs/hugetlbfs/inode.c        |    2 
 fs/ocfs2/dlm/dlmfs.c        |    2 
 fs/ramfs/inode.c            |    2 
 fs/sysfs/inode.c            |    2 
 include/linux/backing-dev.h |   77 +++++++++++++++++++++++++---------
 kernel/cgroup.c             |    2 
 mm/page-writeback.c         |    4 -
 mm/shmem.c                  |    2 
 mm/swap_state.c             |    2 
 10 files changed, 67 insertions(+), 30 deletions(-)

diff -puN fs/configfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability fs/configfs/inode.c
--- a/fs/configfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/fs/configfs/inode.c
@@ -47,7 +47,7 @@ static const struct address_space_operat
 
 static struct backing_dev_info configfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct inode_operations configfs_inode_operations ={
diff -puN fs/hugetlbfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/fs/hugetlbfs/inode.c
@@ -45,7 +45,7 @@ static const struct inode_operations hug
 
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 int sysctl_hugetlb_shm_group;
diff -puN fs/ocfs2/dlm/dlmfs.c~mm-bdi-add-separate-writeback-accounting-capability fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -327,7 +327,7 @@ clear_fields:
 
 static struct backing_dev_info dlmfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static struct inode *dlmfs_get_root_inode(struct super_block *sb)
diff -puN fs/ramfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/fs/ramfs/inode.c
@@ -44,7 +44,7 @@ static const struct inode_operations ram
 
 static struct backing_dev_info ramfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK |
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK |
 			  BDI_CAP_MAP_DIRECT | BDI_CAP_MAP_COPY |
 			  BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP,
 };
diff -puN fs/sysfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/fs/sysfs/inode.c
@@ -30,7 +30,7 @@ static const struct address_space_operat
 
 static struct backing_dev_info sysfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct inode_operations sysfs_inode_operations ={
diff -puN include/linux/backing-dev.h~mm-bdi-add-separate-writeback-accounting-capability include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-add-separate-writeback-accounting-capability
+++ a/include/linux/backing-dev.h
@@ -12,6 +12,7 @@
 #include <linux/log2.h>
 #include <linux/proportions.h>
 #include <linux/kernel.h>
+#include <linux/fs.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -151,22 +152,43 @@ int bdi_set_max_ratio(struct backing_dev
 
 /*
  * Flags in backing_dev_info::capability
- * - The first two flags control whether dirty pages will contribute to the
- *   VM's accounting and whether writepages() should be called for dirty pages
- *   (something that would not, for example, be appropriate for ramfs)
- * - These flags let !MMU mmap() govern direct device mapping vs immediate
- *   copying more easily for MAP_PRIVATE, especially for ROM filesystems
+ *
+ * The first three flags control whether dirty pages will contribute to the
+ * VM's accounting and whether writepages() should be called for dirty pages
+ * (something that would not, for example, be appropriate for ramfs)
+ *
+ * WARNING: these flags are closely related and should not normally be
+ * used separately.  The BDI_CAP_NO_ACCT_AND_WRITEBACK combines these
+ * three flags into a single convenience macro.
+ *
+ * BDI_CAP_NO_ACCT_DIRTY:  Dirty pages shouldn't contribute to accounting
+ * BDI_CAP_NO_WRITEBACK:   Don't write pages back
+ * BDI_CAP_NO_ACCT_WB:     Don't automatically account writeback pages
+ *
+ * These flags let !MMU mmap() govern direct device mapping vs immediate
+ * copying more easily for MAP_PRIVATE, especially for ROM filesystems.
+ *
+ * BDI_CAP_MAP_COPY:       Copy can be mapped (MAP_PRIVATE)
+ * BDI_CAP_MAP_DIRECT:     Can be mapped directly (MAP_SHARED)
+ * BDI_CAP_READ_MAP:       Can be mapped for reading
+ * BDI_CAP_WRITE_MAP:      Can be mapped for writing
+ * BDI_CAP_EXEC_MAP:       Can be mapped for execution
  */
-#define BDI_CAP_NO_ACCT_DIRTY	0x00000001	/* Dirty pages shouldn't contribute to accounting */
-#define BDI_CAP_NO_WRITEBACK	0x00000002	/* Don't write pages back */
-#define BDI_CAP_MAP_COPY	0x00000004	/* Copy can be mapped (MAP_PRIVATE) */
-#define BDI_CAP_MAP_DIRECT	0x00000008	/* Can be mapped directly (MAP_SHARED) */
-#define BDI_CAP_READ_MAP	0x00000010	/* Can be mapped for reading */
-#define BDI_CAP_WRITE_MAP	0x00000020	/* Can be mapped for writing */
-#define BDI_CAP_EXEC_MAP	0x00000040	/* Can be mapped for execution */
+#define BDI_CAP_NO_ACCT_DIRTY	0x00000001
+#define BDI_CAP_NO_WRITEBACK	0x00000002
+#define BDI_CAP_MAP_COPY	0x00000004
+#define BDI_CAP_MAP_DIRECT	0x00000008
+#define BDI_CAP_READ_MAP	0x00000010
+#define BDI_CAP_WRITE_MAP	0x00000020
+#define BDI_CAP_EXEC_MAP	0x00000040
+#define BDI_CAP_NO_ACCT_WB	0x00000080
+
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
 
+#define BDI_CAP_NO_ACCT_AND_WRITEBACK \
+	(BDI_CAP_NO_WRITEBACK | BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_ACCT_WB)
+
 #if defined(VM_MAYREAD) && \
 	(BDI_CAP_READ_MAP != VM_MAYREAD || \
 	 BDI_CAP_WRITE_MAP != VM_MAYWRITE || \
@@ -206,17 +228,32 @@ void clear_bdi_congested(struct backing_
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
 
-#define bdi_cap_writeback_dirty(bdi) \
-	(!((bdi)->capabilities & BDI_CAP_NO_WRITEBACK))
 
-#define bdi_cap_account_dirty(bdi) \
-	(!((bdi)->capabilities & BDI_CAP_NO_ACCT_DIRTY))
+static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
+{
+	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
+}
 
-#define mapping_cap_writeback_dirty(mapping) \
-	bdi_cap_writeback_dirty((mapping)->backing_dev_info)
+static inline bool bdi_cap_account_dirty(struct backing_dev_info *bdi)
+{
+	return !(bdi->capabilities & BDI_CAP_NO_ACCT_DIRTY);
+}
 
-#define mapping_cap_account_dirty(mapping) \
-	bdi_cap_account_dirty((mapping)->backing_dev_info)
+static inline bool bdi_cap_account_writeback(struct backing_dev_info *bdi)
+{
+	/* Paranoia: BDI_CAP_NO_WRITEBACK implies BDI_CAP_NO_ACCT_WB */
+	return !(bdi->capabilities & (BDI_CAP_NO_ACCT_WB |
+				      BDI_CAP_NO_WRITEBACK));
+}
+
+static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
+{
+	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
+}
 
+static inline bool mapping_cap_account_dirty(struct address_space *mapping)
+{
+	return bdi_cap_account_dirty(mapping->backing_dev_info);
+}
 
 #endif		/* _LINUX_BACKING_DEV_H */
diff -puN kernel/cgroup.c~mm-bdi-add-separate-writeback-accounting-capability kernel/cgroup.c
--- a/kernel/cgroup.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/kernel/cgroup.c
@@ -575,7 +575,7 @@ static struct inode_operations cgroup_di
 static struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static struct inode *cgroup_new_inode(mode_t mode, struct super_block *sb)
diff -puN mm/page-writeback.c~mm-bdi-add-separate-writeback-accounting-capability mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/mm/page-writeback.c
@@ -1246,7 +1246,7 @@ int test_clear_page_writeback(struct pag
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
-			if (bdi_cap_writeback_dirty(bdi)) {
+			if (bdi_cap_account_writeback(bdi)) {
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
 				__bdi_writeout_inc(bdi);
 			}
@@ -1275,7 +1275,7 @@ int test_set_page_writeback(struct page 
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
-			if (bdi_cap_writeback_dirty(bdi))
+			if (bdi_cap_account_writeback(bdi))
 				__inc_bdi_stat(bdi, BDI_WRITEBACK);
 		}
 		if (!PageDirty(page))
diff -puN mm/shmem.c~mm-bdi-add-separate-writeback-accounting-capability mm/shmem.c
--- a/mm/shmem.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/mm/shmem.c
@@ -201,7 +201,7 @@ static struct vm_operations_struct shmem
 
 static struct backing_dev_info shmem_backing_dev_info  __read_mostly = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 
diff -puN mm/swap_state.c~mm-bdi-add-separate-writeback-accounting-capability mm/swap_state.c
--- a/mm/swap_state.c~mm-bdi-add-separate-writeback-accounting-capability
+++ a/mm/swap_state.c
@@ -33,7 +33,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 	.unplug_io_fn	= swap_unplug_io_fn,
 };
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

