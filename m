From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-use-page_count-without-a-page-pin.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:19 -0700
Message-ID: <201106150124.p5F1OaMV031960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293Ab1FOBZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     mm: vmscan: do not use page_count without a page pin
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-use-page_count-without-a-page-pin.patch

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
Subject: mm: vmscan: do not use page_count without a page pin
From: Andrea Arcangeli <aarcange@redhat.com>

It is unsafe to run page_count during the physical pfn scan because
compound_head could trip on a dangling pointer when reading
page->first_page if the compound page is being freed by another CPU.

[mgorman@suse.de: split out patch]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-use-page_count-without-a-page-pin mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-use-page_count-without-a-page-pin
+++ a/mm/vmscan.c
@@ -1124,8 +1124,20 @@ static unsigned long isolate_lru_pages(u
 					nr_lumpy_dirty++;
 				scan++;
 			} else {
-				/* the page is freed already. */
-				if (!page_count(cursor_page))
+				/*
+				 * Check if the page is freed already.
+				 *
+				 * We can't use page_count() as that
+				 * requires compound_head and we don't
+				 * have a pin on the page here. If a
+				 * page is tail, we may or may not
+				 * have isolated the head, so assume
+				 * it's not free, it'd be tricky to
+				 * track the head status without a
+				 * page pin.
+				 */
+				if (!PageTail(cursor_page) &&
+				    !atomic_read(&cursor_page->_count))
 					continue;
 				break;
 			}
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
include-asm-generic-pgtableh-fix-unbalanced-parenthesis.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
mm-memory-failurec-fix-page-isolated-count-mismatch.patch
mm-vmscan-do-not-use-page_count-without-a-page-pin.patch
ksm-fix-null-pointer-dereference-in-scan_get_next_rmap_item.patch
pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch
pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch
pagewalk-add-locking-rule-comments.patch
pagewalk-add-locking-rule-comments-fix.patch
pagewalk-fix-code-comment-for-thp.patch

