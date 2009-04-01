From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:33 -0700
Message-ID: <200904011834.n31IYXiL007201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760787AbZDAShv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: add comment why mark_page_accessed() would be better than pte_mkyoung() in follow_page()
has been removed from the -mm tree.  Its filename was
     mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add comment why mark_page_accessed() would be better than pte_mkyoung() in follow_page()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

At first look, mark_page_accessed() in follow_page() seems a bit strange. 
It seems pte_mkyoung() would be better consistent with other kernel code.

However, it is intentional. The commit log said:

    ------------------------------------------------
    commit 9e45f61d69be9024a2e6bef3831fb04d90fac7a8
    Author: akpm <akpm>
    Date:   Fri Aug 15 07:24:59 2003 +0000

    [PATCH] Use mark_page_accessed() in follow_page()

    Touching a page via follow_page() counts as a reference so we should be
    either setting the referenced bit in the pte or running mark_page_accessed().

    Altering the pte is tricky because we haven't implemented an atomic
    pte_mkyoung().  And mark_page_accessed() is better anyway because it has more
    aging state: it can move the page onto the active list.

    BKrev: 3f3c8acbplT8FbwBVGtth7QmnqWkIw
    ------------------------------------------------

The atomic issue is still true nowadays. adding comment help to understand
code intention and it would be better.

[akpm@linux-foundation.org: clarify text]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/memory.c~mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page mm/memory.c
--- a/mm/memory.c~mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page
+++ a/mm/memory.c
@@ -1151,6 +1151,11 @@ struct page *follow_page(struct vm_area_
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
 			set_page_dirty(page);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing the dirty bit: it is easier to use
+		 * mark_page_accessed().
+		 */
 		mark_page_accessed(page);
 	}
 unlock:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

