From: akpm@linux-foundation.org
Subject: + hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch added to -mm tree
Date: Fri, 20 Nov 2009 13:26:05 -0800
Message-ID: <200911202126.nAKLQ5gq030268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbZKTV1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 16:27:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lwoodman@redhat.com, agl@us.ibm.com, apw@shadowen.org, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, lwooman@redhat.com, mel@csn.ul.ie


The patch titled
     hugetlb: prevent deadlock in __unmap_hugepage_range() when alloc_huge_page() fails
has been added to the -mm tree.  Its filename is
     hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch

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
Subject: hugetlb: prevent deadlock in __unmap_hugepage_range() when alloc_huge_page() fails
From: Larry Woodman <lwoodman@redhat.com>

hugetlb_fault() takes the mm->page_table_lock spinlock then calls
hugetlb_cow().  If the alloc_huge_page() in hugetlb_cow() fails due to an
insufficient huge page pool it calls unmap_ref_private() with the
mm->page_table_lock held.  unmap_ref_private() then calls
unmap_hugepage_range() which tries to acquire the mm->page_table_lock.

[<ffffffff810928c3>] print_circular_bug_tail+0x80/0x9f
 [<ffffffff8109280b>] ? check_noncircular+0xb0/0xe8
 [<ffffffff810935e0>] __lock_acquire+0x956/0xc0e
 [<ffffffff81093986>] lock_acquire+0xee/0x12e
 [<ffffffff8111a7a6>] ? unmap_hugepage_range+0x3e/0x84
 [<ffffffff8111a7a6>] ? unmap_hugepage_range+0x3e/0x84
 [<ffffffff814c348d>] _spin_lock+0x40/0x89
 [<ffffffff8111a7a6>] ? unmap_hugepage_range+0x3e/0x84
 [<ffffffff8111afee>] ? alloc_huge_page+0x218/0x318
 [<ffffffff8111a7a6>] unmap_hugepage_range+0x3e/0x84
 [<ffffffff8111b2d0>] hugetlb_cow+0x1e2/0x3f4
 [<ffffffff8111b935>] ? hugetlb_fault+0x453/0x4f6
 [<ffffffff8111b962>] hugetlb_fault+0x480/0x4f6
 [<ffffffff8111baee>] follow_hugetlb_page+0x116/0x2d9
 [<ffffffff814c31a7>] ? _spin_unlock_irq+0x3a/0x5c
 [<ffffffff81107b4d>] __get_user_pages+0x2a3/0x427
 [<ffffffff81107d0f>] get_user_pages+0x3e/0x54
 [<ffffffff81040b8b>] get_user_pages_fast+0x170/0x1b5
 [<ffffffff81160352>] dio_get_page+0x64/0x14a
 [<ffffffff8116112a>] __blockdev_direct_IO+0x4b7/0xb31
 [<ffffffff8115ef91>] blkdev_direct_IO+0x58/0x6e
 [<ffffffff8115e0a4>] ? blkdev_get_blocks+0x0/0xb8
 [<ffffffff810ed2c5>] generic_file_aio_read+0xdd/0x528
 [<ffffffff81219da3>] ? avc_has_perm+0x66/0x8c
 [<ffffffff81132842>] do_sync_read+0xf5/0x146
 [<ffffffff8107da00>] ? autoremove_wake_function+0x0/0x5a
 [<ffffffff81211857>] ? security_file_permission+0x24/0x3a
 [<ffffffff81132fd8>] vfs_read+0xb5/0x126
 [<ffffffff81133f6b>] ? fget_light+0x5e/0xf8
 [<ffffffff81133131>] sys_read+0x54/0x8c
 [<ffffffff81011e42>] system_call_fastpath+0x16/0x1b

This can be fixed by dropping the mm->page_table_lock around the call to
unmap_ref_private() if alloc_huge_page() fails, its dropped right below in
the normal path anyway.  However, earlier in the that function, it's also
possible to call into the page allocator with the same spinlock held.

What this patch does is drop the spinlock before the page allocator is
potentially entered.  The check for page allocation failure can be made
without the page_table_lock as well as the copy of the huge page.  Even if
the PTE changed while the spinlock was held, the consequence is that a
huge page is copied unnecessarily.  This resolves both the double taking
of the lock and sleeping with the spinlock held.

[mel@csn.ul.ie: Cover also the case where process can sleep with spinlock]
Signed-off-by: Larry Woodman <lwooman@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2
+++ a/mm/hugetlb.c
@@ -2293,6 +2293,9 @@ retry_avoidcopy:
 		outside_reserve = 1;
 
 	page_cache_get(old_page);
+
+	/* Drop page_table_lock as buddy allocator may be called */
+	spin_unlock(&mm->page_table_lock);
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
@@ -2310,19 +2313,25 @@ retry_avoidcopy:
 			if (unmap_ref_private(mm, vma, old_page, address)) {
 				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
+				spin_lock(&mm->page_table_lock);
 				goto retry_avoidcopy;
 			}
 			WARN_ON_ONCE(1);
 		}
 
+		/* Caller expects lock to be held */
+		spin_lock(&mm->page_table_lock);
 		return -PTR_ERR(new_page);
 	}
 
-	spin_unlock(&mm->page_table_lock);
 	copy_huge_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
-	spin_lock(&mm->page_table_lock);
 
+	/*
+	 * Retake the page_table_lock to check for racing updates
+	 * before the page tables are altered
+	 */
+	spin_lock(&mm->page_table_lock);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
_

Patches currently in -mm which might be from lwoodman@redhat.com are

hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch

