From: akpm@linux-foundation.org
Subject: + mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch added to -mm tree
Date: Tue, 17 Feb 2009 13:57:35 -0800
Message-ID: <200902172157.n1HLvZ3Y027324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbZBQWEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:04:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de


The patch titled
     mm: add comment why mark_page_accessed() would be better than pte_mkyoung() in follow_page()
has been added to the -mm tree.  Its filename is
     mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch

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
+		 * is needed to avoid losing dirty bit: easier to
+		 * mark_page_accessed().
+		 */
 		mark_page_accessed(page);
 	}
 unlock:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmalloc-add-__get_vm_area_caller.patch
vmalloc-add-__get_vm_area_caller-checkpatch-fixes.patch
linux-next.patch
mm-clean-up-for-early_pfn_to_nid.patch
mm-fix-memmap-init-for-handling-memory-hole.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

