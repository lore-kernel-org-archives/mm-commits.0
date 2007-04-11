From: akpm@linux-foundation.org
Subject: + gfs2-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:17:59 -0700
Message-ID: <200704110618.l3B6HxQQ030119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161228AbXDKGSD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     gfs2: use zero_user_page
has been added to the -mm tree.  Its filename is
     gfs2-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gfs2: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/bmap.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/gfs2/bmap.c~gfs2-use-zero_user_page fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~gfs2-use-zero_user_page
+++ a/fs/gfs2/bmap.c
@@ -885,7 +885,6 @@ static int gfs2_block_truncate_page(stru
 	unsigned blocksize, iblock, length, pos;
 	struct buffer_head *bh;
 	struct page *page;
-	void *kaddr;
 	int err;
 
 	page = grab_cache_page(mapping, index);
@@ -933,10 +932,7 @@ static int gfs2_block_truncate_page(stru
 	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);
 
 unlock:
 	unlock_page(page);
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
affs-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
xfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
reiser4-use-zero_user_page.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
