From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:13:26 -0800
Message-ID: <52e02666.oSNmjp9u3LHhQgIJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:26 -0800


The patch titled
     Subject: mm/rmap: extend rmap_walk_xxx() to cope with different cases
has been removed from the -mm tree.  Its filename was
     mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: extend rmap_walk_xxx() to cope with different cases

There are a lot of common parts in traversing functions, but there are
also a little of uncommon parts in it.  By assigning proper function
pointer on each rmap_walker_control, we can handle these difference
correctly.

Following are differences we should handle.

1. difference of lock function in anon mapping case
2. nonlinear handling in file mapping case
3. prechecked condition:
	checking memcg in page_referenced(),
	checking VM_SHARE in page_mkclean()
	checking temporary vma in try_to_unmap()
4. exit condition:
	checking page_mapped() in try_to_unmap()

So, in this patch, I introduce 4 function pointers to handle above
differences.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   15 +++++++++++++++
 mm/ksm.c             |    7 +++++++
 mm/rmap.c            |   37 +++++++++++++++++++++++++++++--------
 3 files changed, 51 insertions(+), 8 deletions(-)

diff -puN include/linux/rmap.h~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases
+++ a/include/linux/rmap.h
@@ -235,10 +235,25 @@ struct anon_vma *page_lock_anon_vma_read
 void page_unlock_anon_vma_read(struct anon_vma *anon_vma);
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+/*
+ * rmap_walk_control: To control rmap traversing for specific needs
+ *
+ * arg: passed to rmap_one() and invalid_vma()
+ * rmap_one: executed on each vma where page is mapped
+ * done: for checking traversing termination condition
+ * file_nonlinear: for handling file nonlinear mapping
+ * anon_lock: for getting anon_lock by optimized way rather than default
+ * invalid_vma: for skipping uninterested vma
+ */
 struct rmap_walk_control {
 	void *arg;
 	int (*rmap_one)(struct page *page, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
+	int (*done)(struct page *page);
+	int (*file_nonlinear)(struct page *, struct address_space *,
+					struct vm_area_struct *vma);
+	struct anon_vma *(*anon_lock)(struct page *page);
+	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
 /*
diff -puN mm/ksm.c~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases mm/ksm.c
--- a/mm/ksm.c~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases
+++ a/mm/ksm.c
@@ -2032,12 +2032,19 @@ again:
 			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
 				continue;
 
+			if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
+				continue;
+
 			ret = rwc->rmap_one(page, vma,
 					rmap_item->address, rwc->arg);
 			if (ret != SWAP_AGAIN) {
 				anon_vma_unlock_read(anon_vma);
 				goto out;
 			}
+			if (rwc->done && rwc->done(page)) {
+				anon_vma_unlock_read(anon_vma);
+				goto out;
+			}
 		}
 		anon_vma_unlock_read(anon_vma);
 	}
diff -puN mm/rmap.c~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases mm/rmap.c
--- a/mm/rmap.c~mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases
+++ a/mm/rmap.c
@@ -1684,10 +1684,14 @@ void __put_anon_vma(struct anon_vma *ano
 }
 
 #ifdef CONFIG_MIGRATION
-static struct anon_vma *rmap_walk_anon_lock(struct page *page)
+static struct anon_vma *rmap_walk_anon_lock(struct page *page,
+					struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
 
+	if (rwc->anon_lock)
+		return rwc->anon_lock(page);
+
 	/*
 	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
 	 * because that depends on page_mapped(); but not all its usages
@@ -1713,16 +1717,22 @@ static int rmap_walk_anon(struct page *p
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
-	anon_vma = rmap_walk_anon_lock(page);
+	anon_vma = rmap_walk_anon_lock(page, rwc);
 	if (!anon_vma)
 		return ret;
 
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
+
+		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
+			continue;
+
 		ret = rwc->rmap_one(page, vma, address, rwc->arg);
 		if (ret != SWAP_AGAIN)
 			break;
+		if (rwc->done && rwc->done(page))
+			break;
 	}
 	anon_vma_unlock_read(anon_vma);
 	return ret;
@@ -1740,15 +1750,26 @@ static int rmap_walk_file(struct page *p
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
+
+		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
+			continue;
+
 		ret = rwc->rmap_one(page, vma, address, rwc->arg);
 		if (ret != SWAP_AGAIN)
-			break;
+			goto done;
+		if (rwc->done && rwc->done(page))
+			goto done;
 	}
-	/*
-	 * No nonlinear handling: being always shared, nonlinear vmas
-	 * never contain migration ptes.  Decide what to do about this
-	 * limitation to linear when we need rmap_walk() on nonlinear.
-	 */
+
+	if (!rwc->file_nonlinear)
+		goto done;
+
+	if (list_empty(&mapping->i_mmap_nonlinear))
+		goto done;
+
+	ret = rwc->file_nonlinear(page, mapping, vma);
+
+done:
 	mutex_unlock(&mapping->i_mmap_mutex);
 	return ret;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

