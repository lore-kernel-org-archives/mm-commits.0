From: akpm@linux-foundation.org
Subject: - readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:05 -0700
Message-ID: <200707192001.l6JK15dr019507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175AbXGSU2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: add look-ahead support to __do_page_cache_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: add look-ahead support to __do_page_cache_readahead()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Add look-ahead support to __do_page_cache_readahead().

It works by
	- mark the Nth backwards page with PG_readahead,
	(which instructs the page's first reader to invoke readahead)
	- and only do the marking for newly allocated pages.
	(to prevent blindly doing readahead on already cached pages)

Look-ahead is a technique to achieve I/O pipelining:

While the application is working through a chunk of cached pages, the kernel
reads-ahead the next chunk of pages _before_ time of need.  It effectively
hides low level I/O latencies to high level applications.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/readahead.c~readahead-add-look-ahead-support-to-__do_page_cache_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-add-look-ahead-support-to-__do_page_cache_readahead
+++ a/mm/readahead.c
@@ -265,7 +265,8 @@ out:
  */
 static int
 __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read)
+			pgoff_t offset, unsigned long nr_to_read,
+			unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
 	struct page *page;
@@ -278,7 +279,7 @@ __do_page_cache_readahead(struct address
 	if (isize == 0)
 		goto out;
 
- 	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -301,6 +302,8 @@ __do_page_cache_readahead(struct address
 			break;
 		page->index = page_offset;
 		list_add(&page->lru, &page_pool);
+		if (page_idx == nr_to_read - lookahead_size)
+			SetPageReadahead(page);
 		ret++;
 	}
 	read_unlock_irq(&mapping->tree_lock);
@@ -337,7 +340,7 @@ int force_page_cache_readahead(struct ad
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
 		err = __do_page_cache_readahead(mapping, filp,
-						offset, this_chunk);
+						offset, this_chunk, 0);
 		if (err < 0) {
 			ret = err;
 			break;
@@ -384,7 +387,7 @@ int do_page_cache_readahead(struct addre
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return -1;
 
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read);
+	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 }
 
 /*
@@ -404,7 +407,7 @@ blockable_page_cache_readahead(struct ad
 	if (!block && bdi_read_congested(mapping->backing_dev_info))
 		return 0;
 
-	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read);
+	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
 	return check_ra_success(ra, nr_to_read, actual);
 }
@@ -449,7 +452,7 @@ static int make_ahead_window(struct addr
  * @req_size: hint: total size of the read which the caller is performing in
  *            PAGE_CACHE_SIZE units
  *
- * page_cache_readahead() is the main function.  If performs the adaptive
+ * page_cache_readahead() is the main function.  It performs the adaptive
  * readahead window size management and submits the readahead I/O.
  *
  * Note that @filp is purely used for passing on to the ->readpage[s]()
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
