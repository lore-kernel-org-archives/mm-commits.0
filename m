From: akpm@linux-foundation.org
Subject: [merged]
 mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:05:09 -0700
Message-ID: <536a83e5.KQQ9dF8B9xZeIDW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaEGTFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, davej@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries.patch removed from -mm tree
To: hannes@cmpxchg.org,davej@redhat.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:09 -0700


The patch titled
     Subject: mm: filemap: update find_get_pages_tag() to deal with shadow entries
has been removed from the -mm tree.  Its filename was
     mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: filemap: update find_get_pages_tag() to deal with shadow entries

Dave Jones reports the following crash when find_get_pages_tag() runs into
an exceptional entry:

kernel BUG at mm/filemap.c:1347!
RIP: 0010:[<ffffffffb815aeab>]  [<ffffffffb815aeab>] find_get_pages_tag+0x1cb/0x220
Call Trace:
 [<ffffffffb815ad16>] ? find_get_pages_tag+0x36/0x220
 [<ffffffffb8168511>] pagevec_lookup_tag+0x21/0x30
 [<ffffffffb81595de>] filemap_fdatawait_range+0xbe/0x1e0
 [<ffffffffb8159727>] filemap_fdatawait+0x27/0x30
 [<ffffffffb81f2fa4>] sync_inodes_sb+0x204/0x2a0
 [<ffffffffb874d98f>] ? wait_for_completion+0xff/0x130
 [<ffffffffb81fa5b0>] ? vfs_fsync+0x40/0x40
 [<ffffffffb81fa5c9>] sync_inodes_one_sb+0x19/0x20
 [<ffffffffb81caab2>] iterate_supers+0xb2/0x110
 [<ffffffffb81fa864>] sys_sync+0x44/0xb0
 [<ffffffffb875c4a9>] ia32_do_call+0x13/0x13

1343                         /*
1344                          * This function is never used on a shmem/tmpfs
1345                          * mapping, so a swap entry won't be found here.
1346                          */
1347                         BUG();

After 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache
radix trees") this comment and BUG() are out of date because exceptional
entries can now appear in all mappings - as shadows of recently evicted
pages.

However, as Hugh Dickins notes,

  "it is truly surprising for a PAGECACHE_TAG_WRITEBACK (and probably
   any other PAGECACHE_TAG_*) to appear on an exceptional entry.

   I expect it comes down to an occasional race in RCU lookup of the
   radix_tree: lacking absolute synchronization, we might sometimes
   catch an exceptional entry, with the tag which really belongs with
   the unexceptional entry which was there an instant before."

And indeed, not only is the tree walk lockless, the tags are also read in
chunks, one radix tree node at a time.  There is plenty of time for page
reclaim to swoop in and replace a page that was already looked up as
tagged with a shadow entry.

Remove the BUG() and update the comment.  While reviewing all other lookup
sites for whether they properly deal with shadow entries of evicted pages,
update all the comments and fix memcg file charge moving to not miss
shmem/tmpfs swapcache pages.

Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |   49 ++++++++++++++++++++++++++--------------------
 mm/memcontrol.c |   20 +++++++++++-------
 mm/truncate.c   |    8 -------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff -puN mm/filemap.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries mm/filemap.c
--- a/mm/filemap.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries
+++ a/mm/filemap.c
@@ -906,8 +906,8 @@ EXPORT_SYMBOL(page_cache_prev_hole);
  * Looks up the page cache slot at @mapping & @offset.  If there is a
  * page cache page, it is returned with an increased refcount.
  *
- * If the slot holds a shadow entry of a previously evicted page, it
- * is returned.
+ * If the slot holds a shadow entry of a previously evicted page, or a
+ * swap entry from shmem/tmpfs, it is returned.
  *
  * Otherwise, %NULL is returned.
  */
@@ -928,9 +928,9 @@ repeat:
 			if (radix_tree_deref_retry(page))
 				goto repeat;
 			/*
-			 * Otherwise, shmem/tmpfs must be storing a swap entry
-			 * here as an exceptional entry: so return it without
-			 * attempting to raise page count.
+			 * A shadow entry of a recently evicted page,
+			 * or a swap entry from shmem/tmpfs.  Return
+			 * it without attempting to raise page count.
 			 */
 			goto out;
 		}
@@ -983,8 +983,8 @@ EXPORT_SYMBOL(find_get_page);
  * page cache page, it is returned locked and with an increased
  * refcount.
  *
- * If the slot holds a shadow entry of a previously evicted page, it
- * is returned.
+ * If the slot holds a shadow entry of a previously evicted page, or a
+ * swap entry from shmem/tmpfs, it is returned.
  *
  * Otherwise, %NULL is returned.
  *
@@ -1099,8 +1099,8 @@ EXPORT_SYMBOL(find_or_create_page);
  * with ascending indexes.  There may be holes in the indices due to
  * not-present pages.
  *
- * Any shadow entries of evicted pages are included in the returned
- * array.
+ * Any shadow entries of evicted pages, or swap entries from
+ * shmem/tmpfs, are included in the returned array.
  *
  * find_get_entries() returns the number of pages and shadow entries
  * which were found.
@@ -1128,9 +1128,9 @@ repeat:
 			if (radix_tree_deref_retry(page))
 				goto restart;
 			/*
-			 * Otherwise, we must be storing a swap entry
-			 * here as an exceptional entry: so return it
-			 * without attempting to raise page count.
+			 * A shadow entry of a recently evicted page,
+			 * or a swap entry from shmem/tmpfs.  Return
+			 * it without attempting to raise page count.
 			 */
 			goto export;
 		}
@@ -1198,9 +1198,9 @@ repeat:
 				goto restart;
 			}
 			/*
-			 * Otherwise, shmem/tmpfs must be storing a swap entry
-			 * here as an exceptional entry: so skip over it -
-			 * we only reach this from invalidate_mapping_pages().
+			 * A shadow entry of a recently evicted page,
+			 * or a swap entry from shmem/tmpfs.  Skip
+			 * over it.
 			 */
 			continue;
 		}
@@ -1265,9 +1265,9 @@ repeat:
 				goto restart;
 			}
 			/*
-			 * Otherwise, shmem/tmpfs must be storing a swap entry
-			 * here as an exceptional entry: so stop looking for
-			 * contiguous pages.
+			 * A shadow entry of a recently evicted page,
+			 * or a swap entry from shmem/tmpfs.  Stop
+			 * looking for contiguous pages.
 			 */
 			break;
 		}
@@ -1341,10 +1341,17 @@ repeat:
 				goto restart;
 			}
 			/*
-			 * This function is never used on a shmem/tmpfs
-			 * mapping, so a swap entry won't be found here.
+			 * A shadow entry of a recently evicted page.
+			 *
+			 * Those entries should never be tagged, but
+			 * this tree walk is lockless and the tags are
+			 * looked up in bulk, one radix tree node at a
+			 * time, so there is a sizable window for page
+			 * reclaim to evict a page we saw tagged.
+			 *
+			 * Skip over it.
 			 */
-			BUG();
+			continue;
 		}
 
 		if (!page_cache_get_speculative(page))
diff -puN mm/memcontrol.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries mm/memcontrol.c
--- a/mm/memcontrol.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries
+++ a/mm/memcontrol.c
@@ -6686,16 +6686,20 @@ static struct page *mc_handle_file_pte(s
 		pgoff = pte_to_pgoff(ptent);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-	page = find_get_page(mapping, pgoff);
-
 #ifdef CONFIG_SWAP
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	if (radix_tree_exceptional_entry(page)) {
-		swp_entry_t swap = radix_to_swp_entry(page);
-		if (do_swap_account)
-			*entry = swap;
-		page = find_get_page(swap_address_space(swap), swap.val);
-	}
+	if (shmem_mapping(mapping)) {
+		page = find_get_entry(mapping, pgoff);
+		if (radix_tree_exceptional_entry(page)) {
+			swp_entry_t swp = radix_to_swp_entry(page);
+			if (do_swap_account)
+				*entry = swp;
+			page = find_get_page(swap_address_space(swp), swp.val);
+		}
+	} else
+		page = find_get_page(mapping, pgoff);
+#else
+	page = find_get_page(mapping, pgoff);
 #endif
 	return page;
 }
diff -puN mm/truncate.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries mm/truncate.c
--- a/mm/truncate.c~mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries
+++ a/mm/truncate.c
@@ -484,14 +484,6 @@ unsigned long invalidate_mapping_pages(s
 	unsigned long count = 0;
 	int i;
 
-	/*
-	 * Note: this function may get called on a shmem/tmpfs mapping:
-	 * pagevec_lookup() might then return 0 prematurely (because it
-	 * got a gangful of swap entries); but it's hardly worth worrying
-	 * about - it can rarely have anything to free from such a mapping
-	 * (most pages are dirty), and already skips over any difficulties.
-	 */
-
 	pagevec_init(&pvec, 0);
 	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

