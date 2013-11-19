From: akpm@linux-foundation.org
Subject: + mm-swapc-reorganize-put_compound_page.patch added to -mm tree
Date: Tue, 19 Nov 2013 15:14:37 -0800
Message-ID: <528bf0dd.TK4kFsKyiitANXV/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3KSXOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: + mm-swapc-reorganize-put_compound_page.patch added to -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:14:37 -0800


The patch titled
     Subject: mm/swap.c: reorganize put_compound_page()
has been added to the -mm tree.  Its filename is
     mm-swapc-reorganize-put_compound_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-reorganize-put_compound_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-reorganize-put_compound_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/swap.c: reorganize put_compound_page()

Tweak it so save a tab stop, make code layout slightly less nutty.

Cc: Andrea Arcangeli <aarcange@redhat.com>
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

 mm/swap.c |  238 +++++++++++++++++++++++-----------------------------
 1 file changed, 107 insertions(+), 131 deletions(-)

diff -puN mm/swap.c~mm-swapc-reorganize-put_compound_page mm/swap.c
--- a/mm/swap.c~mm-swapc-reorganize-put_compound_page
+++ a/mm/swap.c
@@ -82,150 +82,126 @@ static void __put_compound_page(struct p
 
 static void put_compound_page(struct page *page)
 {
-	if (unlikely(PageTail(page))) {
-		/* __split_huge_page_refcount can run under us */
-		struct page *page_head = compound_trans_head(page);
-
-		if (likely(page != page_head &&
-			   get_page_unless_zero(page_head))) {
-			unsigned long flags;
-
-			/*
-			 * THP can not break up slab pages or
-			 * hugetlbfs pages so avoid taking
-			 * compound_lock() and skip the tail page
-			 * refcounting (in _mapcount) too. Slab
-			 * performs non-atomic bit ops on page->flags
-			 * for better performance. In particular
-			 * slab_unlock() in slub used to be a hot
-			 * path. It is still hot on arches that do not
-			 * support this_cpu_cmpxchg_double().
-			 */
-			if (PageSlab(page_head) || PageHeadHuge(page_head)) {
-				if (likely(PageTail(page))) {
-					/*
-					 * __split_huge_page_refcount
-					 * cannot race here.
-					 */
-					VM_BUG_ON(!PageHead(page_head));
-					VM_BUG_ON(atomic_read(&page->_mapcount)
-						  != -1);
-					if (put_page_testzero(page_head))
-						VM_BUG_ON(1);
-					if (put_page_testzero(page_head)) {
-						/*
-						 * If this is the tail
-						 * of a a slab
-						 * compound page, the
-						 * tail pin must not
-						 * be the last
-						 * reference held on
-						 * the page, because
-						 * the PG_slab cannot
-						 * be cleared before
-						 * all tail pins
-						 * (which skips the
-						 * _mapcount tail
-						 * refcounting) have
-						 * been released. For
-						 * hugetlbfs the tail
-						 * pin may be the last
-						 * reference on the
-						 * page instead,
-						 * because
-						 * PageHeadHuge will
-						 * not go away until
-						 * the compound page
-						 * enters the buddy
-						 * allocator.
-						 */
-						VM_BUG_ON(PageSlab(page_head));
-						__put_compound_page(page_head);
-					}
-					return;
-				} else
-					/*
-					 * __split_huge_page_refcount
-					 * run before us, "page" was a
-					 * THP tail. The split
-					 * page_head has been freed
-					 * and reallocated as slab or
-					 * hugetlbfs page of smaller
-					 * order (only possible if
-					 * reallocated as slab on
-					 * x86).
-					 */
-					goto skip_lock;
-			}
-			/*
-			 * page_head wasn't a dangling pointer but it
-			 * may not be a head page anymore by the time
-			 * we obtain the lock. That is ok as long as it
-			 * can't be freed from under us.
-			 */
-			flags = compound_lock_irqsave(page_head);
-			if (unlikely(!PageTail(page))) {
-				/* __split_huge_page_refcount run before us */
-				compound_unlock_irqrestore(page_head, flags);
-skip_lock:
+	struct page *page_head;
+
+	if (likely(PageTail(page))) {
+		if (put_page_testzero(page)) {
+			if (PageHead(page))
+				__put_compound_page(page);
+			else
+				__put_single_page(page);
+		}
+		return;
+	}
+
+	/* __split_huge_page_refcount can run under us */
+	page_head = compound_trans_head(page);
+
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		unsigned long flags;
+
+		/*
+		 * THP can not break up slab pages or hugetlbfs pages so avoid
+		 * taking compound_lock() and skip the tail page refcounting
+		 * (in _mapcount) too. Slab performs non-atomic bit ops on
+		 * page->flags for better performance. In particular
+		 * slab_unlock() in slub used to be a hot path. It is still hot
+		 * on arches that do not support this_cpu_cmpxchg_double().
+		 */
+		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+			if (likely(PageTail(page))) {
+				/*
+				 * __split_huge_page_refcount cannot race here.
+				 */
+				VM_BUG_ON(!PageHead(page_head));
+				VM_BUG_ON(atomic_read(&page->_mapcount) != -1);
+				if (put_page_testzero(page_head))
+					VM_BUG_ON(1);
 				if (put_page_testzero(page_head)) {
 					/*
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
+					 * If this is the tail of a slab
+					 * compound page, the tail pin must not
+					 * be the last reference held on the
+					 * page, because the PG_slab cannot be
+					 * cleared before all tail pins (which
+					 * skips the _mapcount tail refcounting)
+					 * have been released. For hugetlbfs the
+					 * tail pin may be the last reference on
+					 * the page instead, because
+					 * PageHeadHuge will not go away until
+					 * the compound page enters the buddy
+					 * allocator.
 					 */
-					if (PageHead(page_head))
-						__put_compound_page(page_head);
-					else
-						__put_single_page(page_head);
+					VM_BUG_ON(PageSlab(page_head));
+					__put_compound_page(page_head);
 				}
-out_put_single:
-				if (put_page_testzero(page))
-					__put_single_page(page);
 				return;
-			}
-			VM_BUG_ON(page_head != page->first_page);
-			/*
-			 * We can release the refcount taken by
-			 * get_page_unless_zero() now that
-			 * __split_huge_page_refcount() is blocked on
-			 * the compound_lock.
-			 */
-			if (put_page_testzero(page_head))
-				VM_BUG_ON(1);
-			/* __split_huge_page_refcount will wait now */
-			VM_BUG_ON(page_mapcount(page) <= 0);
-			atomic_dec(&page->_mapcount);
-			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
-			VM_BUG_ON(atomic_read(&page->_count) != 0);
+			} else
+				/*
+				 * __split_huge_page_refcount run before us,
+				 * "page" was a THP tail. The split page_head
+				 * has been freed and reallocated as slab or
+				 * hugetlbfs page of smaller order (only
+				 * possible if reallocated as slab on x86).
+				 */
+				goto skip_lock;
+		}
+		/*
+		 * page_head wasn't a dangling pointer but it may not be a head
+		 * page anymore by the time we obtain the lock. That is ok as
+		 * long as it can't be freed from under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		if (unlikely(!PageTail(page))) {
+			/* __split_huge_page_refcount run before us */
 			compound_unlock_irqrestore(page_head, flags);
-
+skip_lock:
 			if (put_page_testzero(page_head)) {
+				/*
+				 * The head page may have been freed and
+				 * reallocated as a compound page of smaller
+				 * order and then freed again.  All we know is
+				 * that it cannot have become: a THP page, a
+				 * compound page of higher order, a tail page.
+				 * That is because we still hold the refcount of
+				 * the split THP tail and page_head was the THP
+				 * head before the split.
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
+		 * We can release the refcount taken by get_page_unless_zero()
+		 * now that __split_huge_page_refcount() is blocked on the
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
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

