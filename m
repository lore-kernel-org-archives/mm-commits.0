From: akpm@linux-foundation.org
Subject: [patch 077/117] tmpfs: mem_cgroup charge fault to vm_mm not
 current mm
Date: Thu, 19 May 2016 17:12:47 -0700
Message-ID: <573e567f.UmHOmblUvKqMqp72%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871AbcETAMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org

From: Andres Lagar-Cavilla <andreslc@google.com>
Subject: tmpfs: mem_cgroup charge fault to vm_mm not current mm

Although shmem_fault() has been careful to count a major fault to vm_mm,
shmem_getpage_gfp() has been careless in charging a remote access fault to
current->mm owner's memcg instead of to vma->vm_mm owner's memcg: that is
inconsistent with all the mem_cgroup charging on remote access faults in
mm/memory.c.

Fix it by passing fault_mm along with fault_type to shmem_get_page_gfp();
but in that case, now knowing the right mm, it's better for it to handle
the PGMAJFAULT updates itself.

And let's keep this clutter out of most callers' way: change the common
shmem_getpage() wrapper to hide fault_mm and fault_type as well as gfp.

Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   61 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff -puN mm/shmem.c~tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm mm/shmem.c
--- a/mm/shmem.c~tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm
+++ a/mm/shmem.c
@@ -121,13 +121,14 @@ static bool shmem_should_replace_page(st
 static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 				struct shmem_inode_info *info, pgoff_t index);
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-	struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type);
+		struct page **pagep, enum sgp_type sgp,
+		gfp_t gfp, struct mm_struct *fault_mm, int *fault_type);
 
 static inline int shmem_getpage(struct inode *inode, pgoff_t index,
-	struct page **pagep, enum sgp_type sgp, int *fault_type)
+		struct page **pagep, enum sgp_type sgp)
 {
 	return shmem_getpage_gfp(inode, index, pagep, sgp,
-			mapping_gfp_mask(inode->i_mapping), fault_type);
+		mapping_gfp_mask(inode->i_mapping), NULL, NULL);
 }
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
@@ -527,7 +528,7 @@ static void shmem_undo_range(struct inod
 
 	if (partial_start) {
 		struct page *page = NULL;
-		shmem_getpage(inode, start - 1, &page, SGP_READ, NULL);
+		shmem_getpage(inode, start - 1, &page, SGP_READ);
 		if (page) {
 			unsigned int top = PAGE_SIZE;
 			if (start > end) {
@@ -542,7 +543,7 @@ static void shmem_undo_range(struct inod
 	}
 	if (partial_end) {
 		struct page *page = NULL;
-		shmem_getpage(inode, end, &page, SGP_READ, NULL);
+		shmem_getpage(inode, end, &page, SGP_READ);
 		if (page) {
 			zero_user_segment(page, 0, partial_end);
 			set_page_dirty(page);
@@ -1115,14 +1116,19 @@ static int shmem_replace_page(struct pag
  *
  * If we allocate a new one we do not mark it dirty. That's up to the
  * vm. If we swap it in we mark it dirty since we also free the swap
- * entry since a page cannot live in both the swap and page cache
+ * entry since a page cannot live in both the swap and page cache.
+ *
+ * fault_mm and fault_type are only supplied by shmem_fault:
+ * otherwise they are NULL.
  */
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-	struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type)
+	struct page **pagep, enum sgp_type sgp, gfp_t gfp,
+	struct mm_struct *fault_mm, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info;
 	struct shmem_sb_info *sbinfo;
+	struct mm_struct *charge_mm;
 	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
@@ -1168,14 +1174,19 @@ repeat:
 	 */
 	info = SHMEM_I(inode);
 	sbinfo = SHMEM_SB(inode->i_sb);
+	charge_mm = fault_mm ? : current->mm;
 
 	if (swap.val) {
 		/* Look it up and read it in.. */
 		page = lookup_swap_cache(swap);
 		if (!page) {
-			/* here we actually do the io */
-			if (fault_type)
+			/* Or update major stats only when swapin succeeds?? */
+			if (fault_type) {
 				*fault_type |= VM_FAULT_MAJOR;
+				count_vm_event(PGMAJFAULT);
+				mem_cgroup_count_vm_event(fault_mm, PGMAJFAULT);
+			}
+			/* Here we actually start the io */
 			page = shmem_swapin(swap, gfp, info, index);
 			if (!page) {
 				error = -ENOMEM;
@@ -1202,7 +1213,7 @@ repeat:
 				goto failed;
 		}
 
-		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg,
+		error = mem_cgroup_try_charge(page, charge_mm, gfp, &memcg,
 				false);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
@@ -1263,7 +1274,7 @@ repeat:
 		if (sgp == SGP_WRITE)
 			__SetPageReferenced(page);
 
-		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg,
+		error = mem_cgroup_try_charge(page, charge_mm, gfp, &memcg,
 				false);
 		if (error)
 			goto decused;
@@ -1352,6 +1363,7 @@ unlock:
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vma->vm_file);
+	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
@@ -1413,14 +1425,10 @@ static int shmem_fault(struct vm_area_st
 		spin_unlock(&inode->i_lock);
 	}
 
-	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
+	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, SGP_CACHE,
+				  gfp, vma->vm_mm, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
-
-	if (ret & VM_FAULT_MAJOR) {
-		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-	}
 	return ret;
 }
 
@@ -1567,7 +1575,7 @@ shmem_write_begin(struct file *file, str
 			return -EPERM;
 	}
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
+	return shmem_getpage(inode, index, pagep, SGP_WRITE);
 }
 
 static int
@@ -1633,7 +1641,7 @@ static ssize_t shmem_file_read_iter(stru
 				break;
 		}
 
-		error = shmem_getpage(inode, index, &page, sgp, NULL);
+		error = shmem_getpage(inode, index, &page, sgp);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
@@ -1749,7 +1757,7 @@ static ssize_t shmem_file_splice_read(st
 	error = 0;
 
 	while (spd.nr_pages < nr_pages) {
-		error = shmem_getpage(inode, index, &page, SGP_CACHE, NULL);
+		error = shmem_getpage(inode, index, &page, SGP_CACHE);
 		if (error)
 			break;
 		unlock_page(page);
@@ -1771,8 +1779,7 @@ static ssize_t shmem_file_splice_read(st
 		page = spd.pages[page_nr];
 
 		if (!PageUptodate(page) || page->mapping != mapping) {
-			error = shmem_getpage(inode, index, &page,
-							SGP_CACHE, NULL);
+			error = shmem_getpage(inode, index, &page, SGP_CACHE);
 			if (error)
 				break;
 			unlock_page(page);
@@ -2215,8 +2222,7 @@ static long shmem_fallocate(struct file
 		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
 			error = -ENOMEM;
 		else
-			error = shmem_getpage(inode, index, &page, SGP_FALLOC,
-									NULL);
+			error = shmem_getpage(inode, index, &page, SGP_FALLOC);
 		if (error) {
 			/* Remove the !PageUptodate pages we added */
 			shmem_undo_range(inode,
@@ -2534,7 +2540,7 @@ static int shmem_symlink(struct inode *d
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
-		error = shmem_getpage(inode, 0, &page, SGP_WRITE, NULL);
+		error = shmem_getpage(inode, 0, &page, SGP_WRITE);
 		if (error) {
 			iput(inode);
 			return error;
@@ -2575,7 +2581,7 @@ static const char *shmem_get_link(struct
 			return ERR_PTR(-ECHILD);
 		}
 	} else {
-		error = shmem_getpage(inode, 0, &page, SGP_READ, NULL);
+		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
 		unlock_page(page);
@@ -3479,7 +3485,8 @@ struct page *shmem_read_mapping_page_gfp
 	int error;
 
 	BUG_ON(mapping->a_ops != &shmem_aops);
-	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE, gfp, NULL);
+	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
+				  gfp, NULL, NULL);
 	if (error)
 		page = ERR_PTR(error);
 	else
_
