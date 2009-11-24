From: akpm@linux-foundation.org
Subject: + ksm-take-keyhole-reference-to-page.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:35:32 -0800
Message-ID: <200911241935.nAOJZW1R028240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758183AbZKXTft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com


The patch titled
     ksm: take keyhole reference to page
has been added to the -mm tree.  Its filename is
     ksm-take-keyhole-reference-to-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: take keyhole reference to page
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

There's a lamentable flaw in KSM swapping: the stable_node holds a
reference to the ksm page, so the page to be freed cannot actually be
freed until ksmd works its way around to removing the last rmap_item from
its stable_node.  Which in some configurations may take minutes: not quite
responsive enough for memory reclaim.  And we don't want to twist KSM and
its locking more tightly into the rest of mm.  What a pity.

But although the stable_node needs to hold a pointer to the ksm page, does
it actually need to raise the reference count of that page?

No.  It would need to do so if struct pages were ordinary kmalloc'ed
objects; but they are more stable than that, and reused in particular ways
according to particular rules.

Access to stable_node from its pointer in struct page is no problem, so
long as we never free a stable_node before the ksm page itself has been
freed.  Access to struct page from its pointer in stable_node: reintroduce
get_ksm_page(), and let that peep out through its keyhole (the stable_node
pointer to ksm page), to see if that struct page still holds the right key
to open it (the ksm page mapping pointer back to this stable_node).

This relies upon the established way in which free_hot_cold_page() sets an
anon (including ksm) page->mapping to NULL; and relies upon no other user
of a struct page to put something which looks like the original
stable_node pointer (with two low bits also set) into page->mapping.  It
also needs get_page_unless_zero() technique pioneered by speculative
pagecache; and uses rcu_read_lock() to keep the guarantees that gives.

There are several drivers which put pointers of their own into page->
mapping; but none of those could coincide with our stable_node pointers,
since KSM won't free a stable_node until it sees that the page has gone.

The only problem case found is the pagetable spinlock USE_SPLIT_PTLOCKS
places in struct page (my own abuse): to accommodate GENERIC_LOCKBREAK's
break_lock on 32-bit, that spans both page->private and page->mapping. 
Since break_lock is only 0 or 1, again no confusion for get_ksm_page().

But what of DEBUG_SPINLOCK on 64-bit bigendian?  When owner_cpu is 3
(matching PageKsm low bits), it might see 0xdead4ead00000003 in page->
mapping, which might coincide?  We could get around that by...  but a
better answer is to suppress USE_SPLIT_PTLOCKS when DEBUG_SPINLOCK or
DEBUG_LOCK_ALLOC, to stop bloating sizeof(struct page) in their case -
already proposed in an earlier mm/Kconfig patch.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  149 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 110 insertions(+), 39 deletions(-)

diff -puN mm/ksm.c~ksm-take-keyhole-reference-to-page mm/ksm.c
--- a/mm/ksm.c~ksm-take-keyhole-reference-to-page
+++ a/mm/ksm.c
@@ -413,6 +413,12 @@ static void break_cow(struct rmap_item *
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
 
+	/*
+	 * It is not an accident that whenever we want to break COW
+	 * to undo, we also need to drop a reference to the anon_vma.
+	 */
+	drop_anon_vma(rmap_item);
+
 	down_read(&mm->mmap_sem);
 	if (ksm_test_exit(mm))
 		goto out;
@@ -456,6 +462,79 @@ out:		page = NULL;
 	return page;
 }
 
+static void remove_node_from_stable_tree(struct stable_node *stable_node)
+{
+	struct rmap_item *rmap_item;
+	struct hlist_node *hlist;
+
+	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+		if (rmap_item->hlist.next)
+			ksm_pages_sharing--;
+		else
+			ksm_pages_shared--;
+		drop_anon_vma(rmap_item);
+		rmap_item->address &= PAGE_MASK;
+		cond_resched();
+	}
+
+	rb_erase(&stable_node->node, &root_stable_tree);
+	free_stable_node(stable_node);
+}
+
+/*
+ * get_ksm_page: checks if the page indicated by the stable node
+ * is still its ksm page, despite having held no reference to it.
+ * In which case we can trust the content of the page, and it
+ * returns the gotten page; but if the page has now been zapped,
+ * remove the stale node from the stable tree and return NULL.
+ *
+ * You would expect the stable_node to hold a reference to the ksm page.
+ * But if it increments the page's count, swapping out has to wait for
+ * ksmd to come around again before it can free the page, which may take
+ * seconds or even minutes: much too unresponsive.  So instead we use a
+ * "keyhole reference": access to the ksm page from the stable node peeps
+ * out through its keyhole to see if that page still holds the right key,
+ * pointing back to this stable node.  This relies on freeing a PageAnon
+ * page to reset its page->mapping to NULL, and relies on no other use of
+ * a page to put something that might look like our key in page->mapping.
+ *
+ * include/linux/pagemap.h page_cache_get_speculative() is a good reference,
+ * but this is different - made simpler by ksm_thread_mutex being held, but
+ * interesting for assuming that no other use of the struct page could ever
+ * put our expected_mapping into page->mapping (or a field of the union which
+ * coincides with page->mapping).  The RCU calls are not for KSM at all, but
+ * to keep the page_count protocol described with page_cache_get_speculative.
+ *
+ * Note: it is possible that get_ksm_page() will return NULL one moment,
+ * then page the next, if the page is in between page_freeze_refs() and
+ * page_unfreeze_refs(): this shouldn't be a problem anywhere, the page
+ * is on its way to being freed; but it is an anomaly to bear in mind.
+ */
+static struct page *get_ksm_page(struct stable_node *stable_node)
+{
+	struct page *page;
+	void *expected_mapping;
+
+	page = stable_node->page;
+	expected_mapping = (void *)stable_node +
+				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
+	rcu_read_lock();
+	if (page->mapping != expected_mapping)
+		goto stale;
+	if (!get_page_unless_zero(page))
+		goto stale;
+	if (page->mapping != expected_mapping) {
+		put_page(page);
+		goto stale;
+	}
+	rcu_read_unlock();
+	return page;
+stale:
+	rcu_read_unlock();
+	remove_node_from_stable_tree(stable_node);
+	return NULL;
+}
+
 /*
  * Removing rmap_item from stable or unstable tree.
  * This function will clean the information from the stable/unstable tree.
@@ -467,22 +546,19 @@ static void remove_rmap_item_from_tree(s
 		struct page *page;
 
 		stable_node = rmap_item->head;
-		page = stable_node->page;
-		lock_page(page);
+		page = get_ksm_page(stable_node);
+		if (!page)
+			goto out;
 
+		lock_page(page);
 		hlist_del(&rmap_item->hlist);
-		if (stable_node->hlist.first) {
-			unlock_page(page);
-			ksm_pages_sharing--;
-		} else {
-			set_page_stable_node(page, NULL);
-			unlock_page(page);
-			put_page(page);
+		unlock_page(page);
+		put_page(page);
 
-			rb_erase(&stable_node->node, &root_stable_tree);
-			free_stable_node(stable_node);
+		if (stable_node->hlist.first)
+			ksm_pages_sharing--;
+		else
 			ksm_pages_shared--;
-		}
 
 		drop_anon_vma(rmap_item);
 		rmap_item->address &= PAGE_MASK;
@@ -504,7 +580,7 @@ static void remove_rmap_item_from_tree(s
 		ksm_pages_unshared--;
 		rmap_item->address &= PAGE_MASK;
 	}
-
+out:
 	cond_resched();		/* we're called from many long loops */
 }
 
@@ -902,10 +978,8 @@ up:
 		 * If that fails, we have a ksm page with only one pte
 		 * pointing to it: so break it.
 		 */
-		if (err) {
-			drop_anon_vma(rmap_item);
+		if (err)
 			break_cow(rmap_item);
-		}
 	}
 	if (err) {
 		put_page(kpage);
@@ -935,21 +1009,25 @@ static struct stable_node *stable_tree_s
 	}
 
 	while (node) {
+		struct page *tree_page;
 		int ret;
 
 		cond_resched();
 		stable_node = rb_entry(node, struct stable_node, node);
+		tree_page = get_ksm_page(stable_node);
+		if (!tree_page)
+			return NULL;
 
-		ret = memcmp_pages(page, stable_node->page);
+		ret = memcmp_pages(page, tree_page);
 
-		if (ret < 0)
+		if (ret < 0) {
+			put_page(tree_page);
 			node = node->rb_left;
-		else if (ret > 0)
+		} else if (ret > 0) {
+			put_page(tree_page);
 			node = node->rb_right;
-		else {
-			get_page(stable_node->page);
+		} else
 			return stable_node;
-		}
 	}
 
 	return NULL;
@@ -969,12 +1047,17 @@ static struct stable_node *stable_tree_i
 	struct stable_node *stable_node;
 
 	while (*new) {
+		struct page *tree_page;
 		int ret;
 
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
+		tree_page = get_ksm_page(stable_node);
+		if (!tree_page)
+			return NULL;
 
-		ret = memcmp_pages(kpage, stable_node->page);
+		ret = memcmp_pages(kpage, tree_page);
+		put_page(tree_page);
 
 		parent = *new;
 		if (ret < 0)
@@ -1000,7 +1083,6 @@ static struct stable_node *stable_tree_i
 
 	INIT_HLIST_HEAD(&stable_node->hlist);
 
-	get_page(kpage);
 	stable_node->page = kpage;
 	set_page_stable_node(kpage, stable_node);
 
@@ -1130,19 +1212,10 @@ static void cmp_and_merge_page(struct pa
 	}
 
 	/*
-	 * A ksm page might have got here by fork, but its other
-	 * references have already been removed from the stable tree.
-	 * Or it might be left over from a break_ksm which failed
-	 * when the mem_cgroup had reached its limit: try again now.
-	 */
-	if (PageKsm(page))
-		break_cow(rmap_item);
-
-	/*
-	 * In case the hash value of the page was changed from the last time we
-	 * have calculated it, this page to be changed frequely, therefore we
-	 * don't want to insert it to the unstable tree, and we don't want to
-	 * waste our time to search if there is something identical to it there.
+	 * If the hash value of the page has changed from the last time
+	 * we calculated it, this page is changing frequently: therefore we
+	 * don't want to insert it in the unstable tree, and we don't want
+	 * to waste our time searching for something identical to it there.
 	 */
 	checksum = calc_checksum(page);
 	if (rmap_item->oldchecksum != checksum) {
@@ -1180,9 +1253,7 @@ static void cmp_and_merge_page(struct pa
 			 * in which case we need to break_cow on both.
 			 */
 			if (!stable_node) {
-				drop_anon_vma(tree_rmap_item);
 				break_cow(tree_rmap_item);
-				drop_anon_vma(rmap_item);
 				break_cow(rmap_item);
 			}
 		}
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
ksm-fix-mlockfreed-to-munlocked.patch
ksm-let-shared-pages-be-swappable.patch
ksm-hold-anon_vma-in-rmap_item.patch
ksm-take-keyhole-reference-to-page.patch
ksm-share-anon-page-without-allocating.patch
ksm-mem-cgroup-charge-swapin-copy.patch
ksm-rmap_walk-to-remove_migation_ptes.patch
ksm-memory-hotremove-migration-only.patch
ksm-remove-unswappable-max_kernel_pages.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

