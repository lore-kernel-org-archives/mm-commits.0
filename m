From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-fs-libfsc.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:49 -0800
Message-ID: <200803041947.m24Jln7w025699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbYCDTtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx in fs/libfs.c
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-fs-libfsc.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in fs/libfs.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in fs/libfs.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/libfs.c~use-page_cache_xxx-in-fs-libfsc fs/libfs.c
--- a/fs/libfs.c~use-page_cache_xxx-in-fs-libfsc
+++ a/fs/libfs.c
@@ -17,7 +17,8 @@ int simple_getattr(struct vfsmount *mnt,
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
-	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
+	stat->blocks = inode->i_mapping->nrpages <<
+				(page_cache_shift(inode->i_mapping) - 9);
 	return 0;
 }
 
@@ -341,10 +342,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE)
+		if (to - from != page_cache_size(file->f_mapping))
 			zero_user_segments(page,
 				0, from,
-				to, PAGE_CACHE_SIZE);
+				to, page_cache_size(file->f_mapping));
 	}
 	return 0;
 }
@@ -372,8 +373,9 @@ int simple_write_begin(struct file *file
 static int simple_commit_write(struct file *file, struct page *page,
 			       unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

