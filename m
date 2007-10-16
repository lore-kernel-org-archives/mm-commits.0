From: akpm@linux-foundation.org
Subject: - readahead-remove-several-readahead-macros.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:04 -0700
Message-ID: <200710162031.l9GKV4RO014465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966047AbXJPVpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: remove several readahead macros
has been removed from the -mm tree.  Its filename was
     readahead-remove-several-readahead-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1106,8 +1106,6 @@ int write_one_page(struct page *page, in
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
@@ -22,16 +22,8 @@ void default_unplug_io_fn(struct backing
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
