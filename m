From: akpm@linux-foundation.org
Subject: + readahead-convert-filemap-invocations.patch added to -mm tree
Date: Fri, 18 May 2007 23:29:01 -0700
Message-ID: <200705190629.l4J6T0TN031276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbXESGbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:31:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, slpratt@austin.ibm.com


The patch titled
     readahead: convert filemap invocations
has been added to the -mm tree.  Its filename is
     readahead-convert-filemap-invocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: convert filemap invocations
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Convert filemap reads to use on-demand readahead.

The new call scheme is to
- call readahead on non-cached page
- call readahead on look-ahead page
- update prev_index when finished with the read request

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN mm/filemap.c~readahead-convert-filemap-invocations mm/filemap.c
--- a/mm/filemap.c~readahead-convert-filemap-invocations
+++ a/mm/filemap.c
@@ -908,15 +908,20 @@ void do_generic_mapping_read(struct addr
 		nr = nr - offset;
 
 		cond_resched();
-		if (index == next_index)
-			next_index = page_cache_readahead(mapping, &ra, filp,
-					index, last_index - index);
-
 find_page:
 		page = find_get_page(mapping, index);
-		if (unlikely(page == NULL)) {
-			handle_ra_miss(mapping, &ra, index);
-			goto no_cached_page;
+		if (!page) {
+			page_cache_readahead_ondemand(mapping,
+					&ra, filp, page,
+					index, last_index - index);
+			page = find_get_page(mapping, index);
+			if (unlikely(page == NULL))
+				goto no_cached_page;
+		}
+		if (PageReadahead(page)) {
+			page_cache_readahead_ondemand(mapping,
+					&ra, filp, page,
+					index, last_index - index);
 		}
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
@@ -1067,6 +1072,7 @@ no_cached_page:
 
 out:
 	*_ra = ra;
+	_ra->prev_index = prev_index;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
@@ -1370,26 +1376,30 @@ struct page *filemap_fault(struct vm_are
 		goto no_cached_page;
 
 	/*
-	 * The readahead code wants to be told about each and every page
-	 * so it can build and shrink its windows appropriately
-	 *
-	 * For sequential accesses, we use the generic readahead logic.
-	 */
-	if (VM_SequentialReadHint(vma))
-		page_cache_readahead(mapping, ra, file, fdata->pgoff, 1);
-
-	/*
 	 * Do we have something in the page cache already?
 	 */
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
+	/*
+	 * For sequential accesses, we use the generic readahead logic.
+	 */
+	if (VM_SequentialReadHint(vma)) {
+		if (!page) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   fdata->pgoff, 1);
+			page = find_lock_page(mapping, fdata->pgoff);
+			if (!page)
+				goto no_cached_page;
+		}
+		if (PageReadahead(page)) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   fdata->pgoff, 1);
+		}
+	}
+
 	if (!page) {
 		unsigned long ra_pages;
 
-		if (VM_SequentialReadHint(vma)) {
-			handle_ra_miss(mapping, ra, fdata->pgoff);
-			goto no_cached_page;
-		}
 		ra->mmap_miss++;
 
 		/*
@@ -1442,6 +1452,7 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
+	ra->prev_index = page->index;
 	return page;
 
 outside_data_content:
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
