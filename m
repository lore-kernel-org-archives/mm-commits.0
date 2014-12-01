From: akpm@linux-foundation.org
Subject: + mm-fix-swapoff-hang-after-page-migration-and-fork.patch added
 to -mm tree
Date: Mon, 01 Dec 2014 13:58:00 -0800
Message-ID: <547ce468.mUY5KvQ+NVheWUkq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaLAV6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 16:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kelleynnn@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix swapoff hang after page migration and fork
has been added to the -mm tree.  Its filename is
     mm-fix-swapoff-hang-after-page-migration-and-fork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-swapoff-hang-after-page-migration-and-fork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-swapoff-hang-after-page-migration-and-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix swapoff hang after page migration and fork

I've been seeing swapoff hangs in recent testing: it's cycling around
trying unsuccessfully to find an mm for some remaining pages of swap.

I have been exercising swap and page migration more heavily recently, and
now notice a long-standing error in copy_one_pte(): it's trying to add
dst_mm to swapoff's mmlist when it finds a swap entry, but is doing so
even when it's a migration entry or an hwpoison entry.

Which wouldn't matter much, except it adds dst_mm next to src_mm, assuming
src_mm is already on the mmlist: which may not be so.  Then if pages are
later swapped out from dst_mm, swapoff won't be able to find where to
replace them.

There's already a !non_swap_entry() test for stats: move that up before
the swap_duplicate() and the addition to mmlist.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: <stable@vger.kernel.org>	[2.6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~mm-fix-swapoff-hang-after-page-migration-and-fork mm/memory.c
--- a/mm/memory.c~mm-fix-swapoff-hang-after-page-migration-and-fork
+++ a/mm/memory.c
@@ -815,20 +815,20 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		if (!pte_file(pte)) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (swap_duplicate(entry) < 0)
-				return entry.val;
+			if (likely(!non_swap_entry(entry))) {
+				if (swap_duplicate(entry) < 0)
+					return entry.val;
 
-			/* make sure dst_mm is on swapoff's mmlist. */
-			if (unlikely(list_empty(&dst_mm->mmlist))) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&dst_mm->mmlist))
-					list_add(&dst_mm->mmlist,
-						 &src_mm->mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			if (likely(!non_swap_entry(entry)))
+				/* make sure dst_mm is on swapoff's mmlist. */
+				if (unlikely(list_empty(&dst_mm->mmlist))) {
+					spin_lock(&mmlist_lock);
+					if (list_empty(&dst_mm->mmlist))
+						list_add(&dst_mm->mmlist,
+							 &src_mm->mmlist);
+					spin_unlock(&mmlist_lock);
+				}
 				rss[MM_SWAPENTS]++;
-			else if (is_migration_entry(entry)) {
+			} else if (is_migration_entry(entry)) {
 				page = migration_entry_to_page(entry);
 
 				if (PageAnon(page))
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-swapoff-hang-after-page-migration-and-fork.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-mincore-add-hwpoison-page-handle.patch
ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-fix-anon_vma_clone-error-treatment.patch
mm-unmapped-page-migration-avoid-unmapremap-overhead.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

