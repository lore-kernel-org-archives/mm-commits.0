From: akpm@linux-foundation.org
Subject: + readahead-remove-several-readahead-macros.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:19 -0700
Message-ID: <200707240353.l6O3rJ2v026888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbXGXDyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au


The patch titled
     readahead: remove several readahead macros
has been added to the -mm tree.  Its filename is
     readahead-remove-several-readahead-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: remove several readahead macros
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove VM_MAX_CACHE_HIT, MAX_RA_PAGES and MIN_RA_PAGES.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/readahead.c     |   10 +---------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff -puN include/linux/mm.h~readahead-remove-several-readahead-macros include/linux/mm.h
--- a/include/linux/mm.h~readahead-remove-several-readahead-macros
+++ a/include/linux/mm.h
@@ -1132,8 +1132,6 @@ int write_one_page(struct page *page, in
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
-#define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
-					 * turning readahead off */
 
 int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
diff -puN mm/readahead.c~readahead-remove-several-readahead-macros mm/readahead.c
--- a/mm/readahead.c~readahead-remove-several-readahead-macros
+++ a/mm/readahead.c
@@ -21,16 +21,8 @@ void default_unplug_io_fn(struct backing
 }
 EXPORT_SYMBOL(default_unplug_io_fn);
 
-/*
- * Convienent macros for min/max read-ahead pages.
- * Note that MAX_RA_PAGES is rounded down, while MIN_RA_PAGES is rounded up.
- * The latter is necessary for systems with large page size(i.e. 64k).
- */
-#define MAX_RA_PAGES	(VM_MAX_READAHEAD*1024 / PAGE_CACHE_SIZE)
-#define MIN_RA_PAGES	DIV_ROUND_UP(VM_MIN_READAHEAD*1024, PAGE_CACHE_SIZE)
-
 struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= MAX_RA_PAGES,
+	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
 	.unplug_io_fn	= default_unplug_io_fn,
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
radixtree-introduce-radix_tree_scan_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
convert-ill-defined-log2-to-ilog2.patch
