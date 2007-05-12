From: akpm@linux-foundation.org
Subject: - gfs2-use-zero_user_page.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:11 -0700
Message-ID: <200705120536.l4C5aBJ3002355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430AbXELFgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2: use zero_user_page
has been removed from the -mm tree.  Its filename was
     gfs2-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gfs2: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
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

origin.patch
ntfs-use-zero_user_page.patch
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
