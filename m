From: akpm@linux-foundation.org
Subject: [merged] mm-swapc-reorganize-put_compound_page.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:29 -0800
Message-ID: <52e0262d.+URPgH06gYGA24GC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [merged] mm-swapc-reorganize-put_compound_page.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:29 -0800


The patch titled
     Subject: mm/swap.c: reorganize put_compound_page()
has been removed from the -mm tree.  Its filename was
     mm-swapc-reorganize-put_compound_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/swap.c: reorganize put_compound_page()

Tweak it so save a tab stop, make code layout slightly less nutty.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  254 +++++++++++++++++++++++++---------------------------
 1 file changed, 125 insertions(+), 129 deletions(-)

diff -puN mm/swap.c~mm-swapc-reorganize-put_compound_page mm/swap.c
--- a/mm/swap.c~mm-swapc-reorganize-put_compound_page
+++ a/mm/swap.c
@@ -81,154 +81,150 @@ static void __put_compound_page(struct p
 
 static void put_compound_page(struct page *page)
 {
-	if (unlikely(PageTail(page))) {
-		/* __split_huge_page_refcount can run under us */
-		struct page *page_head = compound_trans_head(page);
+	struct page *page_head;
 
-		/*
-		 * THP can not break up slab pages so avoid taking
-		 * compound_lock() and skip the tail page refcounting
-		 * (in _mapcount) too. Slab performs non-atomic bit
-		 * ops on page->flags for better performance. In
-		 * particular slab_unlock() in slub used to be a hot
-		 * path. It is still hot on arches that do not support
-		 * this_cpu_cmpxchg_double().
-		 *
-		 * If "page" is part of a slab or hugetlbfs page it
-		 * cannot be splitted and the head page cannot change
-		 * from under us. And if "page" is part of a THP page
-		 * under splitting, if the head page pointed by the
-		 * THP tail isn't a THP head anymore, we'll find
-		 * PageTail clear after smp_rmb() and we'll treat it
-		 * as a single page.
-		 */
-		if (!__compound_tail_refcounted(page_head)) {
+	if (likely(!PageTail(page))) {
+		if (put_page_testzero(page)) {
 			/*
-			 * If "page" is a THP tail, we must read the tail page
-			 * flags after the head page flags. The
-			 * split_huge_page side enforces write memory
-			 * barriers between clearing PageTail and before the
-			 * head page can be freed and reallocated.
+			 * By the time all refcounts have been released
+			 * split_huge_page cannot run anymore from under us.
 			 */
-			smp_rmb();
-			if (likely(PageTail(page))) {
-				/*
-				 * __split_huge_page_refcount
-				 * cannot race here.
-				 */
-				VM_BUG_ON(!PageHead(page_head));
-				VM_BUG_ON(page_mapcount(page) != 0);
-				if (put_page_testzero(page_head)) {
-					/*
-					 * If this is the tail of a
-					 * slab compound page, the
-					 * tail pin must not be the
-					 * last reference held on the
-					 * page, because the PG_slab
-					 * cannot be cleared before
-					 * all tail pins (which skips
-					 * the _mapcount tail
-					 * refcounting) have been
-					 * released. For hugetlbfs the
-					 * tail pin may be the last
-					 * reference on the page
-					 * instead, because
-					 * PageHeadHuge will not go
-					 * away until the compound
-					 * page enters the buddy
-					 * allocator.
-					 */
-					VM_BUG_ON(PageSlab(page_head));
-					__put_compound_page(page_head);
-				}
-				return;
-			} else
-				/*
-				 * __split_huge_page_refcount
-				 * run before us, "page" was a
-				 * THP tail. The split
-				 * page_head has been freed
-				 * and reallocated as slab or
-				 * hugetlbfs page of smaller
-				 * order (only possible if
-				 * reallocated as slab on
-				 * x86).
-				 */
-				goto out_put_single;
+			if (PageHead(page))
+				__put_compound_page(page);
+			else
+				__put_single_page(page);
 		}
+		return;
+	}
 
-		if (likely(page != page_head &&
-			   get_page_unless_zero(page_head))) {
-			unsigned long flags;
+	/* __split_huge_page_refcount can run under us */
+	page_head = compound_trans_head(page);
 
+	/*
+	 * THP can not break up slab pages so avoid taking
+	 * compound_lock() and skip the tail page refcounting (in
+	 * _mapcount) too. Slab performs non-atomic bit ops on
+	 * page->flags for better performance. In particular
+	 * slab_unlock() in slub used to be a hot path. It is still
+	 * hot on arches that do not support
+	 * this_cpu_cmpxchg_double().
+	 *
+	 * If "page" is part of a slab or hugetlbfs page it cannot be
+	 * splitted and the head page cannot change from under us. And
+	 * if "page" is part of a THP page under splitting, if the
+	 * head page pointed by the THP tail isn't a THP head anymore,
+	 * we'll find PageTail clear after smp_rmb() and we'll treat
+	 * it as a single page.
+	 */
+	if (!__compound_tail_refcounted(page_head)) {
+		/*
+		 * If "page" is a THP tail, we must read the tail page
+		 * flags after the head page flags. The
+		 * split_huge_page side enforces write memory barriers
+		 * between clearing PageTail and before the head page
+		 * can be freed and reallocated.
+		 */
+		smp_rmb();
+		if (likely(PageTail(page))) {
 			/*
-			 * page_head wasn't a dangling pointer but it
-			 * may not be a head page anymore by the time
-			 * we obtain the lock. That is ok as long as it
-			 * can't be freed from under us.
+			 * __split_huge_page_refcount cannot race
+			 * here.
 			 */
-			flags = compound_lock_irqsave(page_head);
-			if (unlikely(!PageTail(page))) {
-				/* __split_huge_page_refcount run before us */
-				compound_unlock_irqrestore(page_head, flags);
-				if (put_page_testzero(page_head)) {
-					/*
-					 * The head page may have been
-					 * freed and reallocated as a
-					 * compound page of smaller
-					 * order and then freed again.
-					 * All we know is that it
-					 * cannot have become: a THP
-					 * page, a compound page of
-					 * higher order, a tail page.
-					 * That is because we still
-					 * hold the refcount of the
-					 * split THP tail and
-					 * page_head was the THP head
-					 * before the split.
-					 */
-					if (PageHead(page_head))
-						__put_compound_page(page_head);
-					else
-						__put_single_page(page_head);
-				}
-out_put_single:
-				if (put_page_testzero(page))
-					__put_single_page(page);
-				return;
+			VM_BUG_ON(!PageHead(page_head));
+			VM_BUG_ON(page_mapcount(page) != 0);
+			if (put_page_testzero(page_head)) {
+				/*
+				 * If this is the tail of a slab
+				 * compound page, the tail pin must
+				 * not be the last reference held on
+				 * the page, because the PG_slab
+				 * cannot be cleared before all tail
+				 * pins (which skips the _mapcount
+				 * tail refcounting) have been
+				 * released. For hugetlbfs the tail
+				 * pin may be the last reference on
+				 * the page instead, because
+				 * PageHeadHuge will not go away until
+				 * the compound page enters the buddy
+				 * allocator.
+				 */
+				VM_BUG_ON(PageSlab(page_head));
+				__put_compound_page(page_head);
 			}
-			VM_BUG_ON(page_head != page->first_page);
+			return;
+		} else
 			/*
-			 * We can release the refcount taken by
-			 * get_page_unless_zero() now that
-			 * __split_huge_page_refcount() is blocked on
-			 * the compound_lock.
+			 * __split_huge_page_refcount run before us,
+			 * "page" was a THP tail. The split page_head
+			 * has been freed and reallocated as slab or
+			 * hugetlbfs page of smaller order (only
+			 * possible if reallocated as slab on x86).
 			 */
-			if (put_page_testzero(page_head))
-				VM_BUG_ON(1);
-			/* __split_huge_page_refcount will wait now */
-			VM_BUG_ON(page_mapcount(page) <= 0);
-			atomic_dec(&page->_mapcount);
-			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
-			VM_BUG_ON(atomic_read(&page->_count) != 0);
-			compound_unlock_irqrestore(page_head, flags);
+			goto out_put_single;
+	}
+
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		unsigned long flags;
 
+		/*
+		 * page_head wasn't a dangling pointer but it may not
+		 * be a head page anymore by the time we obtain the
+		 * lock. That is ok as long as it can't be freed from
+		 * under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		if (unlikely(!PageTail(page))) {
+			/* __split_huge_page_refcount run before us */
+			compound_unlock_irqrestore(page_head, flags);
 			if (put_page_testzero(page_head)) {
+				/*
+				 * The head page may have been freed
+				 * and reallocated as a compound page
+				 * of smaller order and then freed
+				 * again.  All we know is that it
+				 * cannot have become: a THP page, a
+				 * compound page of higher order, a
+				 * tail page.  That is because we
+				 * still hold the refcount of the
+				 * split THP tail and page_head was
+				 * the THP head before the split.
+				 */
 				if (PageHead(page_head))
 					__put_compound_page(page_head);
 				else
 					__put_single_page(page_head);
 			}
-		} else {
-			/* page_head is a dangling pointer */
-			VM_BUG_ON(PageTail(page));
-			goto out_put_single;
+out_put_single:
+			if (put_page_testzero(page))
+				__put_single_page(page);
+			return;
+		}
+		VM_BUG_ON(page_head != page->first_page);
+		/*
+		 * We can release the refcount taken by
+		 * get_page_unless_zero() now that
+		 * __split_huge_page_refcount() is blocked on the
+		 * compound_lock.
+		 */
+		if (put_page_testzero(page_head))
+			VM_BUG_ON(1);
+		/* __split_huge_page_refcount will wait now */
+		VM_BUG_ON(page_mapcount(page) <= 0);
+		atomic_dec(&page->_mapcount);
+		VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
+		VM_BUG_ON(atomic_read(&page->_count) != 0);
+		compound_unlock_irqrestore(page_head, flags);
+
+		if (put_page_testzero(page_head)) {
+			if (PageHead(page_head))
+				__put_compound_page(page_head);
+			else
+				__put_single_page(page_head);
 		}
-	} else if (put_page_testzero(page)) {
-		if (PageHead(page))
-			__put_compound_page(page);
-		else
-			__put_single_page(page);
+	} else {
+		/* page_head is a dangling pointer */
+		VM_BUG_ON(PageTail(page));
+		goto out_put_single;
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
mm.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

