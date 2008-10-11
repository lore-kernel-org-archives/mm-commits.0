From: akpm@linux-foundation.org
Subject: + vmscan-fix-pagecache-reclaim-referenced-bit-check.patch added to -mm tree
Date: Sat, 11 Oct 2008 14:27:23 -0700
Message-ID: <200810112127.m9BLRNuN011425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbYJKV1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 11 Oct 2008 17:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     vmscan: fix pagecache reclaim referenced bit check
has been added to the -mm tree.  Its filename is
     vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

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
Subject: vmscan: fix pagecache reclaim referenced bit check
From: Rik van Riel <riel@redhat.com>

Moving referenced pages back to the head of the active list creates a huge
scalability problem, because by the time a large memory system finally
runs out of free memory, every single page in the system will have been
referenced.

Not only do we not have the time to scan every single page on the active
list, but since they have will all have the referenced bit set, that bit
conveys no useful information.

A more scalable solution is to just move every page that hits the end of
the active list to the inactive list.

We clear the referenced bit off of mapped pages, which need just one
reference to be moved back onto the active list.

Unmapped pages will be moved back to the active list after two references
(see mark_page_accessed).  We preserve the PG_referenced flag on unmapped
pages to preserve accesses that were made while the page was on the active
list.

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check
+++ a/mm/vmscan.c
@@ -1096,6 +1096,13 @@ static void shrink_active_list(unsigned 
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
 		list_add(&page->lru, &l_inactive);
+		if (!page_mapping_inuse(page)) {
+			/*
+			 * Bypass use-once, make the next access count. See
+			 * mark_page_accessed and shrink_page_list.
+			 */
+			SetPageReferenced(page);
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from riel@redhat.com are

git-tip.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
vmscam-kill-unused-lru-functions.patch
vmscan-dont-accumulate-scan-pressure-on-unrelated-lists.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

