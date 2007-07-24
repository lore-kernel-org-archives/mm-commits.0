From: akpm@linux-foundation.org
Subject: + filemap-trivial-code-cleanups.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:24 -0700
Message-ID: <200707240353.l6O3rOTc026896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbXGXDyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au


The patch titled
     filemap: trivial code cleanups
has been added to the -mm tree.  Its filename is
     filemap-trivial-code-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: filemap: trivial code cleanups
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- remove unused local next_index in do_generic_mapping_read()
- wrap a long line
- remove a redudant page_cache_read() declaration

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~filemap-trivial-code-cleanups mm/filemap.c
--- a/mm/filemap.c~filemap-trivial-code-cleanups
+++ a/mm/filemap.c
@@ -869,7 +869,6 @@ void do_generic_mapping_read(struct addr
 	unsigned long index;
 	unsigned long offset;
 	unsigned long last_index;
-	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
 	struct page *cached_page;
@@ -877,7 +876,6 @@ void do_generic_mapping_read(struct addr
 
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
-	next_index = index;
 	prev_index = ra->prev_pos >> PAGE_CACHE_SHIFT;
 	prev_offset = ra->prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
@@ -1217,7 +1215,8 @@ out:
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size)
+int file_send_actor(read_descriptor_t * desc, struct page *page,
+			unsigned long offset, unsigned long size)
 {
 	ssize_t written;
 	unsigned long count = desc->count;
@@ -1270,7 +1269,6 @@ asmlinkage ssize_t sys_readahead(int fd,
 }
 
 #ifdef CONFIG_MMU
-static int FASTCALL(page_cache_read(struct file * file, unsigned long offset));
 /**
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read
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
