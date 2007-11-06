From: akpm@linux-foundation.org
Subject: + ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:01:39 -0800
Message-ID: <200711060001.lA601d3E026579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbXKFACL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:02:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, sandeen@redhat.com


The patch titled
     eCryptfs: cast page->index to loff_t instead of off_t
has been added to the -mm tree.  Its filename is
     ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-increment-extent_offset-once-per-loop-interation.patch
ecryptfs-release-mutex-on-hash-error-path.patch
ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
d_path-make-d_path-use-a-struct-path.patch
