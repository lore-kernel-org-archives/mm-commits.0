From: akpm@linux-foundation.org
Subject: - readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:02 -0700
Message-ID: <200710162031.l9GKV2wa014462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966213AbXJPVtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: remove the local copy of ra in do_generic_mapping_read()
has been removed from the -mm tree.  Its filename was
     readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: remove the local copy of ra in do_generic_mapping_read()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The local copy of ra in do_generic_mapping_read() can now go away.

It predates readanead(req_size).  In a time when the readahead code was called
on *every* single page.  Hence a local has to be made to reduce the chance of
the readahead state being overwritten by a concurrent reader.  More details
in: Linux: Random File I/O Regressions In 2.6
<http://kerneltrap.org/node/3039>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/filemap.c~readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read mm/filemap.c
--- a/mm/filemap.c~readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read
+++ a/mm/filemap.c
@@ -859,7 +859,7 @@ static void shrink_readahead_size_eio(st
  * It may be NULL.
  */
 void do_generic_mapping_read(struct address_space *mapping,
-			     struct file_ra_state *_ra,
+			     struct file_ra_state *ra,
 			     struct file *filp,
 			     loff_t *ppos,
 			     read_descriptor_t *desc,
@@ -874,13 +874,12 @@ void do_generic_mapping_read(struct addr
 	unsigned int prev_offset;
 	struct page *cached_page;
 	int error;
-	struct file_ra_state ra = *_ra;
 
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_pos >> PAGE_CACHE_SHIFT;
-	prev_offset = ra.prev_pos & (PAGE_CACHE_SIZE-1);
+	prev_index = ra->prev_pos >> PAGE_CACHE_SHIFT;
+	prev_offset = ra->prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -895,7 +894,7 @@ find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(mapping,
-					&ra, filp,
+					ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
@@ -903,7 +902,7 @@ find_page:
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
-					&ra, filp, page,
+					ra, filp, page,
 					index, last_index - index);
 		}
 		if (!PageUptodate(page))
@@ -1014,7 +1013,7 @@ readpage:
 				}
 				unlock_page(page);
 				error = -EIO;
-				shrink_readahead_size_eio(filp, &ra);
+				shrink_readahead_size_eio(filp, ra);
 				goto readpage_error;
 			}
 			unlock_page(page);
@@ -1054,10 +1053,9 @@ no_cached_page:
 	}
 
 out:
-	*_ra = ra;
-	_ra->prev_pos = prev_index;
-	_ra->prev_pos <<= PAGE_CACHE_SHIFT;
-	_ra->prev_pos |= prev_offset;
+	ra->prev_pos = prev_index;
+	ra->prev_pos <<= PAGE_CACHE_SHIFT;
+	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
