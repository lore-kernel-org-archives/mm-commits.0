From: akpm@linux-foundation.org
Subject: - filemap-trivial-code-cleanups.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:08 -0700
Message-ID: <200710162031.l9GKV8Jq014473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965870AbXJPVmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     filemap: trivial code cleanups
has been removed from the -mm tree.  Its filename was
     filemap-trivial-code-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: filemap: trivial code cleanups
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- remove unused local next_index in do_generic_mapping_read()
- remove a redudant page_cache_read() declaration

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ---
 1 file changed, 3 deletions(-)

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
@@ -1250,7 +1248,6 @@ asmlinkage ssize_t sys_readahead(int fd,
 }
 
 #ifdef CONFIG_MMU
-static int FASTCALL(page_cache_read(struct file * file, unsigned long offset));
 /**
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read
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
