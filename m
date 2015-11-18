From: akpm@linux-foundation.org
Subject: +
 mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
 added to -mm tree
Date: Wed, 18 Nov 2015 13:59:16 -0800
Message-ID: <564cf4b4.CMHaODa3hlxYny48%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbbKRV7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 16:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, jmarchan@redhat.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, proc: reduce cost of /proc/pid/smaps for unpopulated shmem mappings
has been added to the -mm tree.  Its filename is
     mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, proc: reduce cost of /proc/pid/smaps for unpopulated shmem mappings

Following the previous patch, further reduction of /proc/pid/smaps cost is
possible for private writable shmem mappings with unpopulated areas where
the page walk invokes the .pte_hole function.  We can use radix tree
iterator for each such area instead of calling find_get_entry() in a loop.
This is possible at the extra maintenance cost of introducing another
shmem function shmem_partial_swap_usage().

To demonstrate the diference, I have measured this on a process that
creates a private writable 2GB mapping of a partially swapped out
/dev/shm/file (which cannot employ the optimizations from the prvious
patch) and doesn't populate it at all.  I time how long does it take to
cat /proc/pid/smaps of this process 100 times.

Before this patch:

real    0m3.831s
user    0m0.180s
sys     0m3.212s

After this patch:

real    0m1.176s
user    0m0.180s
sys     0m0.684s

The time is similar to the case where a radix tree iterator is employed on
the whole mapping.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |   42 +++++++----------------
 include/linux/shmem_fs.h |    2 +
 mm/shmem.c               |   65 +++++++++++++++++++++----------------
 3 files changed, 53 insertions(+), 56 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings
+++ a/fs/proc/task_mmu.c
@@ -488,42 +488,16 @@ static void smaps_account(struct mem_siz
 }
 
 #ifdef CONFIG_SHMEM
-static unsigned long smaps_shmem_swap(struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	struct page *page;
-
-	page = find_get_entry(vma->vm_file->f_mapping,
-					linear_page_index(vma, addr));
-	if (!page)
-		return 0;
-
-	if (radix_tree_exceptional_entry(page))
-		return PAGE_SIZE;
-
-	page_cache_release(page);
-	return 0;
-
-}
-
 static int smaps_pte_hole(unsigned long addr, unsigned long end,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 
-	while (addr < end) {
-		mss->swap += smaps_shmem_swap(walk->vma, addr);
-		addr += PAGE_SIZE;
-	}
+	mss->swap += shmem_partial_swap_usage(
+			walk->vma->vm_file->f_mapping, addr, end);
 
 	return 0;
 }
-#else
-static unsigned long smaps_shmem_swap(struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	return 0;
-}
 #endif
 
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
@@ -555,7 +529,17 @@ static void smaps_pte_entry(pte_t *pte,
 			page = migration_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
-		mss->swap += smaps_shmem_swap(vma, addr);
+		page = find_get_entry(vma->vm_file->f_mapping,
+						linear_page_index(vma, addr));
+		if (!page)
+			return;
+
+		if (radix_tree_exceptional_entry(page))
+			mss->swap += PAGE_SIZE;
+		else
+			page_cache_release(page);
+
+		return;
 	}
 
 	if (!page)
diff -puN include/linux/shmem_fs.h~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings
+++ a/include/linux/shmem_fs.h
@@ -61,6 +61,8 @@ extern void shmem_truncate_range(struct
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
 
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
+extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
+						pgoff_t start, pgoff_t end);
 
 static inline struct page *shmem_read_mapping_page(
 				struct address_space *mapping, pgoff_t index)
diff -puN mm/shmem.c~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings mm/shmem.c
--- a/mm/shmem.c~mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings
+++ a/mm/shmem.c
@@ -361,41 +361,18 @@ static int shmem_free_swap(struct addres
 
 /*
  * Determine (in bytes) how many of the shmem object's pages mapped by the
- * given vma is swapped out.
+ * given offsets are swapped out.
  *
  * This is safe to call without i_mutex or mapping->tree_lock thanks to RCU,
  * as long as the inode doesn't go away and racy results are not a problem.
  */
-unsigned long shmem_swap_usage(struct vm_area_struct *vma)
+unsigned long shmem_partial_swap_usage(struct address_space *mapping,
+						pgoff_t start, pgoff_t end)
 {
-	struct inode *inode = file_inode(vma->vm_file);
-	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct address_space *mapping = inode->i_mapping;
-	unsigned long swapped;
-	pgoff_t start, end;
 	struct radix_tree_iter iter;
 	void **slot;
 	struct page *page;
-
-	/* Be careful as we don't hold info->lock */
-	swapped = READ_ONCE(info->swapped);
-
-	/*
-	 * The easier cases are when the shmem object has nothing in swap, or
-	 * the vma maps it whole. Then we can simply use the stats that we
-	 * already track.
-	 */
-	if (!swapped)
-		return 0;
-
-	if (!vma->vm_pgoff && vma->vm_end - vma->vm_start >= inode->i_size)
-		return swapped << PAGE_SHIFT;
-
-	swapped = 0;
-
-	/* Here comes the more involved part */
-	start = linear_page_index(vma, vma->vm_start);
-	end = linear_page_index(vma, vma->vm_end);
+	unsigned long swapped = 0;
 
 	rcu_read_lock();
 
@@ -430,6 +407,40 @@ restart:
 }
 
 /*
+ * Determine (in bytes) how many of the shmem object's pages mapped by the
+ * given vma is swapped out.
+ *
+ * This is safe to call without i_mutex or mapping->tree_lock thanks to RCU,
+ * as long as the inode doesn't go away and racy results are not a problem.
+ */
+unsigned long shmem_swap_usage(struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct address_space *mapping = inode->i_mapping;
+	unsigned long swapped;
+
+	/* Be careful as we don't hold info->lock */
+	swapped = READ_ONCE(info->swapped);
+
+	/*
+	 * The easier cases are when the shmem object has nothing in swap, or
+	 * the vma maps it whole. Then we can simply use the stats that we
+	 * already track.
+	 */
+	if (!swapped)
+		return 0;
+
+	if (!vma->vm_pgoff && vma->vm_end - vma->vm_start >= inode->i_size)
+		return swapped << PAGE_SHIFT;
+
+	/* Here comes the more involved part */
+	return shmem_partial_swap_usage(mapping,
+			linear_page_index(vma, vma->vm_start),
+			linear_page_index(vma, vma->vm_end));
+}
+
+/*
  * SysV IPC SHM_UNLOCK restore Unevictable pages to their evictable lists.
  */
 void shmem_unlock_mapping(struct address_space *mapping)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch

