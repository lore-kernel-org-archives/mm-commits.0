From: akpm@linux-foundation.org
Subject: + memcg-clear-pc-mem_cgorup-if-necessary-comments.patch added to -mm tree
Date: Tue, 20 Dec 2011 14:13:55 -0800
Message-ID: <20111220221355.ECA6120005F@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37443 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:13:58 -0500
Received: by eaad1 with SMTP id d1so202944eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:13:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: memcg-clear-pc-mem_cgorup-if-necessary-comments
has been added to the -mm tree.  Its filename is
     memcg-clear-pc-mem_cgorup-if-necessary-comments.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg-clear-pc-mem_cgorup-if-necessary-comments

Add comments to the clearing sites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c        |    9 +++++++++
 mm/swap_state.c |    9 +++++++++
 2 files changed, 18 insertions(+)

diff -puN mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary-comments mm/ksm.c
--- a/mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary-comments
+++ a/mm/ksm.c
@@ -1571,6 +1571,15 @@ struct page *ksm_does_need_to_copy(struc
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		/*
+		 * The memcg-specific accounting when moving
+		 * pages around the LRU lists relies on the
+		 * page's owner (memcg) to be valid.  Usually,
+		 * pages are assigned to a new owner before
+		 * being put on the LRU list, but since this
+		 * is not the case here, the stale owner from
+		 * a previous allocation cycle must be reset.
+		 */
 		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
diff -puN mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary-comments mm/swap_state.c
--- a/mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary-comments
+++ a/mm/swap_state.c
@@ -301,6 +301,15 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			/*
+			 * The memcg-specific accounting when moving
+			 * pages around the LRU lists relies on the
+			 * page's owner (memcg) to be valid.  Usually,
+			 * pages are assigned to a new owner before
+			 * being put on the LRU list, but since this
+			 * is not the case here, the stale owner from
+			 * a previous allocation cycle must be reset.
+			 */
 			mem_cgroup_reset_owner(new_page);
 		}
 
_
Subject: Subject: memcg-clear-pc-mem_cgorup-if-necessary-comments

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-comments.patch
memcg-simplify-lru-handling-by-new-rule.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch

