From: akpm@linux-foundation.org
Subject: - ntfs-use-zero_user_page.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:20 -0700
Message-ID: <200705130514.l4D5EKgX022710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbXEMFO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     ntfs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ntfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

[akpm@linux-foundation.org: kmap-type fixes]
Signed-off-by: Nate Diller <nate.diller@gmail.com>
Acked-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/aops.c |   36 +++++++---------------------
 fs/ntfs/file.c |   59 +++++++++++++----------------------------------
 2 files changed, 26 insertions(+), 69 deletions(-)

diff -puN fs/ntfs/aops.c~ntfs-use-zero_user_page fs/ntfs/aops.c
--- a/fs/ntfs/aops.c~ntfs-use-zero_user_page
+++ a/fs/ntfs/aops.c
@@ -86,19 +86,15 @@ static void ntfs_end_buffer_async_read(s
 		}
 		/* Check for the current buffer head overflowing. */
 		if (unlikely(file_ofs + bh->b_size > init_size)) {
-			u8 *kaddr;
 			int ofs;
 
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
-			memset(kaddr + bh_offset(bh) + ofs, 0,
-					bh->b_size - ofs);
-			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+			zero_user_page(page, bh_offset(bh) + ofs,
+					 bh->b_size - ofs, KM_BIO_SRC_IRQ);
 			local_irq_restore(flags);
-			flush_dcache_page(page);
 		}
 	} else {
 		clear_buffer_uptodate(bh);
@@ -245,8 +241,7 @@ static int ntfs_read_block(struct page *
 	rl = NULL;
 	nr = i = 0;
 	do {
-		u8 *kaddr;
-		int err;
+		int err = 0;
 
 		if (unlikely(buffer_uptodate(bh)))
 			continue;
@@ -254,7 +249,6 @@ static int ntfs_read_block(struct page *
 			arr[nr++] = bh;
 			continue;
 		}
-		err = 0;
 		bh->b_bdev = vol->sb->s_bdev;
 		/* Is the block within the allowed limits? */
 		if (iblock < lblock) {
@@ -340,10 +334,7 @@ handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + i * blocksize, 0, blocksize);
-		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		zero_user_page(page, i * blocksize, blocksize, KM_USER0);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -460,10 +451,7 @@ retry_readpage:
 	 * ok to ignore the compressed flag here.
 	 */
 	if (unlikely(page->index > 0)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 		goto done;
 	}
 	if (!NInoAttr(ni))
@@ -790,14 +778,10 @@ lock_retry_remap:
 		 * uptodate so it can get discarded by the VM.
 		 */
 		if (err == -ENOENT || lcn == LCN_ENOENT) {
-			u8 *kaddr;
-
 			bh->b_blocknr = -1;
 			clear_buffer_dirty(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + bh_offset(bh), 0, blocksize);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_user_page(page, bh_offset(bh), blocksize,
+					KM_USER0);
 			set_buffer_uptodate(bh);
 			err = 0;
 			continue;
@@ -1422,10 +1406,8 @@ retry_writepage:
 		if (page->index >= (i_size >> PAGE_CACHE_SHIFT)) {
 			/* The page straddles i_size. */
 			unsigned int ofs = i_size & ~PAGE_CACHE_MASK;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + ofs, 0, PAGE_CACHE_SIZE - ofs);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_user_page(page, ofs, PAGE_CACHE_SIZE - ofs,
+					KM_USER0);
 		}
 		/* Handle mst protected attributes. */
 		if (NInoMstProtected(ni))
diff -puN fs/ntfs/file.c~ntfs-use-zero_user_page fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-use-zero_user_page
+++ a/fs/ntfs/file.c
@@ -606,11 +606,8 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
-							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
+					zero_user_page(page, bh_offset(bh),
+							blocksize, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -685,12 +682,9 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						u8 *kaddr = kmap_atomic(page,
-								KM_USER0);
-						memset(kaddr + bh_offset(bh),
-								0, blocksize);
-						kunmap_atomic(kaddr, KM_USER0);
-						flush_dcache_page(page);
+						zero_user_page(page,
+							bh_offset(bh),
+							blocksize, KM_USER0);
 						set_buffer_uptodate(bh);
 					}
 				}
@@ -708,11 +702,8 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
-							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
+					zero_user_page(page, bh_offset(bh),
+							blocksize, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 				mark_buffer_dirty(bh);
@@ -751,10 +742,8 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				u8 *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh), 0, blocksize);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
+				zero_user_page(page, bh_offset(bh), blocksize,
+						KM_USER0);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -878,11 +867,8 @@ rl_not_mapped_enoent:
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
-							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
+					zero_user_page(page, bh_offset(bh),
+							blocksize, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 				continue;
@@ -1137,16 +1123,12 @@ rl_not_mapped_enoent:
 			 * to zero the overflowing region.
 			 */
 			if (unlikely(bh_pos + blocksize > initialized_size)) {
-				u8 *kaddr;
 				int ofs = 0;
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh) + ofs, 0,
-						blocksize - ofs);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
+				zero_user_page(page, bh_offset(bh) + ofs,
+						blocksize - ofs, KM_USER0);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1286,11 +1268,8 @@ rl_not_mapped_enoent:
 				if (PageUptodate(page))
 					set_buffer_uptodate(bh);
 				else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
-							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
+					zero_user_page(page, bh_offset(bh),
+							blocksize, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1350,9 +1329,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(*pages, 0, len, KM_USER0);
 	}
 	goto out;
 }
@@ -1473,9 +1450,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(*pages, 0, len, KM_USER0);
 	}
 	goto out;
 }
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
git-gfs2-nmw.patch
nfs-use-zero_user_page.patch
git-ocfs2.patch
xfs-use-zero_user_page.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch
