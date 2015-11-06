From: akpm@linux-foundation.org
Subject: [merged] mm-use-only-per-device-readahead-limit.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:05 -0800
Message-ID: <563d08a5.wuJV3L14sCzlj3uy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033572AbbKFUIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klamm@yandex-team.ru, fengguang.wu@intel.com, jack@suse.cz, khlebnikov@yandex-team.ru, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use only per-device readahead limit
has been removed from the -mm tree.  Its filename was
     mm-use-only-per-device-readahead-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <klamm@yandex-team.ru>
Subject: mm: use only per-device readahead limit

Maximal readahead size is limited now by two values:
1) by global 2Mb constant (MAX_READAHEAD in max_sane_readahead())
2) by configurable per-device value* (bdi->ra_pages)

There are devices, which require custom readahead limit.
For instance, for RAIDs it's calculated as number of devices
multiplied by chunk size times 2.

Readahead size can never be larger than bdi->ra_pages * 2 value
(POSIX_FADV_SEQUNTIAL doubles readahead size).

If so, why do we need two limits?
I suggest to completely remove this max_sane_readahead() stuff and
use per-device readahead limit everywhere.

Also, using right readahead size for RAID disks can significantly
increase i/o performance:

before:
dd if=/dev/md2 of=/dev/null bs=100M count=100
100+0 records in
100+0 records out
10485760000 bytes (10 GB) copied, 12.9741 s, 808 MB/s

after:
$ dd if=/dev/md2 of=/dev/null bs=100M count=100
100+0 records in
100+0 records out
10485760000 bytes (10 GB) copied, 8.91317 s, 1.2 GB/s

(It's an 8-disks RAID5 storage).

This patch doesn't change sys_readahead and madvise(MADV_WILLNEED)
behavior introduced by 6d2be915e589b58 ("mm/readahead.c: fix readahead
failure for memoryless NUMA nodes and limit readahead pages").

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: onstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/filemap.c       |    8 +++-----
 mm/readahead.c     |   14 ++------------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff -puN include/linux/mm.h~mm-use-only-per-device-readahead-limit include/linux/mm.h
--- a/include/linux/mm.h~mm-use-only-per-device-readahead-limit
+++ a/include/linux/mm.h
@@ -2036,8 +2036,6 @@ void page_cache_async_readahead(struct a
 				pgoff_t offset,
 				unsigned long size);
 
-unsigned long max_sane_readahead(unsigned long nr);
-
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 
diff -puN mm/filemap.c~mm-use-only-per-device-readahead-limit mm/filemap.c
--- a/mm/filemap.c~mm-use-only-per-device-readahead-limit
+++ a/mm/filemap.c
@@ -1807,7 +1807,6 @@ static void do_sync_mmap_readahead(struc
 				   struct file *file,
 				   pgoff_t offset)
 {
-	unsigned long ra_pages;
 	struct address_space *mapping = file->f_mapping;
 
 	/* If we don't want any read-ahead, don't bother */
@@ -1836,10 +1835,9 @@ static void do_sync_mmap_readahead(struc
 	/*
 	 * mmap read-around
 	 */
-	ra_pages = max_sane_readahead(ra->ra_pages);
-	ra->start = max_t(long, 0, offset - ra_pages / 2);
-	ra->size = ra_pages;
-	ra->async_size = ra_pages / 4;
+	ra->start = max_t(long, 0, offset - ra->ra_pages / 2);
+	ra->size = ra->ra_pages;
+	ra->async_size = ra->ra_pages / 4;
 	ra_submit(ra, mapping, file);
 }
 
diff -puN mm/readahead.c~mm-use-only-per-device-readahead-limit mm/readahead.c
--- a/mm/readahead.c~mm-use-only-per-device-readahead-limit
+++ a/mm/readahead.c
@@ -213,7 +213,7 @@ int force_page_cache_readahead(struct ad
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
-	nr_to_read = max_sane_readahead(nr_to_read);
+	nr_to_read = min(nr_to_read, inode_to_bdi(mapping->host)->ra_pages);
 	while (nr_to_read) {
 		int err;
 
@@ -232,16 +232,6 @@ int force_page_cache_readahead(struct ad
 	return 0;
 }
 
-#define MAX_READAHEAD   ((512*4096)/PAGE_CACHE_SIZE)
-/*
- * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
- * sensible upper limit.
- */
-unsigned long max_sane_readahead(unsigned long nr)
-{
-	return min(nr, MAX_READAHEAD);
-}
