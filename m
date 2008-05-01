From: akpm@linux-foundation.org
Subject: - reiser4-portion-of-zero_user-cleanup-patch.patch removed from -mm tree
Date: Thu, 01 May 2008 02:16:54 -0700
Message-ID: <200805010916.m419Gs8Y029787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbYEAJQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4 portion of zero_user cleanup patch
has been removed from the -mm tree.  Its filename was
     reiser4-portion-of-zero_user-cleanup-patch.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Reiser4 portion of zero_user cleanup patch
From: Christoph Lameter <clameter@sgi.com>

Reiser4 only exists in mm. So split this off.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |    8 +++-----
 fs/reiser4/plugin/file/file.c            |    4 ++--
 fs/reiser4/plugin/item/ctail.c           |    8 ++++----
 fs/reiser4/plugin/item/extent_file_ops.c |    4 ++--
 fs/reiser4/plugin/item/tail.c            |    3 +--
 5 files changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-portion-of-zero_user-cleanup-patch fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-portion-of-zero_user-cleanup-patch
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2056,7 +2056,7 @@ static int write_hole(struct inode *inod
 
 		to_pg = min((typeof(pg_off))PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
-		zero_user_page(page, pg_off, to_pg, KM_USER0);
+		zero_user(page, pg_off, to_pg);
 		SetPageUptodate(page);
 		reiser4_set_page_dirty_internal(page);
 		mark_page_accessed(page);
@@ -2294,8 +2294,7 @@ static int read_some_cluster_pages(struc
 			off = off_to_pgoff(win->off+win->count+win->delta);
 			if (off) {
 				lock_page(pg);
-				zero_user_page(pg, off, PAGE_CACHE_SIZE - off,
-						KM_USER0);
+				zero_user_segment(pg, off, PAGE_CACHE_SIZE);
 				unlock_page(pg);
 			}
 		}
@@ -2342,8 +2341,7 @@ static int read_some_cluster_pages(struc
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
-			zero_user_page(pg, offset, PAGE_CACHE_SIZE - offset,
-					KM_USER0);
+			zero_user_segment(pg, offset, PAGE_CACHE_SIZE);
 			unlock_page(pg);
 			/* still not uptodate */
 			break;
diff -puN fs/reiser4/plugin/file/file.c~reiser4-portion-of-zero_user-cleanup-patch fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-portion-of-zero_user-cleanup-patch
+++ a/fs/reiser4/plugin/file/file.c
@@ -532,7 +532,7 @@ static int shorten_file(struct inode *in
 
 	lock_page(page);
 	assert("vs-1066", PageLocked(page));
-	zero_user_page(page, padd_from, PAGE_CACHE_SIZE - padd_from, KM_USER0);
+	zero_user_segment(page, padd_from, PAGE_CACHE_SIZE);
 	unlock_page(page);
 	page_cache_release(page);
 	/* the below does up(sbinfo->delete_mutex). Do not get confused */
@@ -1433,7 +1433,7 @@ int readpage_unix_file(struct file *file
 
 	if (page->mapping->host->i_size <= page_offset(page)) {
 		/* page is out of file */
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		unlock_page(page);
 		return 0;
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-portion-of-zero_user-cleanup-patch fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-portion-of-zero_user-cleanup-patch
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -638,7 +638,7 @@ int do_readpage_ctail(struct inode * ino
 		goto exit;
 	to_page = pbytes(page_index(page), inode);
 	if (to_page == 0) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		goto exit;
 	}
@@ -655,7 +655,7 @@ int do_readpage_ctail(struct inode * ino
 		/* refresh bytes */
 		to_page = pbytes(page_index(page), inode);
 		if (to_page == 0) {
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			zero_user(page, 0, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 			goto exit;
 		}
@@ -678,7 +678,7 @@ int do_readpage_ctail(struct inode * ino
 		 */
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
@@ -788,7 +788,7 @@ static int ctail_readpages_filler(void *
 		return 0;
 	}
 	if (pbytes(page_index(page), inode) == 0) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		unlock_page(page);
 		return 0;
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-portion-of-zero_user-cleanup-patch fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-portion-of-zero_user-cleanup-patch
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1136,7 +1136,7 @@ int reiser4_do_readpage_extent(reiser4_e
 		 */
 		j = jfind(mapping, index);
 		if (j == NULL) {
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			zero_user(page, 0, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 			unlock_page(page);
 			return 0;
@@ -1151,7 +1151,7 @@ int reiser4_do_readpage_extent(reiser4_e
 		block = *jnode_get_io_block(j);
 		spin_unlock_jnode(j);
 		if (block == 0) {
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			zero_user(page, 0, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 			unlock_page(page);
 			jput(j);
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-portion-of-zero_user-cleanup-patch fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-portion-of-zero_user-cleanup-patch
+++ a/fs/reiser4/plugin/item/tail.c
@@ -392,8 +392,7 @@ static int do_readpage_tail(uf_coord_t *
 
  done:
 	if (mapped != PAGE_CACHE_SIZE)
-		zero_user_page(page, mapped, PAGE_CACHE_SIZE - mapped,
-				KM_USER0);
+		zero_user_segment(page, mapped, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
  out_unlock_page:
 	unlock_page(page);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
remove-div_long_long_rem.patch
git-unionfs.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

