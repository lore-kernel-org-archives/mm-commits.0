From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-add-hugetlbfs_fallocate.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:29 -0700
Message-ID: <55f08c95.sSoJt6D5CuesdsMv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbbIITqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add hugetlbfs_fallocate()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-hugetlbfs_fallocate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: add hugetlbfs_fallocate()

This is based on the shmem version, but it has diverged quite a bit.  We
have no swap to worry about, nor the new file sealing.  Add
synchronication via the fault mutex table to coordinate page faults,
fallocate allocation and fallocate hole punch.

What this allows us to do is move physical memory in and out of a
hugetlbfs file without having it mapped.  This also gives us the ability
to support MADV_REMOVE since it is currently implemented using
fallocate().  MADV_REMOVE lets madvise() remove pages from the middle of a
hugetlbfs file, which wasn't possible before.

hugetlbfs fallocate only operates on whole huge pages.

Based on code by Dave Hansen.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |  179 +++++++++++++++++++++++++++++++++++++-
 include/linux/hugetlb.h |    3 
 mm/hugetlb.c            |    2 
 3 files changed, 182 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-add-hugetlbfs_fallocate fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-hugetlbfs_fallocate
+++ a/fs/hugetlbfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/thread_info.h>
 #include <asm/current.h>
 #include <linux/sched.h>		/* remove ASAP */
+#include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/file.h>
@@ -84,6 +85,29 @@ static const match_table_t tokens = {
 	{Opt_err,	NULL},
 };
 
+#ifdef CONFIG_NUMA
+static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
+					struct inode *inode, pgoff_t index)
+{
+	vma->vm_policy = mpol_shared_policy_lookup(&HUGETLBFS_I(inode)->policy,
+							index);
+}
+
+static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
+{
+	mpol_cond_put(vma->vm_policy);
+}
+#else
+static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
+					struct inode *inode, pgoff_t index)
+{
+}
+
+static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
+{
+}
+#endif
+
 static void huge_pagevec_release(struct pagevec *pvec)
 {
 	int i;
@@ -479,6 +503,158 @@ static int hugetlb_vmtruncate(struct ino
 	return 0;
 }
 
+static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct hstate *h = hstate_inode(inode);
+	loff_t hpage_size = huge_page_size(h);
+	loff_t hole_start, hole_end;
+
+	/*
+	 * For hole punch round up the beginning offset of the hole and
+	 * round down the end.
+	 */
+	hole_start = round_up(offset, hpage_size);
+	hole_end = round_down(offset + len, hpage_size);
+
+	if (hole_end > hole_start) {
+		struct address_space *mapping = inode->i_mapping;
+
+		mutex_lock(&inode->i_mutex);
+		i_mmap_lock_write(mapping);
+		if (!RB_EMPTY_ROOT(&mapping->i_mmap))
+			hugetlb_vmdelete_list(&mapping->i_mmap,
+						hole_start >> PAGE_SHIFT,
+						hole_end  >> PAGE_SHIFT);
+		i_mmap_unlock_write(mapping);
+		remove_inode_hugepages(inode, hole_start, hole_end);
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	return 0;
+}
+
+static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
+				loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = inode->i_mapping;
+	struct hstate *h = hstate_inode(inode);
+	struct vm_area_struct pseudo_vma;
+	struct mm_struct *mm = current->mm;
+	loff_t hpage_size = huge_page_size(h);
+	unsigned long hpage_shift = huge_page_shift(h);
+	pgoff_t start, index, end;
+	int error;
+	u32 hash;
+
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		return hugetlbfs_punch_hole(inode, offset, len);
+
+	/*
+	 * Default preallocate case.
+	 * For this range, start is rounded down and end is rounded up
+	 * as well as being converted to page offsets.
+	 */
+	start = offset >> hpage_shift;
+	end = (offset + len + hpage_size - 1) >> hpage_shift;
+
+	mutex_lock(&inode->i_mutex);
+
+	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
+	error = inode_newsize_ok(inode, offset + len);
+	if (error)
+		goto out;
+
+	/*
+	 * Initialize a pseudo vma as this is required by the huge page
+	 * allocation routines.  If NUMA is configured, use page index
+	 * as input to create an allocation policy.
+	 */
+	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
+	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
+	pseudo_vma.vm_file = file;
+
+	for (index = start; index < end; index++) {
+		/*
+		 * This is supposed to be the vaddr where the page is being
+		 * faulted in, but we have no vaddr here.
+		 */
+		struct page *page;
+		unsigned long addr;
+		int avoid_reserve = 0;
+
+		cond_resched();
+
+		/*
+		 * fallocate(2) manpage permits EINTR; we may have been
+		 * interrupted because we are using up too much memory.
+		 */
+		if (signal_pending(current)) {
+			error = -EINTR;
+			break;
+		}
+
+		/* Set numa allocation policy based on index */
+		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
+
+		/* addr is the offset within the file (zero based) */
+		addr = index * hpage_size;
+
+		/* mutex taken here, fault path and hole punch */
+		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
+						index, addr);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+		/* See if already present in mapping to avoid alloc/free */
+		page = find_get_page(mapping, index);
+		if (page) {
+			put_page(page);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			hugetlb_drop_vma_policy(&pseudo_vma);
+			continue;
+		}
+
+		/* Allocate page and add to page cache */
+		page = alloc_huge_page(&pseudo_vma, addr, avoid_reserve);
+		hugetlb_drop_vma_policy(&pseudo_vma);
+		if (IS_ERR(page)) {
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			error = PTR_ERR(page);
+			goto out;
+		}
+		clear_huge_page(page, addr, pages_per_huge_page(h));
+		__SetPageUptodate(page);
+		error = huge_add_to_page_cache(page, mapping, index);
+		if (unlikely(error)) {
+			put_page(page);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			goto out;
+		}
+
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
+		/*
+		 * page_put due to reference from alloc_huge_page()
+		 * unlock_page because locked by add_to_page_cache()
+		 */
+		put_page(page);
+		unlock_page(page);
+	}
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
+		i_size_write(inode, offset + len);
+	inode->i_ctime = CURRENT_TIME;
+	spin_lock(&inode->i_lock);
+	inode->i_private = NULL;
+	spin_unlock(&inode->i_lock);
+out:
+	mutex_unlock(&inode->i_mutex);
+	return error;
+}
+
 static int hugetlbfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
@@ -790,7 +966,8 @@ const struct file_operations hugetlbfs_f
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
-	.llseek		= default_llseek,
+	.llseek			= default_llseek,
+	.fallocate		= hugetlbfs_fallocate,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff -puN include/linux/hugetlb.h~hugetlbfs-add-hugetlbfs_fallocate include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-hugetlbfs_fallocate
+++ a/include/linux/hugetlb.h
@@ -330,6 +330,8 @@ struct huge_bootmem_page {
 #endif
 };
 
+struct page *alloc_huge_page(struct vm_area_struct *vma,
+				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
@@ -483,6 +485,7 @@ static inline spinlock_t *huge_pte_lockp
 
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
+#define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
diff -puN mm/hugetlb.c~hugetlbfs-add-hugetlbfs_fallocate mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-hugetlbfs_fallocate
+++ a/mm/hugetlb.c
@@ -1727,7 +1727,7 @@ static void vma_end_reservation(struct h
 	(void)__vma_reservation_common(h, vma, addr, VMA_END_RESV);
 }
 
-static struct page *alloc_huge_page(struct vm_area_struct *vma,
+struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


