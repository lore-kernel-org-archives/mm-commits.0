From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:07 -0700
Message-ID: <200705080815.l488F7Ib019031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934653AbXEHIRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: call scheme: cleanup
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-cleanup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: call scheme: cleanup
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Merge two similar page_cache_readahead_adaptive() calls into one.

No behavior change.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/filemap.c~readahead-call-scheme-cleanup mm/filemap.c
--- a/mm/filemap.c~readahead-call-scheme-cleanup
+++ a/mm/filemap.c
@@ -936,17 +936,13 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (prefer_adaptive_readahead()) {
-			if (unlikely(page == NULL)) {
-				ra.prev_index = prev_index;
-				page_cache_readahead_adaptive(mapping,
-						&ra, filp, NULL,
-						index, last_index - index);
-				page = find_get_page(mapping, index);
-			} else if (PageReadahead(page)) {
+			if (!page || PageReadahead(page)) {
 				ra.prev_index = prev_index;
 				page_cache_readahead_adaptive(mapping,
 						&ra, filp, page,
 						index, last_index - index);
+				if (!page)
+					page = find_get_page(mapping, index);
 			}
 		}
 		if (unlikely(page == NULL)) {
@@ -1422,13 +1418,11 @@ struct page *filemap_fault(struct vm_are
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
 	if (prefer_adaptive_readahead() && VM_SequentialReadHint(vma)) {
-		if (!page) {
-			page_cache_readahead_adaptive(mapping, ra, file, NULL,
-							fdata->pgoff, 1);
-			page = find_lock_page(mapping, fdata->pgoff);
-		} else if (PageReadahead(page)) {
+		if (!page || PageReadahead(page)) {
 			page_cache_readahead_adaptive(mapping, ra, file, page,
 							fdata->pgoff, 1);
+			if (!page)
+				page = find_lock_page(mapping, fdata->pgoff);
 		}
 	}
 	if (!page) {
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
