From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:13:24 -0800
Message-ID: <52e02664.v3SQsz3HOAD7fHmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:24 -0800


The patch titled
     Subject: mm/rmap: make rmap_walk to get the rmap_walk_control argument
has been removed from the -mm tree.  Its filename was
     mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: make rmap_walk to get the rmap_walk_control argument

In each rmap traverse case, there is some difference so that we need
function pointers and arguments to them in order to handle these

For this purpose, struct rmap_walk_control is introduced in this patch,
and will be extended in following patch.  Introducing and extending are
separate, because it clarify changes.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |    7 +++----
 include/linux/rmap.h |    9 +++++++--
 mm/ksm.c             |    6 +++---
 mm/migrate.c         |    7 ++++++-
 mm/rmap.c            |   19 ++++++++-----------
 5 files changed, 27 insertions(+), 21 deletions(-)

diff -puN include/linux/ksm.h~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument include/linux/ksm.h
--- a/include/linux/ksm.h~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument
+++ a/include/linux/ksm.h
@@ -76,8 +76,7 @@ struct page *ksm_might_need_to_copy(stru
 int page_referenced_ksm(struct page *page,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 int try_to_unmap_ksm(struct page *page, enum ttu_flags flags);
-int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page *,
-		  struct vm_area_struct *, unsigned long, void *), void *arg);
+int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc);
 void ksm_migrate_page(struct page *newpage, struct page *oldpage);
 
 #else  /* !CONFIG_KSM */
@@ -120,8 +119,8 @@ static inline int try_to_unmap_ksm(struc
 	return 0;
 }
 
-static inline int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page*,
-		struct vm_area_struct *, unsigned long, void *), void *arg)
+static inline int rmap_walk_ksm(struct page *page,
+			struct rmap_walk_control *rwc)
 {
 	return 0;
 }
diff -puN include/linux/rmap.h~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument
+++ a/include/linux/rmap.h
@@ -235,11 +235,16 @@ struct anon_vma *page_lock_anon_vma_read
 void page_unlock_anon_vma_read(struct anon_vma *anon_vma);
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+struct rmap_walk_control {
+	void *arg;
+	int (*rmap_one)(struct page *page, struct vm_area_struct *vma,
+					unsigned long addr, void *arg);
+};
+
 /*
  * Called by migrate.c to remove migration ptes, but might be used more later.
  */
-int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
-		struct vm_area_struct *, unsigned long, void *), void *arg);
+int rmap_walk(struct page *page, struct rmap_walk_control *rwc);
 
 #else	/* !CONFIG_MMU */
 
diff -puN mm/ksm.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument mm/ksm.c
--- a/mm/ksm.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument
+++ a/mm/ksm.c
@@ -1997,8 +1997,7 @@ out:
 }
 
 #ifdef CONFIG_MIGRATION
-int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page *,
-		  struct vm_area_struct *, unsigned long, void *), void *arg)
+int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct stable_node *stable_node;
 	struct rmap_item *rmap_item;
@@ -2033,7 +2032,8 @@ again:
 			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
 				continue;
 
-			ret = rmap_one(page, vma, rmap_item->address, arg);
+			ret = rwc->rmap_one(page, vma,
+					rmap_item->address, rwc->arg);
 			if (ret != SWAP_AGAIN) {
 				anon_vma_unlock_read(anon_vma);
 				goto out;
diff -puN mm/migrate.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument mm/migrate.c
--- a/mm/migrate.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument
+++ a/mm/migrate.c
@@ -199,7 +199,12 @@ out:
  */
 static void remove_migration_ptes(struct page *old, struct page *new)
 {
-	rmap_walk(new, remove_migration_pte, old);
+	struct rmap_walk_control rwc = {
+		.rmap_one = remove_migration_pte,
+		.arg = old,
+	};
+
+	rmap_walk(new, &rwc);
 }
 
 /*
diff -puN mm/rmap.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument mm/rmap.c
--- a/mm/rmap.c~mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument
+++ a/mm/rmap.c
@@ -1706,8 +1706,7 @@ static struct anon_vma *rmap_walk_anon_l
  * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
  * Called by migrate.c to remove migration ptes, but might be used more later.
  */
-static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
-		struct vm_area_struct *, unsigned long, void *), void *arg)
+static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
@@ -1721,7 +1720,7 @@ static int rmap_walk_anon(struct page *p
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
-		ret = rmap_one(page, vma, address, arg);
+		ret = rwc->rmap_one(page, vma, address, rwc->arg);
 		if (ret != SWAP_AGAIN)
 			break;
 	}
@@ -1729,8 +1728,7 @@ static int rmap_walk_anon(struct page *p
 	return ret;
 }
 
-static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
-		struct vm_area_struct *, unsigned long, void *), void *arg)
+static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
 	pgoff_t pgoff = page->index << compound_order(page);
@@ -1742,7 +1740,7 @@ static int rmap_walk_file(struct page *p
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-		ret = rmap_one(page, vma, address, arg);
+		ret = rwc->rmap_one(page, vma, address, rwc->arg);
 		if (ret != SWAP_AGAIN)
 			break;
 	}
@@ -1755,17 +1753,16 @@ static int rmap_walk_file(struct page *p
 	return ret;
 }
 
-int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
-		struct vm_area_struct *, unsigned long, void *), void *arg)
+int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
 {
 	VM_BUG_ON(!PageLocked(page));
 
 	if (unlikely(PageKsm(page)))
-		return rmap_walk_ksm(page, rmap_one, arg);
+		return rmap_walk_ksm(page, rwc);
 	else if (PageAnon(page))
-		return rmap_walk_anon(page, rmap_one, arg);
+		return rmap_walk_anon(page, rwc);
 	else
-		return rmap_walk_file(page, rmap_one, arg);
+		return rmap_walk_file(page, rwc);
 }
 #endif /* CONFIG_MIGRATION */
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

