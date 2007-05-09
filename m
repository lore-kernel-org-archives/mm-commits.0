From: akpm@linux-foundation.org
Subject: - reiser4-use-simple_prepare_write-to-zero-page-data.patch removed from -mm tree
Date: Wed, 09 May 2007 03:07:45 -0700
Message-ID: <200705091007.l49A7j5u020883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156AbXEIKI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use simple_prepare_write to zero page data
has been removed from the -mm tree.  Its filename was
     reiser4-use-simple_prepare_write-to-zero-page-data.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use simple_prepare_write to zero page data
From: Nate Diller <nate.diller@gmail.com>

It's common for file systems to need to zero data on either side of a
write, if a page is not Uptodate during prepare_write.  It just so happens
that simple_prepare_write() in libfs.c does exactly that, so we can avoid
duplication and just call that function to zero page data.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-simple_prepare_write-to-zero-page-data fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-simple_prepare_write-to-zero-page-data
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1040,16 +1040,9 @@ ssize_t reiser4_write_extent(struct file
 		BUG_ON(get_current_context()->trans->atom != NULL);
 
 		lock_page(page);
-		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
-			void *kaddr;
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, page_off);
-			memset(kaddr + page_off + to_page, 0,
-			       PAGE_CACHE_SIZE - (page_off + to_page));
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE)
+			simple_prepare_write(file, page, page_off,
+					     page_off + to_page);
 
 		written = filemap_copy_from_user(page, page_off, buf, to_page);
 		flush_dcache_page(page);
_

Patches currently in -mm which might be from nate.diller@gmail.com are

fs-convert-core-functions-to-zero_user_page.patch
affs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ecryptfs-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
xfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
reiser4-use-zero_user_page.patch
