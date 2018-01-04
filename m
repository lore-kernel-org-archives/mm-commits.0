From: akpm@linux-foundation.org
Subject: + mm-numa-rework-do_pages_move.patch added to -mm tree
Date: Wed, 03 Jan 2018 16:04:41 -0800
Message-ID: <5a4d6f99./GKDP/HxdbIAoF7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeADAEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 19:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, numa: rework do_pages_move
has been added to the -mm tree.  Its filename is
     mm-numa-rework-do_pages_move.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-rework-do_pages_move.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-rework-do_pages_move.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, numa: rework do_pages_move

Patch series "unclutter thp migration"

Motivation:

THP migration is hacked into the generic migration with rather surprising
semantic.  The migration allocation callback is supposed to check whether
the THP can be migrated at once and if that is not the case then it
allocates a simple page to migrate.  unmap_and_move then fixes that up by
splitting the THP into small pages while moving the head page to the newly
allocated order-0 page.  Remaining pages are moved to the LRU list by
split_huge_page.  The same happens if the THP allocation fails.  This is
really ugly and error prone [2].

I also believe that split_huge_page to the LRU lists is inherently wrong
because all tail pages are not migrated.  Some callers will just work
around that by retrying (e.g.  memory hotplug).  There are other pfn
walkers which are simply broken though.  e.g.  madvise_inject_error will
migrate head and then advances next pfn by the huge page size. 
do_move_page_to_node_array, queue_pages_range (migrate_pages, mbind), will
simply split the THP before migration if the THP migration is not
supported then falls back to single page migration but it doesn't handle
tail pages if the THP migration path is not able to allocate a fresh THP
so we end up with ENOMEM and fail the whole migration which is a
questionable behavior.  Page compaction doesn't try to migrate large pages
so it should be immune.

The first patch reworks do_pages_move which relies on a very ugly calling
semantic when the return status is pushed to the migration path via
private pointer.  It uses pre allocated fixed size batching to achieve
that.  We simply cannot do the same if a THP is to be split during the
migration path which is done in the patch 3.  Patch 2 is follow up cleanup
which removes the mentioned return status calling convention ugliness.

On a side note:

There are some semantic issues I have encountered on the way when working
on patch 1 but I am not addressing them here.  E.g.  trying to move THP
tail pages will result in either success or EBUSY (the later one more
likely once we isolate head from the LRU list).  Hugetlb reports EACCESS
on tail pages.  Some errors are reported via status parameter but
migration failures are not even though the original `reason' argument
suggests there was an intention to do so.  From a quick look into git
history this never worked.  I have tried to keep the semantic unchanged.

Then there is a relatively minor thing that the page isolation might fail
because of pages not being on the LRU - e.g.  because they are sitting on
the per-cpu LRU caches.  Easily fixable.


This patch (of 3):

do_pages_move is supposed to move user defined memory (an array of
addresses) to the user defined numa nodes (an array of nodes one for each
address).  The user provided status array then contains resulting numa
node for each address or an error.  The semantic of this function is
little bit confusing because only some errors are reported back.  Notably
migrate_pages error is only reported via the return value.  This patch
doesn't try to address these semantic nuances but rather change the
underlying implementation.

Currently we are processing user input (which can be really large) in
batches which are stored to a temporarily allocated page.  Each address is
resolved to its struct page and stored to page_to_node structure along
with the requested target numa node.  The array of these structures is
then conveyed down the page migration path via private argument. 
new_page_node then finds the corresponding structure and allocates the
proper target page.

What is the problem with the current implementation and why to change it? 
Apart from being quite ugly it also doesn't cope with unexpected pages
showing up on the migration list inside migrate_pages path.  That doesn't
happen currently but the follow up patch would like to make the thp
migration code more clear and that would need to split a THP into the list
for some cases.

How does the new implementation work?  Well, instead of batching into a
fixed size array we simply batch all pages that should be migrated to the
same node and isolate all of them into a linked list which doesn't require
any additional storage.  This should work reasonably well because page
migration usually migrates larger ranges of memory to a specific node.  So
the common case should work equally well as the current implementation. 
Even if somebody constructs an input where the target numa nodes would be
interleaved we shouldn't see a large performance impact because page
migration alone doesn't really benefit from batching.  mmap_sem batching
for the lookup is quite questionable and isolate_lru_page which would
benefit from batching is not using it even in the current implementation.

Link: http://lkml.kernel.org/r/20180103082555.14592-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    1 
 mm/mempolicy.c |    5 
 mm/migrate.c   |  312 ++++++++++++++++++++---------------------------
 3 files changed, 141 insertions(+), 177 deletions(-)

diff -puN mm/internal.h~mm-numa-rework-do_pages_move mm/internal.h
--- a/mm/internal.h~mm-numa-rework-do_pages_move
+++ a/mm/internal.h
@@ -540,4 +540,5 @@ static inline bool is_migrate_highatomic
 }
 
 void setup_zone_pageset(struct zone *zone);
+extern struct page *alloc_new_node_page(struct page *page, unsigned long node, int **x);
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/mempolicy.c~mm-numa-rework-do_pages_move mm/mempolicy.c
--- a/mm/mempolicy.c~mm-numa-rework-do_pages_move
+++ a/mm/mempolicy.c
@@ -942,7 +942,8 @@ static void migrate_page_add(struct page
 	}
 }
 
-static struct page *new_node_page(struct page *page, unsigned long node, int **x)
+/* page allocation callback for NUMA node migration */
+struct page *alloc_new_node_page(struct page *page, unsigned long node, int **x)
 {
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
@@ -986,7 +987,7 @@ static int migrate_to_node(struct mm_str
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, NULL, dest,
+		err = migrate_pages(&pagelist, alloc_new_node_page, NULL, dest,
 					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
diff -puN mm/migrate.c~mm-numa-rework-do_pages_move mm/migrate.c
--- a/mm/migrate.c~mm-numa-rework-do_pages_move
+++ a/mm/migrate.c
@@ -1444,141 +1444,103 @@ out:
 }
 
 #ifdef CONFIG_NUMA
-/*
- * Move a list of individual pages
- */
-struct page_to_node {
-	unsigned long addr;
-	struct page *page;
-	int node;
-	int status;
-};
 
-static struct page *new_page_node(struct page *p, unsigned long private,
-		int **result)
+static int store_status(int __user *status, int start, int value, int nr)
 {
-	struct page_to_node *pm = (struct page_to_node *)private;
+	while (nr-- > 0) {
+		if (put_user(value, status + start))
+			return -EFAULT;
+		start++;
+	}
 
-	while (pm->node != MAX_NUMNODES && pm->page != p)
-		pm++;
+	return 0;
+}
+
+static int do_move_pages_to_node(struct mm_struct *mm,
+		struct list_head *pagelist, int node)
+{
+	int err;
 
-	if (pm->node == MAX_NUMNODES)
-		return NULL;
+	if (list_empty(pagelist))
+		return 0;
 
-	*result = &pm->status;
-
-	if (PageHuge(p))
-		return alloc_huge_page_node(page_hstate(compound_head(p)),
-					pm->node);
-	else if (thp_migration_supported() && PageTransHuge(p)) {
-		struct page *thp;
-
-		thp = alloc_pages_node(pm->node,
-			(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM,
-			HPAGE_PMD_ORDER);
-		if (!thp)
-			return NULL;
-		prep_transhuge_page(thp);
-		return thp;
-	} else
-		return __alloc_pages_node(pm->node,
-				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
+	err = migrate_pages(pagelist, alloc_new_node_page, NULL, node,
+			MIGRATE_SYNC, MR_SYSCALL);
+	if (err)
+		putback_movable_pages(pagelist);
+	return err;
 }
 
 /*
- * Move a set of pages as indicated in the pm array. The addr
- * field must be set to the virtual address of the page to be moved
- * and the node number must contain a valid target node.
- * The pm array ends with node = MAX_NUMNODES.
+ * Resolves the given address to a struct page, isolates it from the LRU and
+ * puts it to the given pagelist.
+ * Returns -errno if the page cannot be found/isolated or 0 when it has been
+ * queued or the page doesn't need to be migrated because it is already on
+ * the target node
  */
-static int do_move_page_to_node_array(struct mm_struct *mm,
-				      struct page_to_node *pm,
-				      int migrate_all)
+static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
+		int node, struct list_head *pagelist, bool migrate_all)
 {
+	struct vm_area_struct *vma;
+	struct page *page;
+	unsigned int follflags;
 	int err;
-	struct page_to_node *pp;
-	LIST_HEAD(pagelist);
 
 	down_read(&mm->mmap_sem);
+	err = -EFAULT;
+	vma = find_vma(mm, addr);
+	if (!vma || addr < vma->vm_start || !vma_migratable(vma))
+		goto out;
 
-	/*
-	 * Build a list of pages to migrate
-	 */
-	for (pp = pm; pp->node != MAX_NUMNODES; pp++) {
-		struct vm_area_struct *vma;
-		struct page *page;
-		struct page *head;
-		unsigned int follflags;
+	/* FOLL_DUMP to ignore special (like zero) pages */
+	follflags = FOLL_GET | FOLL_DUMP;
+	if (!thp_migration_supported())
+		follflags |= FOLL_SPLIT;
+	page = follow_page(vma, addr, follflags);
 
-		err = -EFAULT;
-		vma = find_vma(mm, pp->addr);
-		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
-			goto set_status;
-
-		/* FOLL_DUMP to ignore special (like zero) pages */
-		follflags = FOLL_GET | FOLL_DUMP;
-		if (!thp_migration_supported())
-			follflags |= FOLL_SPLIT;
-		page = follow_page(vma, pp->addr, follflags);
-
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
-			goto set_status;
-
-		err = -ENOENT;
-		if (!page)
-			goto set_status;
-
-		err = page_to_nid(page);
-
-		if (err == pp->node)
-			/*
-			 * Node already in the right place
-			 */
-			goto put_and_set;
+	err = PTR_ERR(page);
+	if (IS_ERR(page))
+		goto out;
 
-		err = -EACCES;
-		if (page_mapcount(page) > 1 &&
-				!migrate_all)
-			goto put_and_set;
-
-		if (PageHuge(page)) {
-			if (PageHead(page)) {
-				isolate_huge_page(page, &pagelist);
-				err = 0;
-				pp->page = page;
-			}
-			goto put_and_set;
+	err = -ENOENT;
+	if (!page)
+		goto out;
+
+	err = 0;
+	if (page_to_nid(page) == node)
+		goto out_putpage;
+
+	err = -EACCES;
+	if (page_mapcount(page) > 1 && !migrate_all)
+		goto out_putpage;
+
+	if (PageHuge(page)) {
+		if (PageHead(page)) {
+			isolate_huge_page(page, pagelist);
+			err = 0;
 		}
+	} else {
+		struct page *head;
 
-		pp->page = compound_head(page);
 		head = compound_head(page);
 		err = isolate_lru_page(head);
-		if (!err) {
-			list_add_tail(&head->lru, &pagelist);
-			mod_node_page_state(page_pgdat(head),
-				NR_ISOLATED_ANON + page_is_file_cache(head),
-				hpage_nr_pages(head));
-		}
-put_and_set:
-		/*
-		 * Either remove the duplicate refcount from
-		 * isolate_lru_page() or drop the page ref if it was
-		 * not isolated.
-		 */
-		put_page(page);
-set_status:
-		pp->status = err;
-	}
-
-	err = 0;
-	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_page_node, NULL,
-				(unsigned long)pm, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
-			putback_movable_pages(&pagelist);
-	}
+			goto out_putpage;
 
+		err = 0;
+		list_add_tail(&head->lru, pagelist);
+		mod_node_page_state(page_pgdat(head),
+			NR_ISOLATED_ANON + page_is_file_cache(head),
+			hpage_nr_pages(head));
+	}
+out_putpage:
+	/*
+	 * Either remove the duplicate refcount from
+	 * isolate_lru_page() or drop the page ref if it was
+	 * not isolated.
+	 */
+	put_page(page);
+out:
 	up_read(&mm->mmap_sem);
 	return err;
 }
@@ -1593,79 +1555,79 @@ static int do_pages_move(struct mm_struc
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
-	struct page_to_node *pm;
-	unsigned long chunk_nr_pages;
-	unsigned long chunk_start;
-	int err;
-
-	err = -ENOMEM;
-	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
-	if (!pm)
-		goto out;
+	int current_node = NUMA_NO_NODE;
+	LIST_HEAD(pagelist);
+	int start, i;
+	int err = 0, err1;
 
 	migrate_prep();
 
-	/*
-	 * Store a chunk of page_to_node array in a page,
-	 * but keep the last one as a marker
-	 */
-	chunk_nr_pages = (PAGE_SIZE / sizeof(struct page_to_node)) - 1;
-
-	for (chunk_start = 0;
-	     chunk_start < nr_pages;
-	     chunk_start += chunk_nr_pages) {
-		int j;
+	for (i = start = 0; i < nr_pages; i++) {
+		const void __user *p;
+		unsigned long addr;
+		int node;
 
-		if (chunk_start + chunk_nr_pages > nr_pages)
-			chunk_nr_pages = nr_pages - chunk_start;
-
-		/* fill the chunk pm with addrs and nodes from user-space */
-		for (j = 0; j < chunk_nr_pages; j++) {
-			const void __user *p;
-			int node;
-
-			err = -EFAULT;
-			if (get_user(p, pages + j + chunk_start))
-				goto out_pm;
-			pm[j].addr = (unsigned long) p;
+		err = -EFAULT;
+		if (get_user(p, pages + i))
+			goto out_flush;
+		if (get_user(node, nodes + i))
+			goto out_flush;
+		addr = (unsigned long)p;
+
+		err = -ENODEV;
+		if (node < 0 || node >= MAX_NUMNODES)
+			goto out_flush;
+		if (!node_state(node, N_MEMORY))
+			goto out_flush;
 
-			if (get_user(node, nodes + j + chunk_start))
-				goto out_pm;
+		err = -EACCES;
+		if (!node_isset(node, task_nodes))
+			goto out_flush;
 
-			err = -ENODEV;
-			if (node < 0 || node >= MAX_NUMNODES)
-				goto out_pm;
+		if (current_node == NUMA_NO_NODE) {
+			current_node = node;
+			start = i;
+		} else if (node != current_node) {
+			err = do_move_pages_to_node(mm, &pagelist, current_node);
+			if (err)
+				goto out;
+			err = store_status(status, start, current_node, i - start);
+			if (err)
+				goto out;
+			start = i;
+			current_node = node;
+		}
 
-			if (!node_state(node, N_MEMORY))
-				goto out_pm;
+		/*
+		 * Errors in the page lookup or isolation are not fatal and we simply
+		 * report them via status
+		 */
+		err = add_page_for_migration(mm, addr, current_node,
+				&pagelist, flags & MPOL_MF_MOVE_ALL);
+		if (!err)
+			continue;
 
-			err = -EACCES;
-			if (!node_isset(node, task_nodes))
-				goto out_pm;
+		err = store_status(status, i, err, 1);
+		if (err)
+			goto out_flush;
 
-			pm[j].node = node;
+		err = do_move_pages_to_node(mm, &pagelist, current_node);
+		if (err)
+			goto out;
+		if (i > start) {
+			err = store_status(status, start, current_node, i - start);
+			if (err)
+				goto out;
 		}
-
-		/* End marker for this chunk */
-		pm[chunk_nr_pages].node = MAX_NUMNODES;
-
-		/* Migrate this chunk */
-		err = do_move_page_to_node_array(mm, pm,
-						 flags & MPOL_MF_MOVE_ALL);
-		if (err < 0)
-			goto out_pm;
-
-		/* Return status information */
-		for (j = 0; j < chunk_nr_pages; j++)
-			if (put_user(pm[j].status, status + j + chunk_start)) {
-				err = -EFAULT;
-				goto out_pm;
-			}
+		current_node = NUMA_NO_NODE;
 	}
-	err = 0;
-
-out_pm:
-	free_page((unsigned long)pm);
+out_flush:
+	/* Make sure we do not overwrite the existing error */
+	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
+	if (!err1)
+		err1 = store_status(status, start, current_node, i - start);
+	if (!err)
+		err = err1;
 out:
 	return err;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

