From: akpm@linux-foundation.org
Subject: [merged] mm-fix-crashes-from-mbind-merging-vmas.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:49 -0700
Message-ID: <53a9cb59.DSZ7qV7Mo4qZQlVf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaFXTCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix crashes from mbind() merging vmas
has been removed from the -mm tree.  Its filename was
     mm-fix-crashes-from-mbind-merging-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix crashes from mbind() merging vmas

v2.6.34's 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") introduced vma
merging to mbind(), but it should have also changed the convention of
passing start vma from queue_pages_range() (formerly check_range()) to
new_vma_page(): vma merging may have already freed that structure,
resulting in BUG at mm/mempolicy.c:1738 and probably worse crashes.

Fixes: 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@vger.kernel.org>	[2.6.34+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-crashes-from-mbind-merging-vmas mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-crashes-from-mbind-merging-vmas
+++ a/mm/mempolicy.c
@@ -656,19 +656,18 @@ static unsigned long change_prot_numa(st
  * @nodes and @flags,) it's isolated and queued to the pagelist which is
  * passed via @private.)
  */
-static struct vm_area_struct *
+static int
 queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		const nodemask_t *nodes, unsigned long flags, void *private)
 {
-	int err;
-	struct vm_area_struct *first, *vma, *prev;
-
+	int err = 0;
+	struct vm_area_struct *vma, *prev;
 
-	first = find_vma(mm, start);
-	if (!first)
-		return ERR_PTR(-EFAULT);
+	vma = find_vma(mm, start);
+	if (!vma)
+		return -EFAULT;
 	prev = NULL;
-	for (vma = first; vma && vma->vm_start < end; vma = vma->vm_next) {
+	for (; vma && vma->vm_start < end; vma = vma->vm_next) {
 		unsigned long endvma = vma->vm_end;
 
 		if (endvma > end)
@@ -678,9 +677,9 @@ queue_pages_range(struct mm_struct *mm,
 
 		if (!(flags & MPOL_MF_DISCONTIG_OK)) {
 			if (!vma->vm_next && vma->vm_end < end)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 			if (prev && prev->vm_end < vma->vm_start)
-				return ERR_PTR(-EFAULT);
+				return -EFAULT;
 		}
 
 		if (flags & MPOL_MF_LAZY) {
@@ -694,15 +693,13 @@ queue_pages_range(struct mm_struct *mm,
 
 			err = queue_pages_pgd_range(vma, start, endvma, nodes,
 						flags, private);
-			if (err) {
-				first = ERR_PTR(err);
+			if (err)
 				break;
-			}
 		}
 next:
 		prev = vma;
 	}
-	return first;
+	return err;
 }
 
 /*
@@ -1156,16 +1153,17 @@ out:
 
 /*
  * Allocate a new page for page migration based on vma policy.
- * Start assuming that page is mapped by vma pointed to by @private.
+ * Start by assuming the page is mapped by the same vma as contains @start.
  * Search forward from there, if not.  N.B., this assumes that the
  * list of pages handed to migrate_pages()--which is how we get here--
  * is in virtual address order.
  */
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
-	struct vm_area_struct *vma = (struct vm_area_struct *)private;
+	struct vm_area_struct *vma;
 	unsigned long uninitialized_var(address);
 
+	vma = find_vma(current->mm, start);
 	while (vma) {
 		address = page_address_in_vma(page, vma);
 		if (address != -EFAULT)
@@ -1195,7 +1193,7 @@ int do_migrate_pages(struct mm_struct *m
 	return -ENOSYS;
 }
 
-static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
+static struct page *new_page(struct page *page, unsigned long start, int **x)
 {
 	return NULL;
 }
@@ -1205,7 +1203,6 @@ static long do_mbind(unsigned long start
 		     unsigned short mode, unsigned short mode_flags,
 		     nodemask_t *nmask, unsigned long flags)
 {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct mempolicy *new;
 	unsigned long end;
@@ -1271,11 +1268,9 @@ static long do_mbind(unsigned long start
 	if (err)
 		goto mpol_out;
 
-	vma = queue_pages_range(mm, start, end, nmask,
+	err = queue_pages_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
-
-	err = PTR_ERR(vma);	/* maybe ... */
-	if (!IS_ERR(vma))
+	if (!err)
 		err = mbind_range(mm, start, end, new);
 
 	if (!err) {
@@ -1283,9 +1278,8 @@ static long do_mbind(unsigned long start
 
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
-			nr_failed = migrate_pages(&pagelist, new_vma_page,
-					NULL, (unsigned long)vma,
-					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
+			nr_failed = migrate_pages(&pagelist, new_page, NULL,
+				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
 				putback_movable_pages(&pagelist);
 		}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

