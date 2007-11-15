From: akpm@linux-foundation.org
Subject: - ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:07:52 -0800
Message-ID: <200711152107.lAFL7qEh015299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765576AbXKOVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: cast page->index to loff_t instead of off_t
has been removed from the -mm tree.  Its filename was
     ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: cast page->index to loff_t instead of off_t
From: Michael Halcrow <mhalcrow@us.ibm.com>

page->index should be cast to loff_t instead of off_t.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/read_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/read_write.c~ecryptfs-cast-page-index-to-loff_t-instead-of-off_t fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-cast-page-index-to-loff_t-instead-of-off_t
+++ a/fs/ecryptfs/read_write.c
@@ -87,7 +87,7 @@ int ecryptfs_write_lower_page_segment(st
 	loff_t offset;
 	int rc;
 
-	offset = ((((off_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
+	offset = ((((loff_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
 		  + offset_in_page);
 	virt = kmap(page_for_lower);
 	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
d_path-make-d_path-use-a-struct-path.patch
