From: akpm@linux-foundation.org
Subject: + ntfs-use-bitmap_weight.patch added to -mm tree
Date: Wed, 18 Nov 2009 12:28:40 -0800
Message-ID: <200911182028.nAIKSeA5029092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932312AbZKRU2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 15:28:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, aia21@cantab.net


The patch titled
     ntfs: use bitmap_weight
has been added to the -mm tree.  Its filename is
     ntfs-use-bitmap_weight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: use bitmap_weight
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitmap_weight() instead of doing hweight32() for each u32 element in
the page.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/super.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN fs/ntfs/super.c~ntfs-use-bitmap_weight fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-use-bitmap_weight
+++ a/fs/ntfs/super.c
@@ -31,6 +31,7 @@
 #include <linux/vfs.h>
 #include <linux/moduleparam.h>
 #include <linux/smp_lock.h>
+#include <linux/bitmap.h>
 
 #include "sysctl.h"
 #include "logfile.h"
@@ -2457,7 +2458,6 @@ static void ntfs_put_super(struct super_
 static s64 get_nr_free_clusters(ntfs_volume *vol)
 {
 	s64 nr_free = vol->nr_clusters;
-	u32 *kaddr;
 	struct address_space *mapping = vol->lcnbmp_ino->i_mapping;
 	struct page *page;
 	pgoff_t index, max_index;
@@ -2476,7 +2476,8 @@ static s64 get_nr_free_clusters(ntfs_vol
 	ntfs_debug("Reading $Bitmap, max_index = 0x%lx, max_size = 0x%lx.",
 			max_index, PAGE_CACHE_SIZE / 4);
 	for (index = 0; index < max_index; index++) {
-		unsigned int i;
+		unsigned long *kaddr;
+
 		/*
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
@@ -2489,16 +2490,16 @@ static s64 get_nr_free_clusters(ntfs_vol
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
-		 * For each 4 bytes, subtract the number of set bits. If this
+		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
 		 * it just means we do a little extra work but it won't affect
 		 * the result as all out of range bytes are set to zero by
 		 * ntfs_readpage().
 		 */
-	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
-			nr_free -= (s64)hweight32(kaddr[i]);
+		nr_free -= bitmap_weight(kaddr,
+					PAGE_CACHE_SIZE * BITS_PER_BYTE);
 		kunmap_atomic(kaddr, KM_USER0);
 		page_cache_release(page);
 	}
@@ -2537,7 +2538,6 @@ static s64 get_nr_free_clusters(ntfs_vol
 static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 		s64 nr_free, const pgoff_t max_index)
 {
-	u32 *kaddr;
 	struct address_space *mapping = vol->mftbmp_ino->i_mapping;
 	struct page *page;
 	pgoff_t index;
@@ -2547,7 +2547,8 @@ static unsigned long __get_nr_free_mft_r
 	ntfs_debug("Reading $MFT/$BITMAP, max_index = 0x%lx, max_size = "
 			"0x%lx.", max_index, PAGE_CACHE_SIZE / 4);
 	for (index = 0; index < max_index; index++) {
-		unsigned int i;
+		unsigned long *kaddr;
+
 		/*
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
@@ -2560,16 +2561,16 @@ static unsigned long __get_nr_free_mft_r
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
-		 * For each 4 bytes, subtract the number of set bits. If this
+		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
 		 * it just means we do a little extra work but it won't affect
 		 * the result as all out of range bytes are set to zero by
 		 * ntfs_readpage().
 		 */
-	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
-			nr_free -= (s64)hweight32(kaddr[i]);
+		nr_free -= bitmap_weight(kaddr,
+					PAGE_CACHE_SIZE * BITS_PER_BYTE);
 		kunmap_atomic(kaddr, KM_USER0);
 		page_cache_release(page);
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ntfs-use-bitmap_weight.patch
hpfs-use-hweight32.patch
hpfs-use-bitmap_weight.patch
qnx4-use-hweight8.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

