From: akpm@linux-foundation.org
Subject: - readahead-convert-filemap-invocations.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:14 -0700
Message-ID: <200707192001.l6JK1E87019519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149AbXGSU2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: convert filemap invocations
has been removed from the -mm tree.  Its filename was
     readahead-convert-filemap-invocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN mm/filemap.c~readahead-convert-filemap-invocations mm/filemap.c
--- a/mm/filemap.c~readahead-convert-filemap-invocations
+++ a/mm/filemap.c
@@ -891,15 +891,20 @@ void do_generic_mapping_read(struct addr
 		unsigned long nr, ret;
 
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
@@ -1051,6 +1056,7 @@ no_cached_page:
 
 out:
 	*_ra = ra;
+	_ra->prev_index = prev_index;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
@@ -1333,26 +1339,30 @@ int filemap_fault(struct vm_area_struct 
 		goto no_cached_page;
 
 	/*
-	 * The readahead code wants to be told about each and every page
-	 * so it can build and shrink its windows appropriately
-	 *
-	 * For sequential accesses, we use the generic readahead logic.
-	 */
-	if (VM_SequentialReadHint(vma))
-		page_cache_readahead(mapping, ra, file, vmf->pgoff, 1);
-
-	/*
 	 * Do we have something in the page cache already?
 	 */
 retry_find:
 	page = find_lock_page(mapping, vmf->pgoff);
+	/*
+	 * For sequential accesses, we use the generic readahead logic.
+	 */
+	if (VM_SequentialReadHint(vma)) {
+		if (!page) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   vmf->pgoff, 1);
+			page = find_lock_page(mapping, vmf->pgoff);
+			if (!page)
+				goto no_cached_page;
+		}
+		if (PageReadahead(page)) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   vmf->pgoff, 1);
+		}
+	}
+
 	if (!page) {
 		unsigned long ra_pages;
 
-		if (VM_SequentialReadHint(vma)) {
-			handle_ra_miss(mapping, ra, vmf->pgoff);
-			goto no_cached_page;
-		}
 		ra->mmap_miss++;
 
 		/*
@@ -1405,6 +1415,7 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
+	ra->prev_index = page->index;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
